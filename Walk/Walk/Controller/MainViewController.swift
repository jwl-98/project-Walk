//
//  ViewController.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/18/25.
// https://www.reddit.com/r/iOSProgramming/comments/1fpbj2s/cursor_x_swift/?rdt=48950

import UIKit
import GoogleMaps
import GooglePlaces

//데이터 전달을 받기위한 델리게이트 선언
//?? - AnyObject는 무엇을 의미하는거지?

class MainViewController: UIViewController{
    
    private var mapView: GMSMapView!
    private var locationManager: CLLocationManager!
    private var placesClient: GMSPlacesClient!
    private let sheetVC = SheetViewController()
    private var userLocation = CLLocationCoordinate2D(latitude:  0.0, longitude: 0.0)
    private var parkData: ParkLocation?
    private let seoulBounds = GMSCoordinateBounds(
        coordinate: CLLocationCoordinate2D(latitude: 37.7019, longitude: 126.7341), // 북서쪽
        coordinate: CLLocationCoordinate2D(latitude: 37.4283, longitude: 127.1836)  // 남동쪽
    )
    
    //    override func loadView() {
    //        print(#function)
    //        //GMSMapView 인스턴스에서 발생하는 사용자 상호작용의 이벤트를 처리
    //        let camera = GMSCameraPosition.camera(withLatitude: userLocation.latitude, longitude: userLocation.longitude, zoom: 15.0)
    //
    //        mapView = GMSMapView(frame: .zero, camera: camera)
    //        mapView.settings.myLocationButton = true
    //        mapView.settings.scrollGestures = true
    //        mapView.settings.zoomGestures = true
    //        mapView.delegate = self
    //        placesClient = GMSPlacesClient.shared()
    //
    //        //검색 진행후 view 초기화
    //        self.view = mapView
    //    }
    
    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // 위치 권한 요청
        locationManager.startUpdatingLocation()
    }
    
    private func settingMapView() {
        print(#function)
        let camera = GMSCameraPosition.camera(withLatitude: userLocation.latitude, longitude: userLocation.longitude, zoom: 15.0)
        
        mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.delegate = self
        placesClient = GMSPlacesClient.shared()
        
        //검색 진행후 view 초기화
        self.view = mapView
        mapView.isMyLocationEnabled = true
    }
    
    func parkSearch(userLocation: CLLocationCoordinate2D) {
        print(#function)
        let myProperties = [GMSPlaceProperty.name, GMSPlaceProperty.coordinate, GMSPlaceProperty.placeID].map {$0.rawValue}
        let request = GMSPlaceSearchByTextRequest(textQuery:"park in seoul", placeProperties:myProperties)
        request.includedType = "park"
        request.maxResultCount = 50
        request.rankPreference = .distance
        request.isStrictTypeFiltering = true
        request.locationBias =  GMSPlaceCircularLocationOption(CLLocationCoordinate2DMake(userLocation.latitude, userLocation.longitude), 1500.0)
        
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
                SeoulDataManager.shared.fetchParkCongestionData(placeName: deleteWhiteSpaceOfParkName) { parkData in
                    guard let parkData = parkData?.first else {
                        DispatchQueue.main.async {
                            //marker.icon = UIImage(named: "Marker_Default")
                            //marker.icon = GMSMarker.markerImage(with: Color.congestionNone)
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        switch parkData.placeCongestLV {
                        case "여유":
                            marker.icon = MarkerImage.markerGreen/*GMSMarker.markerImage(with: Color.congestionRelex)*/
                        case "보통":
                            marker.icon = MarkerImage.markerYellow/*GMSMarker.markerImage(with: Color.congestionNormal)*/
                        case "약간 붐빔":
                            marker.icon = MarkerImage.markerOrange/*GMSMarker.markerImage(with: Color.congestionMiddle)*/
                        case "붐빔":
                            marker.icon = MarkerImage.markerRed/* GMSMarker.markerImage(with: Color.congestionLot)*/
                        default:
                            marker.icon = MarkerImage.markerDefault/*GMSMarker.markerImage(with:  Color.congestionNone)*/
                        }
                    }
                }
                //marker.icon = GMSMarker.markerImage(with: Color.congestionNone)
                marker.icon = MarkerImage.markerDefault
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
            sheet.detents = [.medium(), .large()]
            //시트 상단바 표시 옵션
            sheet.prefersGrabberVisible = true
        }
        present(sheetVC, animated: true)
    }
    
}
extension MainViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        print("핀이 눌렸음")
        
        //핀이 눌렸을 경우 sheet 표시
        let origin = CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let destination = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
        
        print("공원 위 경도: \(destination)")
        //확인필요 - 프로토콜을 통한 데이터 전달 간
        if let title = marker.title {
            sheetVC.getParkData(parkName: title, location: marker.position)
            //기본 이미지 셋팅 (로딩 이미지)
            sheetVC.getParkImage(parkImage: UIImage(systemName: "tree.fill")!)
            sheetVC.updateParkFacilities(parkName: title)
            print("marker title: \(title)")
        }
        //데이터 제공
        sheetVC.parkDataSource = self
        
        let parkLocation = ParkLocation(parkName: marker.title ?? "", parkLocation: marker.position)
        parkData = parkLocation
        
        //확인필요
        sheetVC.calculateRoute(origin: origin, destination: destination)
        sheetSetting()
        
        //확인필요
        if let placeID = marker.userData as? String {
            fetchPlaceImage(placeID: placeID) { [weak self] parkImage in
                guard let self = self else {return}
                self.sheetVC.getParkImage(parkImage: parkImage)
            }
        }
        return true
    }
    
    //사용자가 서울시에서 벗어난 경우 - if the User out Of Seoul
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        if !seoulBounds.contains(position.target) {
//            let update = GMSCameraUpdate.setTarget(userLocation, zoom: 15.0)
//            mapView.animate(with: update)
//            print("서울에서 벗어남")
//        }
//        print("서울 내부임")
    }
    
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(#function)
    }
    //인증 상태 확인 메서드
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            //위치 정보가 활성화 된경우
        case .authorizedWhenInUse:
            settingMapView()
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
    //TODO: 유저 위치가 서울시가 아닌 경우 얼럿창 띄우기.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        print("유저 현재 위치가져오기 성공")
        locations.forEach {
            userLocation.latitude = $0.coordinate.latitude
            userLocation.longitude = $0.coordinate.longitude
        }
        
        if !seoulBounds.contains(userLocation) {
            print("사용자의 위치는 서울이 아님")
            userNotInSeoul()
        } else {
            settingMapView()
            parkSearch(userLocation: userLocation)
        }
        
    }
    
    private func enableLocationFeatures() {
        print("위치 정보 활성화, 앱 실행")
    }
    
    //TODO: 위치서비스가 비활성화 된 경우 위치 서비스 설정 화면으로 이동 시키기
    private func disableLocationFeatures() {
        print("위치 정보 비활성화, 앱 종료")
        
        let alert =  UIAlertController(title: "위치 서비스가 비활성화 상태에요!", message: "위치서비스를 허용 시켜주세요!", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //유저 위치가 서울이 아닌 경우
    private func userNotInSeoul() {
        let alert =  UIAlertController(title: "서울이 아니시군요!", message: "현재는 서울만 서비스가 가능해요.😢", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//데이터 전달을 위한 프로토콜 채택
extension MainViewController: ParkLocationDataSource {
    
    func parkDataSource() -> ParkLocation {
        print(#function)
        dump(parkData)
        return parkData!
    }
    
    
}

//@available(iOS 17.0, *)
//#Preview {
//    MainViewController()
//}
