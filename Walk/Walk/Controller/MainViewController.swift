//
//  ViewController.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/18/25.
// https://www.reddit.com/r/iOSProgramming/comments/1fpbj2s/cursor_x_swift/?rdt=48950

import UIKit
import GoogleMaps
import GooglePlaces

class MainViewController: UIViewController, GMSMapViewDelegate{
    
    private var mapView: GMSMapView!
    private var locationManager: CLLocationManager!
    private var placesClient: GMSPlacesClient!
    private let sheetVC = SheetViewController()
    private var userLocation = (latitude: 0.0, longtitude: 0.0)
    let seoulLat =  37.5275
    let seoulLong = 127.028
    
    override func loadView() {
        print(#function)
//        self.view = mapView
        //GMSMapView 인스턴스에서 발생하는 사용자 상호작용의 이벤트를 처리
        let camera = GMSCameraPosition.camera(withLatitude: seoulLat, longitude: seoulLong, zoom: 15.0)
        mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.delegate = self
        placesClient = GMSPlacesClient.shared()
        
        self.view = mapView
    }
    
    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // 위치 권한 요청
        locationManager.startUpdatingLocation() //
        mapView.isMyLocationEnabled = true
    }
    
    func placeSearch(latitude: Double?, longitude: Double?) {
        guard let userLat = latitude, let userLong = longitude else {
            print("정보에러")
            return }
        print(#function)
        let myProperties = [GMSPlaceProperty.name, GMSPlaceProperty.coordinate, GMSPlaceProperty.placeID].map {$0.rawValue}
        let request = GMSPlaceSearchByTextRequest(textQuery:"park in seoul", placeProperties:myProperties)
        request.includedType = "park"
        request.maxResultCount = 20
        request.rankPreference = .distance
        request.isStrictTypeFiltering = true
        request.locationBias =  GMSPlaceCircularLocationOption(CLLocationCoordinate2DMake(userLat, userLong), 3000.0)
        
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
            print("검색결과 : \(placeResults)")
            
            //공원 위치 표시 마커
            for result in placeResults {
                //검색 결과에 따른 핀 생성
                let marker = GMSMarker(position: result.coordinate)
                marker.appearAnimation = .pop
                
                let deleteWhiteSpaceOfParkName = result.name!.filter { $0.isWhitespace == false }
                ParkCongestionDataManager.shared.fetchData(placeName: deleteWhiteSpaceOfParkName) { parkData in
                    guard let parkData = parkData?.first else {
                        DispatchQueue.main.async {
                            marker.icon = GMSMarker.markerImage(with: .gray)
                        }
                        return
                    }

                    DispatchQueue.main.async {
                        switch parkData.placeCongestLV {
                        case "여유":
                            marker.icon = GMSMarker.markerImage(with: Color.congestionRelex)
                        case "보통":
                            marker.icon = GMSMarker.markerImage(with: Color.congestionNormal)
                        case "약간 붐빔":
                            marker.icon = GMSMarker.markerImage(with: Color.congestionMiddle)
                        case "혼잡":
                            marker.icon = GMSMarker.markerImage(with: Color.congestionLot)
                        default:
                            marker.icon = GMSMarker.markerImage(with: .gray)
                        }
                    }
                }
                marker.icon = GMSMarker.markerImage(with: .gray)
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
    private func checkUserLocation() {
        print("이건 머냐 \(locationManager.requestLocation())")
    }
    
    private func sheetSetting() {
        if let sheet = sheetVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            //시트 상단바 표시 옵션
            sheet.prefersGrabberVisible = true
        }
        present(sheetVC, animated: true)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("핀이 눌렸음")
        //핀이 눌렸을 경우 sheet 표시
        let origin = CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longtitude)
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

extension MainViewController:  CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(#function)
    }
    //인증 상태 확인 메서드
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            //위치 정보가 활성화 된경우
        case .authorizedWhenInUse:
            enableLocationFeatures()
            break
            
            //위치 정보가 비활성화를 선택한 경우
        case .restricted, .denied:
            disableLocationFeatures()
            break
            
            //위치 인증이 결정되지 않은 경우
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        print("유저 현재 위치가져오기 성공")
        locations.forEach {
            userLocation.latitude = $0.coordinate.latitude
            userLocation.longtitude = $0.coordinate.longitude
        }
        placeSearch(latitude: userLocation.latitude, longitude: userLocation.longtitude)
    }
    
    func enableLocationFeatures() {
        print("위치 정보 활성화, 앱 실행")
    }
    
    func disableLocationFeatures() {
        print("위치 정보 비활성화, 앱 종료")
    }
}

//@available(iOS 17.0, *)
//#Preview {
//    MainViewController()
//}
