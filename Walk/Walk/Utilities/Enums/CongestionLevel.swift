//
//  CongestionLevel.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 11/16/25.
//

import Foundation
import UIKit


enum CongestionLevel: String {
    case relaxed = "여유"
    case normal = "보통"
    case middle = "약간 붐빔"
    case lot = "붐빔"
    case unknown = ""
    
    //커스텀 생성자
    init(from string: String?) {
        guard let string = string,
              let level = CongestionLevel(rawValue: string) else {
            self = .unknown
            return
        }
        self = level
    }
    
    var displayText: String {
        switch self {
        case . unknown:
            return "혼잡도 정보가 없어요😢"
        default:
            return self.rawValue
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .relaxed:
            return Color.congestionRelex
        case .normal:
            return Color.congestionNormal
        case .middle:
            return Color.congestionMiddle
        case .lot:
            return Color.congestionLot
        case .unknown:
            return .white
        }
    }
    
    var markerIcon: UIView {
        
        switch self {
        case .relaxed:
               return MarkerImage.markerGreen
           case .normal:
               return MarkerImage.markerYellow
           case .middle:
               return MarkerImage.markerOrange
           case .lot:
               return MarkerImage.markerRed
           case .unknown:
               return MarkerImage.markerDefault
           }
       }

}
