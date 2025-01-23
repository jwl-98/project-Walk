//
//  ModalViewController.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/22/25.
//

import UIKit

class SheetViewController: UIViewController {
    let sheetView = SheetView()
    let parkCongestionDataManger = ParkCongestionDataManager()
    
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
        print("화장실 버튼 눌림")
    }
    
    func getParkData(parkName: String) {
        sheetView.parkNameLable.text = parkName
        parkCongestionDataManger.fetchData(placeName: parkName) {
            parkData in
            guard let parkData = parkData else {
                DispatchQueue.main.async {
                    print(parkName)
                    self.sheetView.congestionLable.text = "혼잡도 정보 없음"
                }
                return }
            
            DispatchQueue.main.async {
                parkData.forEach {
                    self.sheetView.congestionLable.text = $0.palceCongestLV
                }
            }
        }
        
       
        
    }
    
    func getParkImage(parkImage: UIImage) {
        
        sheetView.parkImageView.image = parkImage
    }
    
}

//@available(iOS 17.0, *)
//#Preview {
//    SheetViewController()
//}
//
