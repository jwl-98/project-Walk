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
    private var mapView: GMSMapView!
    let seoulLat =  37.5275
    let seoulLong = 127.028
    let parkLocation: ParkLocation?
    
    init(parkLocation: ParkLocation) {
        self.parkLocation = parkLocation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        configureUI()
        setupNavBar()
    }
    
    private func setupMapView() {
        
        guard let parkLocation = parkLocation else {return}
        let camera = GMSCameraPosition.camera(withLatitude: parkLocation.parkLocation.latitude, longitude: parkLocation.parkLocation.longitude , zoom: 17.0)
        mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.delegate = self
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
