//
//  ParkDataModel.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/20/25.
//

import Foundation

struct ParkSearchResult: Codable {
    let items: [ParkList]
}

struct ParkList: Codable {
    let title: String
}
