//
//  ParkCongestionDataModel.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/23/25.
//

import Foundation

struct ParkCongestionDataModel {
    let placeName: String?
    let palceCongestLV: String?
    
    init(placeName: String?, palceCongestLV: String?) {
        self.placeName = placeName
        self.palceCongestLV = palceCongestLV
    }
}
