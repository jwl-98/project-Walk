//
//  ViewController.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/18/25.
// https://www.reddit.com/r/iOSProgramming/comments/1fpbj2s/cursor_x_swift/?rdt=48950

import UIKit
import GoogleMaps
import GooglePlaces

class MainViewController: UIViewController, GMSMapViewDelegate {
    
    private var mapView: GMSMapView!
    private let sheetVC = SheetViewController()
    let seoulLat = 37.526451
    let seoulLong = 127.020485
    
    override func loadView() {
        
        //GMSMapView 인스턴스에서 발생하는 사용자 상호작용의 이벤트를 처리
        let camera = GMSCameraPosition.camera(withLatitude: seoulLat, longitude: seoulLong, zoom: 15.0)
        mapView = GMSMapView(frame: .zero, camera: camera)
        self.view = mapView
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mapView.settings.myLocationButton = true
        let mapCenter = CLLocationCoordinate2DMake(mapView.camera.target.latitude, mapView.camera.target.longitude)
        let marker = GMSMarker(position: mapCenter)
        marker.map = mapView
        placeSearch()
    }
    
    func placeSearch() {

        let myProperties = [GMSPlaceProperty.name, GMSPlaceProperty.coordinate, GMSPlaceProperty.photos, GMSPlaceProperty.iconImageURL].map {$0.rawValue}
        let request = GMSPlaceSearchByTextRequest(textQuery:"park in seoul", placeProperties:myProperties)
        request.includedType = "park"
        request.maxResultCount = 20
        request.rankPreference = .distance
        request.isStrictTypeFiltering = true
        request.locationBias =  GMSPlaceCircularLocationOption(CLLocationCoordinate2DMake(seoulLat, seoulLong), 3000.0)
        
        // Array to hold the places in the response
        var placeResults: [GMSPlace] = []
        
        let callback: GMSPlaceSearchByTextResultCallback = { [weak self] results, error in
            guard let self, error == nil else {
                if let error {
                    print("검색 에러 : \(error.localizedDescription)")
                    print(error)
                }
                return
            }
            guard let results = results as? [GMSPlace] else {
                return
            }
            placeResults = results
            //공원 위치 표시 마커
            for result in placeResults {
                let marker = GMSMarker(position: result.coordinate)
                marker.appearAnimation = .pop
                marker.icon = GMSMarker.markerImage(with: .blue)
                marker.title = result.name!
                marker.map = self.mapView
            }
        }
        
        GMSPlacesClient.shared().searchByText(with: request, callback: callback)
    }
    
    private func sheetSetting() {
        if let sheet = sheetVC.sheetPresentationController {
            sheet.detents = [.medium()]
            //시트 상단바 표시 옵션
            sheet.prefersGrabberVisible = true
        }
        present(sheetVC, animated: true)
    }
    
     func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
         print("핀이 눌렸음")
         sheetSetting()
        if let title = marker.title {
                print("marker title: \(title)")
        }
         return true
    }
    
}

//@available(iOS 17.0, *)
//#Preview {
//    MainViewController()
//}
