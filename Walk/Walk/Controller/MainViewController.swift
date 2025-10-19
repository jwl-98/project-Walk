//
//  ViewController.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/18/25.
// https://www.reddit.com/r/iOSProgramming/comments/1fpbj2s/cursor_x_swift/?rdt=48950

import UIKit
import GoogleMaps
import GooglePlaces


class MainViewController: UIViewController{
    
    private var mapView: GMSMapView!
    private let locationManager =  CLLocationManager()
    private var placesClient: GMSPlacesClient!
    private let sheetVC = SheetViewController()
    private var userLocation = CLLocationCoordinate2D(latitude:  0.0, longitude: 0.0)
    private var parkData: ParkLocation?
    
    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // 위치 권한 요청
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
    }
    
    private func settingMapView() {
        print(#function)
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition.camera(
            withLatitude: userLocation.latitude,
            longitude: userLocation.longitude,
            zoom: 15.0)
        
        guard  mapView != nil else {
            print("mapView 초기화 전")
            return
        }
        mapView = GMSMapView(options:options)
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
        print("__DDDDD")
        print(userLocation)
        
        let circularLocationRestriction = GMSPlaceCircularLocationOption(CLLocationCoordinate2DMake(userLocation.latitude, userLocation.longitude), 3000.0)
        let placeProperties = [GMSPlaceProperty.name, GMSPlaceProperty.coordinate, GMSPlaceProperty.placeID].map {$0.rawValue}
        
        let request = GMSPlaceSearchNearbyRequest(locationRestriction: circularLocationRestriction, placeProperties: placeProperties)
        let includedTypes = ["park"]
        request.includedTypes = includedTypes
        
        // Array to hold the places in the response
        var placeResults: [GMSPlace] = []
        
        let callback: GMSPlaceSearchNearbyResultCallback = { [weak self] results, error in
            guard let self, error == nil else {
                if let error {
                    print("검색 에러 : \(error.localizedDescription)")
                    print(error)
                }
                return
            }
            guard let results = results else {
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
                    guard let parkData = parkData?.first else { return }
                    
                    DispatchQueue.main.async {
                        switch parkData.placeCongestLV {
                        case "여유":
                            marker.iconView = MarkerImage.markerGreen
                        case "보통":
                            marker.iconView = MarkerImage.markerYellow
                        case "약간 붐빔":
                            marker.iconView = MarkerImage.markerOrange
                        case "붐빔":
                            marker.iconView = MarkerImage.markerRed
                        default:
                            marker.iconView = MarkerImage.markerDefault
                        }
                    }
                }
                marker.iconView = MarkerImage.markerDefault
                marker.title = result.name!
                marker.map = self.mapView
                marker.userData = result.placeID
            }
        }
        GMSPlacesClient.shared().searchNearby(with: request, callback: callback)
    }
    
    func fetchPlaceImage(placeID: String, completion: @escaping (UIImage) -> ()) {
        print(#function)
        let myProperties = [GMSPlaceProperty.name, GMSPlaceProperty.website].map {$0.rawValue}
        print("myProperties : \(myProperties)")
        let fetchPlaceRequest = GMSFetchPlaceRequest(placeID: placeID, placeProperties: myProperties, sessionToken: nil)
        print("fetchPlaceRequest \(fetchPlaceRequest)")
        
        placesClient.lookUpPhotos(forPlaceID: placeID) { (photos, error) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            var photoMetadataArray: GMSPlacePhotoMetadata!
            //사진 데이터가 없는 경우
            if photos?.results.isEmpty == true {
                completion(UIImage(named: "공원 기본 이미지.png")!)
                return }
            photoMetadataArray = photos?.results[0]
            
            self.placesClient.loadPlacePhoto(photoMetadataArray, callback: { (photo, error) -> Void in
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
    }
    private func sheetSetting() {
        if let sheet = sheetVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(sheetVC, animated: true)
    }
    
}
extension MainViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        guard let title = marker.title else { return false }
        
        fetchParkDetailData(parkName: title, placeID: marker.userData as? String, location: marker.position) { [weak self] parkData in
            guard let self = self else { return }
            
            
        }
        
        
        print("핀이 눌렸음")
        
        //핀이 눌렸을 경우 sheet 표시
        let origin = CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let destination = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
        
        print("공원 위 경도: \(destination)")
        //확인필요 - 프로토콜을 통한 데이터 전달 간
        if let title = marker.title {
            sheetVC.getParkData(parkName: title, location: marker.position)
            //기본 이미지 셋팅 (로딩 이미지)
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
    private func fetchParkDetailData(
        parkName: String,
        placeID: String?,
        location: CLLocationCoordinate2D,
        completion: @escaping (ParkDetailData) -> Void
    ) {
        let group = DispatchGroup()
        var parkImage: UIImage?
        var congestionData: ParkCongestionDataModel?
        var events: [Row]?
        var facilities: [(String, String)]?
        
    }
    
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(#function)
        print(error.localizedDescription)
    }
    //인증 상태 확인 메서드
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            //위치 정보가 활성화 된경우
        case .authorizedWhenInUse:
            enableLocationFeatures(currentUserLoacation: manager.location)
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
    
    //유저 위치가 100미터 단위로 이동시 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        print("유저 위치가 이동됨 : \(locations[0])")
        userLocation.latitude = locations[0].coordinate.latitude
        userLocation.longitude =  locations[0].coordinate.longitude
        mapView.clear()
        parkSearch(userLocation: locations[0].coordinate)
        
    }
    private func enableLocationFeatures(currentUserLoacation: CLLocation?) {
        print("위치 정보 활성화, 맵 셋팅")
        guard let currentUserLoacation = currentUserLoacation else { return }
        userLocation.latitude = currentUserLoacation.coordinate.latitude
        userLocation.longitude = currentUserLoacation.coordinate.longitude
        parkSearch(userLocation: currentUserLoacation.coordinate)
        settingMapView()
        
    }
    
    //TODO: 위치서비스가 비활성화 된 경우 위치 서비스 설정 화면으로 이동 시키기
    private func disableLocationFeatures() {
        print("위치 정보 비활성화, 앱 종료")
        
        let alert =  UIAlertController(title: "위치 서비스가 비활성화 상태에요!", message: "위치서비스를 허용 시켜주세요!", preferredStyle: .alert)
        let alertOKAction = UIAlertAction(title: "확인", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let alertCancelAction = UIAlertAction(title: "취소", style: .destructive)
        
        alert.addAction(alertOKAction)
        alert.addAction(alertCancelAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //유저 위치가 서울이 아닌 경우
    private func userNotInSeoul() {
        let alert =  UIAlertController(title: "서울이 아니시군요!", message: "현재는 서울만 서비스가 가능해요.😢", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
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
