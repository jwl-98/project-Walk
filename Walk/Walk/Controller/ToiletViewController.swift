//
//  ToiletViewController.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/26/25.
//

import UIKit
import SnapKit
import GoogleMaps
import GooglePlaces

class ToiletViewController: UIViewController, GMSMapViewDelegate {
    
    let toiletView = ToiletView()
    private var placesClient: GMSPlacesClient!
    private var mapView: GMSMapView!
    let seoulLat =  37.5275
    let seoulLong = 127.028
    let parkLocation: ParkLocation?
    var toiletArry: [SeoulToiletDataModel]?
    
    init(parkLocation: ParkLocation) {
        self.parkLocation = parkLocation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        setupMapView()
        configureUI()
        setupNavBar()
        setupToiletMarkers()
    }
    
    private func setupMapView() {
        
        guard let parkLocation = parkLocation else {return}
        let camera = GMSCameraPosition.camera(withLatitude: parkLocation.parkLocation.latitude, longitude: parkLocation.parkLocation.longitude , zoom: 17.0)
        mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.delegate = self
        placesClient = GMSPlacesClient.shared()
      
        let parkMarker = GMSMarker(position: parkLocation.parkLocation)
               parkMarker.title = parkLocation.parkName
               parkMarker.icon = GMSMarker.markerImage(with: .green)  // 공원 마커는 녹색으로
               parkMarker.map = mapView
    }
        
    //네비게이션 바 설정
    private func setupNavBar() {
        guard let parkLocation = parkLocation else { return }
        print(#function)
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationItem.title = "\(parkLocation.parkName)"
        print("TVC 확인 \(parkLocation.parkName)")
        navigationController?.navigationBar.tintColor = .black  // 버튼 색상
        navigationController?.navigationBar.backgroundColor = .white  // 배경색
        
        // 왼쪽 상단에 back 버튼 추가
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(dismissVC)
        )
    }
    
    private func setupToiletMarkers() {
        guard let parkLocation = parkLocation,
              let toiletArray = SeoulDataManager().parseToiletLocalJSON() else {return}
        
        let parkCoordinate = parkLocation.parkLocation
        
        let nearByToilet = toiletArray.filter { toilet in
            let toiletCoordinate = CLLocation(latitude: toilet.toiletLat, longitude: toilet.toiletLong)
            let parkLocationObj = CLLocation(latitude: parkCoordinate.latitude, longitude: parkCoordinate.longitude)
            
            let distance = toiletCoordinate.distance(from: parkLocationObj)
            return distance <= 2000
        }
        for toilet in nearByToilet {
               let marker = GMSMarker()
               marker.position = CLLocationCoordinate2D(latitude: toilet.toiletLat, longitude: toilet.toiletLong)
               marker.title = toilet.toiletName
               marker.snippet = "공중화장실"
               marker.icon = GMSMarker.markerImage(with: .blue) // 화장실 마커는 파란색으로 표시
               marker.map = mapView
           }
    }
    
    @objc
    func dismissVC() {
        dismiss(animated: true)
        print("뒤로가기 버튼 눌림")
    }

    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

}
