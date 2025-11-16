//
//  EventDataModel.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 2/5/25.
//

import Foundation

// MARK: - JSON Event Model (A)
struct EventDataModel: Codable {
    let culturalEventInfo: CulturalEventInfo
}

// MARK: - CulturalEventInfo
struct CulturalEventInfo: Codable {
    let listTotalCount: Int
    let result: ResultData
    let row: [Row]

    enum CodingKeys: String, CodingKey {
        case listTotalCount = "list_total_count"
        case result = "RESULT"
        case row
    }
}

// MARK: - Result
struct ResultData: Codable {
    let code, message: String

    enum CodingKeys: String, CodingKey {
        case code = "CODE"
        case message = "MESSAGE"
    }
}

// MARK: - Row
struct Row: Codable {
    let codename, guname, title, date: String
    let place, orgName, useTrgt, useFee: String
    let player, program, etcDesc: String
    let orgLink, mainImg: String
    let rgstdate, ticket, strtdate, endDate: String
    let themecode, lot, lat, isFree: String
    let hmpgAddr: String

    enum CodingKeys: String, CodingKey {
        case codename = "CODENAME"
        case guname = "GUNAME"
        case title = "TITLE"
        case date = "DATE"
        case place = "PLACE"
        case orgName = "ORG_NAME"
        case useTrgt = "USE_TRGT"
        case useFee = "USE_FEE"
        case player = "PLAYER"
        case program = "PROGRAM"
        case etcDesc = "ETC_DESC"
        case orgLink = "ORG_LINK"
        case mainImg = "MAIN_IMG"
        case rgstdate = "RGSTDATE"
        case ticket = "TICKET"
        case strtdate = "STRTDATE"
        case endDate = "END_DATE"
        case themecode = "THEMECODE"
        case lot = "LOT"
        case lat = "LAT"
        case isFree = "IS_FREE"
        case hmpgAddr = "HMPG_ADDR"
    }
}
