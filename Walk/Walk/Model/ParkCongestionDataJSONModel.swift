//
//  ParkCongestionDataModel.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/23/25.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct ParkCongestionData: Codable {
    let seoulRtdCitydataPpltn: [SeoulRtdCitydataPpltn]

    enum CodingKeys: String, CodingKey {
        case seoulRtdCitydataPpltn = "SeoulRtd.citydata_ppltn"
    }
}

// MARK: - SeoulRtdCitydataPpltn
struct SeoulRtdCitydataPpltn: Codable {
    let areaNm, areaCD: String
    let areaCongestLvl: String

    enum CodingKeys: String, CodingKey {
        case areaNm = "AREA_NM"
        case areaCD = "AREA_CD"
        case areaCongestLvl = "AREA_CONGEST_LVL"
    }
}


