//
//  ParkCongestionDataManager.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/23/25.
//

import Foundation
import MapKit

struct SeoulDataManager {
    static let shared = SeoulDataManager()
    
    let seoulOpenApiKeys = Bundle.main.infoDictionary?["SEOUL_OPEN_API_KEY"] as! String
    
    func fetchParkCongestionData(placeName: String, completion: @escaping ([ParkCongestionDataModel]?) -> Void) {
        let parkCongestionURL = "http://openapi.seoul.go.kr:8088/\(seoulOpenApiKeys)/json/citydata_ppltn/1/100/"
        let urlString = "\(parkCongestionURL)\(placeName)"
        print("띄어쓰기 사라진 공원 이름: \(placeName)")
        performRequestParkCongestionData(with: urlString) { congestionData in
            completion(congestionData)
        }
    }
    
    func performRequestParkCongestionData(with urlString: String, completion: @escaping ([ParkCongestionDataModel]?) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                completion(nil)
                return
            }
            guard let safeData = data else {
                completion(nil)
                return
            }
            //데이터 분석하기
            if let congestionData = self.parseJSON(safeData) {
                completion(congestionData)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func parseJSON(_ parkCongestionData: Data) -> [ParkCongestionDataModel]? {
        
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(ParkCongestionJSONModel.self, from: parkCongestionData)
            
            let dataList = decodedData.seoulRtdCitydataPpltn
            
            //데이터 리스트 데이터 모델에 매핑
            let dataListToArray = dataList.map {
                ParkCongestionDataModel(placeName: $0.areaNm, palceCongestLV: $0.areaCongestLvl)
            }
            print("파싱성공")
            return dataListToArray
        } catch {
            print(error.localizedDescription)
            print("파싱 실패")
            return nil
        }
    }
    
    func parseToiletLocalJSON() -> [SeoulToiletDataModel]? {
        
        print(#function)
        var toiletDataListArray: [SeoulToiletDataModel]!
        guard let path =  Bundle.main.path(forResource: "서울시공중화장실정보", ofType: "json") else {
            print("json 데이터 없음 ")
            return nil
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data)
            
            if let jsonDic = jsonResult as? [[String: Any]] {
                let seoulToiletData = jsonDic.compactMap { item in
                    if let toiletName = item["대명칭"] as? String,
                       let toiletLat = item["WSG84Y좌표"] as? Double,
                       let toiletLong = item["WSG84X좌표"] as? Double {
                         return SeoulToiletDataModel(toiletName: toiletName, toiletLat: toiletLat, toiletLong: toiletLong)
                    }
                    return nil
                }
                toiletDataListArray = seoulToiletData
            }
            return toiletDataListArray
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}

// MARK: - Event Data Manager Extension(A)
// MARK: - Event Data Methods
// MARK: - Event Data Methods
//이벤트를 가져오는 매니저
extension SeoulDataManager {
    func fetchEventData(parkLocation: CLLocationCoordinate2D, parkName: String, completion: @escaping ([Row]?) -> Void) {
        let eventURL = "http://openapi.seoul.go.kr:8088/\(seoulOpenApiKeys)/json/culturalEventInfo/1/1000/"
        guard let url = URL(string: eventURL) else { return }
        
        let searchKeyword: String
        if parkName.contains("한강공원") {
            searchKeyword = "한강공원"  // 한강공원이 포함된 경우 "한강공원"으로 통일
        } else {
            searchKeyword = parkName.replacingOccurrences(of: "(부분개방부지)", with: "")
                .replacingOccurrences(of: "공원", with: "")
                .trimmingCharacters(in: .whitespaces)
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching event data: \(error)")
                completion(nil)
                return
            }
            
            guard let safeData = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let eventData = try decoder.decode(EventDataModel.self, from: safeData)
                print("전체 이벤트 개수: \(eventData.culturalEventInfo.row.count)")
                
                let parkLocationObj = CLLocation(latitude: parkLocation.latitude, longitude: parkLocation.longitude)
                print("공원 위치: \(parkLocation.latitude), \(parkLocation.longitude)")
                
                
                // 공원 위치 기준으로 1km 이내의 이벤트만 필터링
                let filteredEvents = eventData.culturalEventInfo.row.filter { event in
                    
                    let containsKeyword = event.title.contains(searchKeyword) ||
                    event.place.contains(searchKeyword)
                    
                    guard let eventLong = Double(event.lat),  // lat이 실제로는 경도
                          let eventLat = Double(event.lot) else {  // lot이 실제로는 위도
                        print("위치 정보 변환 실패: lat=\(event.lat), lot=\(event.lot)")
                        return false
                    }
                    
                    let eventLocation = CLLocation(latitude: eventLat, longitude: eventLong)
                    let distance = eventLocation.distance(from: parkLocationObj)
                    
                    if containsKeyword {
                        print("이벤트: \(event.title)")
                        print("이벤트 장소: \(event.place)")
                        print("이벤트 기간: \(String(event.strtdate.prefix(10))) ~ \(String(event.endDate.prefix(10)))")
                        print("------------------------")
                    }
                    
                    return containsKeyword  // 8km 이내
                }
                
                print("필터링 후 이벤트 개수: \(filteredEvents.count)")
                completion(filteredEvents)
            } catch {
                print("Event data parsing error: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}

extension SeoulDataManager {
    func fetchParkInfo(parkName: String, completion: @escaping (InfoData?) -> Void) {
        let parkInfoURL = "http://openAPI.seoul.go.kr:8088/\(seoulOpenApiKeys)/json/SearchParkInfoService/1/130/"
        guard let url = URL(string: parkInfoURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("공원 정보 가져오기 실패 \(error)")
                completion(nil)
                return
            }
            
            guard let safeData = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let parkData = try decoder.decode(ParkInfoDataModel.self, from: safeData)
                
                let matchPark = parkData.searchParkInfoService.row.first {park in
                    
                    if parkName.contains("한강공원") {
                        return park.pPark.contains("한강공원")
                    }
                    return park.pPark == parkName || park.pPark == parkName
                }
                completion(matchPark)
            } catch {
                print("공원 정보 파싱 에러 \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}
