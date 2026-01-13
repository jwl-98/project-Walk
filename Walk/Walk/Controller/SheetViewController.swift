//
//  ModalViewController.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/22/25.
//

import UIKit
import MapKit

protocol ParkLocationDataSource: AnyObject {
    func parkDataSource() -> ParkLocation
}

class SheetViewController: UIViewController {
    
    var congestionLabelText: String!
    var congestionMSG: String!
    weak var parkDataSource: ParkLocationDataSource?
    let sheetView = SheetView()
    let toiletView = ToiletView()
    let popVC = PopoverViewController()
    
    override func loadView() {
        view = sheetView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddTarget()
        setupCollectionView()
        setupTableView()
    }
    
    //events 속성이 변경되면 sheetView 메서드 호출
    private var events: [Row] = [] {
        didSet { //속성 감시자
            DispatchQueue.main.async {
                self.sheetView.updateEventList(isEmpty: self.events.isEmpty)
            }
        }
    }
    
    private var facilityItems: [(title: String, content: String)] = [] {
        didSet{
            DispatchQueue.main.async {
                self.sheetView.updateFacilitiesItem(isEmpty: self.facilityItems.isEmpty)
            }
        }
    }
    
    private func setupCollectionView() {
        sheetView.setupEventCollectionView(delegate: self, dataSource: self)
    }
    //버튼 동작 연결
    private func setupAddTarget() {
        let action = UIAction(handler: congestionInfoButtonTapped)
        sheetView.toiletViewButton.addTarget(self, action: #selector(toiletButtonTapped), for: .touchUpInside)
        sheetView.congestionInfoButton.addAction(action, for: .touchUpInside)
    }
    
    @objc
    func toiletButtonTapped(){
        print(#function)
        guard let parkLocation = parkDataSource?.parkDataSource() else {
            print("전달된 데이터 없음.")
            return }
        //toiletVC 생성과 동시에 Park데이터 전달
        let toiletVC = ToiletViewController(parkLocation: parkLocation)
        let navController = UINavigationController(rootViewController: toiletVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
        print("화장실 버튼 눌림")
    }
    
    func congestionInfoButtonTapped(action: UIAction) {
        print("정보 버튼 눌림")
        popVC.modalPresentationStyle = .popover
        
        // popover 설정
        if let popover = popVC.popoverPresentationController {
            popover.sourceView = sheetView.congestionInfoButton // 실제 화면의 버튼
            popover.sourceRect = sheetView.congestionInfoButton.bounds
            popover.permittedArrowDirections = [.down]
            popover.delegate = popVC
        }
        present(popVC, animated: true)
    }
    
    func getParkData(parkName: String, location: CLLocationCoordinate2D) {
        sheetView.parkNameLable.text = parkName
        let deleteWhiteSpaceOfParkName = parkName.filter { $0.isWhitespace == false }
        
        print("위치 정보: \(location.latitude), \(location.longitude)")
        // 해당 공원 근처의 이벤트 데이터 가져오기
        SeoulDataManager.shared.fetchEventData(parkLocation: location, parkName: deleteWhiteSpaceOfParkName) { [weak self] events in
            guard let self = self else { return }
            if let events = events {
                self.events = events
                print("이벤트 데이터 개수: \(events.count)")
                
                events.forEach { event in
                    print("이벤트 제목: \(event.title)")
                    print("이벤트 장소: \(event.place)")
                    print("이벤트 날짜: \(event.strtdate) ~ \(event.endDate)")
                    print("------------------------")
                }
            }
        }
        
        SeoulDataManager.shared.fetchParkCongestionData(placeName: deleteWhiteSpaceOfParkName) {
            parkData in
            guard let parkData = parkData else {
                DispatchQueue.main.async {
                    let level = CongestionLevel.unknown
                    self.sheetView.congestionInfoButton.isHidden = true
                    self.sheetView.congestionLabel.text = level.displayText
                    self.sheetView.congestionLabel.backgroundColor = level.backgroundColor
                    self.popVC.congestionMSGLabel.text = "정보 없음"
                }
                return
            }
            
            print(self.congestionMSG)
            //붐빔,약간 붐빔, 보통, 여유
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                
                let congestionLevel = CongestionLevel(from: self.congestionLabelText)
                //메세지 정보버튼 활성화
                sheetView.congestionInfoButton.isHidden = true
                //레이블 UI변경
                sheetView.congestionLabel.backgroundColor = congestionLevel.backgroundColor
                //레이블 텍스트 변경
                sheetView.congestionLabel.text = congestionLevel.displayText
                
                print(#function)
                print("혼잡도 레벨 확인: \(congestionLevel)")
            }
        }
    }
    //공원 이미지 가져오기
    func getParkImage(parkImage: UIImage) {
        DispatchQueue.main.async {
            self.sheetView.parkImageView.image = parkImage
        }
    }
    
    func updateParkData(parkData: ParkDetailData) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            //공원 이미지 업데이트
            self.sheetView.parkImageView.image = parkData.image
            
            //혼잡도 업데이트
            if let congestion = parkData.congestion {
                self.updateCongestionInfo(with: congestion)
            }
            
            if let events = parkData.events {
                self.events = events
            }
            
            if let facilities = parkData.facilities {
                self.facilityItems = facilities
            }
        }
    }
    
    //혼잡도 정보 업데이트
    private func updateCongestionInfo(with data: ParkCongestionDataModel) {
        
        let congestionLevel = CongestionLevel(from: data.placeCongestLV)
        
        sheetView.congestionInfoButton.isHidden = false
        sheetView.congestionLabel.backgroundColor = congestionLevel.backgroundColor
        sheetView.congestionLabel.text = congestionLevel.displayText
        popVC.congestionMSGLabel.text = data.placeCongestMSG
    }
    
    //거리 계산후 예정시간 표시 해주는 함수
    // 시간 반올림 필요, 60분 넘을시 0시간 0분 으로 나타내게 하는 작업필요 - 완
    func calculateRoute(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: origin))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .walking
        
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let route = response?.routes.first {
                let expectationTime = Int(round((route.expectedTravelTime) / 60))
                
                switch expectationTime {
                case 0...59:
                    self.sheetView.leftTimeLabel.text = "내 위치에서 \(expectationTime)분 소요될 예정이에요!"
                case 60:
                    self.sheetView.leftTimeLabel.text = "내 위치에서 \(expectationTime / 60)시간 소요될 예정이에요!"
                default:
                    self.sheetView.leftTimeLabel.text = "내 위치에서 \(expectationTime / 60)시간 \(expectationTime % 60)분 소요될 예정이에요!"
                }
                print("예상 시간: \(expectationTime) 분") // 예상 시간 (분)
            }
        }
        
    }
}

