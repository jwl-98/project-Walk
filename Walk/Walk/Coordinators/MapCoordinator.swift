//
//  MapCoordinator.swift - 지도 업데이트 담당
//  Walk
//
//  Created by 진욱의 Macintosh on 10/19/25.
//

import Foundation
import GoogleMaps
import CoreLocation

final class MapCoordinator {
    
    private var userLocation: CLLocation? //
    
    //의미있는 이동 - GPS 오차범위 50m up, 기준은 15초 - 인간은 15초 걸으면 보통 15~25미터 정도 간다.
    private var minDistance: CLLocationDistance = 50
    private var minTime: TimeInterval = 15
    
    
    func shouldMapMove(newLocation: CLLocation) -> Bool {
        //정확도 기준
        guard newLocation.horizontalAccuracy > 0,
              newLocation.horizontalAccuracy <= 50 else { return false }
        if let prevUserLocation = userLocation {
            let newDistance = prevUserLocation.distance(from: newLocation)
            let newDistanceTime = prevUserLocation.timestamp.timeIntervalSince(prevUserLocation.timestamp)
            guard newDistance >= minDistance && newDistanceTime >= minTime else { return false }
        }
        userLocation = newLocation
        return true
    }
    
}
