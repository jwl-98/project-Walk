//
//  ParkCongestionDataManager.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/23/25.
//

import Foundation

struct SeoulDataManager {
    static let shared = SeoulDataManager()
    
    let parkCongestionURL = "http://openapi.seoul.go.kr:8088/5a464b67516a303936326f676f6c50/json/citydata_ppltn/1/5/"
    
    func fetchParkCongestionData(placeName: String, completion: @escaping ([ParkCongestionDataModel]?) -> Void) {
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
