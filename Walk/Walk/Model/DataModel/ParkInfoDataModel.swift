//
//  ParkInfoDataModel.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 2/6/25.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct ParkInfoDataModel: Codable {
    let searchParkInfoService: SearchParkInfoService

    enum CodingKeys: String, CodingKey {
        case searchParkInfoService = "SearchParkInfoService"
    }
}

// MARK: - SearchParkInfoService
struct SearchParkInfoService: Codable {
    let listTotalCount: Int
    let result: ResultOfInfo
    let row: [InfoData]

    enum CodingKeys: String, CodingKey {
        case listTotalCount = "list_total_count"
        case result = "RESULT"
        case row
    }
}

// MARK: - Result
struct ResultOfInfo: Codable {
    let code, message: String

    enum CodingKeys: String, CodingKey {
        case code = "CODE"
        case message = "MESSAGE"
    }
}

// MARK: - Row
struct InfoData: Codable {
    let pIdx, pPark, pListContent, area: String
    let openDt, mainEquip, mainPlants: String
    let guidance: String
    let visitRoad, useRefer: String
    let pImg: String
    let pZone, pAddr, pName, pAdmintel: String
    let gLongitude, gLatitude, longitude, latitude: String
    let templateURL: String

    enum CodingKeys: String, CodingKey {
        case pIdx = "P_IDX"
        case pPark = "P_PARK"
        case pListContent = "P_LIST_CONTENT"
        case area = "AREA"
        case openDt = "OPEN_DT"
        case mainEquip = "MAIN_EQUIP"
        case mainPlants = "MAIN_PLANTS"
        case guidance = "GUIDANCE"
        case visitRoad = "VISIT_ROAD"
        case useRefer = "USE_REFER"
        case pImg = "P_IMG"
        case pZone = "P_ZONE"
        case pAddr = "P_ADDR"
        case pName = "P_NAME"
        case pAdmintel = "P_ADMINTEL"
        case gLongitude = "G_LONGITUDE"
        case gLatitude = "G_LATITUDE"
        case longitude = "LONGITUDE"
        case latitude = "LATITUDE"
        case templateURL = "TEMPLATE_URL"
    }
}
