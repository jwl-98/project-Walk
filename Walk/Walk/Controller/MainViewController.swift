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
    private let placesClient = GMSPlacesClient.shared()
    let seoulLat =  37.5275
    let seoulLong = 127.028
    
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
        
        let myProperties = [GMSPlaceProperty.name, GMSPlaceProperty.coordinate, GMSPlaceProperty.placeID].map {$0.rawValue}
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
            //검색이 끝난 시점
            placeResults = results
            
            //공원 위치 표시 마커
            for result in placeResults {
                //검색 결과에 따른 핀 생성
                let marker = GMSMarker(position: result.coordinate)
                marker.appearAnimation = .pop
                marker.icon = GMSMarker.markerImage(with: .blue)
                marker.title = result.name!
                marker.map = self.mapView
                marker.userData = result.placeID
            }
        }
        
        GMSPlacesClient.shared().searchByText(with: request, callback: callback)
    }
    
    func fetchPlaceImage(placeID: String, completion: @escaping (UIImage) -> ()) {
        
        // Specify the place data types to return (in this case, just photos).
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt64(UInt(GMSPlaceField.photos.rawValue)))
        
        placesClient.fetchPlace(fromPlaceID: placeID,
                                placeFields: fields,
                                sessionToken: nil, callback: {
            (place: GMSPlace?, error: Error?) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            if let place = place {
                // Get the metadata for the first photo in the place photo metadata list.
                let photoMetadata: GMSPlacePhotoMetadata = place.photos![0]
                
                // Call loadPlacePhoto to display the bitmap and attribution.
                self.placesClient.loadPlacePhoto(photoMetadata, callback: { (photo, error) -> Void in
                    if let error = error {
                        // TODO: Handle the error.
                        print("Error loading photo metadata: \(error.localizedDescription)")
                        return
                    } else {
                        // Display the first image and its attributions.
                        guard let image = photo else {return}
                        completion(image)
                    }
                })
            }
        })
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
        //핀이 눌렸을 경우 sheet 표시
        let origin = CLLocationCoordinate2D(latitude: seoulLat, longitude: seoulLong)
        let destination = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
        
        if let title = marker.title {
            sheetVC.getParkData(parkName: title)
            //기본 이미지 셋팅 (로딩 이미지)
            sheetVC.getParkImage(parkImage: UIImage(systemName: "tree.fill")!)
            print("marker title: \(title)")
        }
        sheetVC.calculateRoute(origin: origin, destination: destination)
        
        sheetSetting()
        
        if let placeID = marker.userData as? String {
            fetchPlaceImage(placeID: placeID) { [weak self] parkImage in
                guard let self = self else {return}
                self.sheetVC.getParkImage(parkImage: parkImage)
            }
        }
        
        
        return true
    }
    
}

//@available(iOS 17.0, *)
//#Preview {
//    MainViewController()
//}
