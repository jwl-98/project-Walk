//
//  ParkLocation.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/31/25.
//

import Foundation
import MapKit

//공원의 위도, 경도 저장을 위한 구조체
struct ParkLocation {
    let parkName: String
    let parkLocation: CLLocationCoordinate2D
}
