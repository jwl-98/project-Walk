//
//  ParkCongestionDataModel.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/23/25.
//

import Foundation

// MARK: - Welcome
struct ParkCongestionData: Codable {
    let seoulRtdCitydataPpltn: [SeoulRtdCitydataPpltn]
    let result: Result

    enum CodingKeys: String, CodingKey {
        case seoulRtdCitydataPpltn = "SeoulRtd.citydata_ppltn"
        case result = "RESULT"
    }
}

struct Result: Codable {
    let resultCode, resultMessage: String

    enum CodingKeys: String, CodingKey {
        case resultCode = "RESULT.CODE"
        case resultMessage = "RESULT.MESSAGE"
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


