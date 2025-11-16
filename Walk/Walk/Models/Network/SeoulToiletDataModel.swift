//
//  SeoulToiletDataModel.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 2/3/25.
//

import Foundation
import MapKit

struct SeoulToiletDataModel {
    let toiletName: String
    let toiletLat: Double
    let toiletLong: Double
    
    init(toiletName: String, toiletLat: Double, toiletLong: Double) {
        self.toiletName = toiletName
        self.toiletLat = toiletLat
        self.toiletLong = toiletLong
    }
}
