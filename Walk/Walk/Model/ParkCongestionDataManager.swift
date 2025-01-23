//
//  ParkCongestionDataManager.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/23/25.
//

import Foundation

struct ParkCongestionDataManager {
    
    let parkCongestionURL = "http://openapi.seoul.go.kr:8088//json/citydata_ppltn/1/5/"
    
    func fetchData(placeName: String, completion: @escaping ([ParkCongestionDataModel]?) -> Void) {
        let urlString = "\(parkCongestionURL)\(placeName)"
        performRequest(with: urlString) { congestionData in
            completion(congestionData)
        }
    }
    
    func performRequest(with urlString: String, completion: @escaping ([ParkCongestionDataModel]?) -> Void) {
        
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
            // 데이터 분석하기
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
            let decodedData = try decoder.decode(ParkCongestionData.self, from: parkCongestionData)
            
            let dataList = decodedData.seoulRtdCitydataPpltn
            
            let dataListToArray = dataList.map {
                ParkCongestionDataModel(placeName: $0.areaNm, palceCongestLV: $0.areaCongestLvl)
            }
            return dataListToArray
        } catch {
            print("파싱 실패")
            return nil
        }
    }
    
}
