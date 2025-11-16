//
//  ParkDetailData.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 3/31/25.
//

import Foundation
import UIKit

struct ParkDetailData {
    let image: UIImage
    let congestion: ParkCongestionDataModel?
    let events: [Row]?
    let facilities: [(title: String, content: String)]?
}
