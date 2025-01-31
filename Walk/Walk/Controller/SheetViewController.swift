//
//  ModalViewController.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/22/25.
//

import UIKit
import MapKit

class SheetViewController: UIViewController {
    var congestionLableText: String!
    let sheetView = SheetView()
    let toiletView = ToiletView()
    
    override func loadView() {
        view = sheetView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddTarget()
    }
    
    //버튼 동작 연결
    private func setupAddTarget() {
        sheetView.tolietViewButton.addTarget(self, action: #selector(toiletButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func toiletButtonTapped(){
        let toiletVC = ToiletViewController()
        let navController = UINavigationController(rootViewController: toiletVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
        print("화장실 버튼 눌림")
    }
    
    func getParkData(parkName: String) {
        sheetView.parkNameLable.text = parkName
        let deleteWhiteSpaceOfParkName = parkName.filter { $0.isWhitespace == false }
        ParkCongestionDataManager.shared.fetchData(placeName: deleteWhiteSpaceOfParkName) {
            parkData in
            guard let parkData = parkData else {
                DispatchQueue.main.async {
                    self.sheetView.congestionLable.text = "혼잡도 정보가 없어요😢"
                    self.sheetView.congestionLable.backgroundColor = .white
                }
                print(self.congestionLableText)
                return }
            
            
            parkData.forEach {
                self.congestionLableText = $0.placeCongestLV ?? "에러"
            }
            
            //붐빔,약간 붐빔, 보통, 여유
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                
                print("혼잡도도도ㅗㅗㅗ: \(congestionLableText!) ")
                
                switch congestionLableText {
                case "여유":
                    sheetView.congestionLable.backgroundColor = Color.congestionRelex
                    sheetView.congestionLable.text = self.congestionLableText
                    return
                case "보통":
                    sheetView.congestionLable.backgroundColor = Color.congestionNormal
                    sheetView.congestionLable.text = self.congestionLableText
                    return
                case "약간 붐빔":
                    sheetView.congestionLable.backgroundColor = Color.congestionMiddle
                    sheetView.congestionLable.text = self.congestionLableText
                    return
                case "붐빔":
                    sheetView.congestionLable.backgroundColor = Color.congestionLot
                    sheetView.congestionLable.text = self.congestionLableText
                    return
                default:
                    break
                }
            }
        }
    }
    
    func getParkImage(parkImage: UIImage) {
        
        sheetView.parkImageView.image = parkImage
    }
    
    //거리 계산후 예정시간 표시 해주는 함수
    // 시간 반올림 필요, 60분 넘을시 0시간 0분 으로 나타내게 하는 작업필요
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

//@available(iOS 17.0, *)
//#Preview {
//    SheetViewController()
//}
//
