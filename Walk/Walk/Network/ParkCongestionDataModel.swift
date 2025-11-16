//
//  ParkCongestionDataModel.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/23/25.
//

import Foundation

struct ParkCongestionDataModel: Codable {
    let placeName: String?
    let placeCongestLV: String?
    let placeCongestMSG: String?
    
    
    init(placeName: String?, placeCongestLV: String?, placeCongestMSG: String?) {
        self.placeName = placeName
        self.placeCongestLV = placeCongestLV
        self.placeCongestMSG = placeCongestMSG
    }
}