extension SheetViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.reuseIdentifier, for: indexPath) as? EventCell else {
            return UICollectionViewCell()
        }
        
        let event = events[indexPath.row]
        cell.configure(with: event)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 12 // 셀 사이 간격
        let numberOfItemsPerRow: CGFloat = 2 // 한 행에 보여질 셀 개수
        let width = (collectionView.bounds.width - spacing * (numberOfItemsPerRow - 1)) / numberOfItemsPerRow
        //        let width = collectionView.bounds.width
        //        print(width)
        
        return CGSize(width: width, height: 380)
    }
}


extension SheetViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    private func setupTableView() {
        sheetView.facilitiesTableView.delegate = self
        sheetView.facilitiesTableView.dataSource = self
    }
    
    func updateParkFacilities(parkName: String) {
        print(#function)
        //let deleteWhiteSpaceOfParkName = parkName.filter { $0.isWhitespace == false }
        SeoulDataManager.shared.fetchParkInfo(parkName: parkName) { [weak self] parkInfo in
            guard let self = self else {return}
            self.facilityItems = []
            
            guard let parkInfo = parkInfo else {
                //속성 감시자 실행을 위한 셋팅
                self.facilityItems = []
                return
            }
            
            // 주요 시설 정보
            if !parkInfo.mainEquip.isEmpty {
                self.facilityItems.append(("주요 시설", parkInfo.mainEquip))
            }
            DispatchQueue.main.async {
                self.sheetView.facilitiesTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        print(facilityItems.count)
        return facilityItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FacilityCell.reuseIdentifier, for: indexPath) as? FacilityCell else {
            return UITableViewCell()
        }
        print(#function)
        let item = facilityItems[indexPath.row]
        cell.configure(title: item.title, content: item.content)
        cell.selectionStyle = .none
        return cell
    }
}
//@available(iOS 17.0, *)
//#Preview {
//    SheetViewController()
//}

