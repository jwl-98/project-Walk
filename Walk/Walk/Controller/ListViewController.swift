//
//  ListViewController.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 2/21/25.
//

import UIKit
import SnapKit
import Kingfisher

class ListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let queue = DispatchQueue(label: "com.yourapp.congestionData")
    
    let parkList: [String] = [
        "강서한강공원",
        "고척돔",
        "광나루한강공원",
        "광화문광장",
        "국립중앙박물관·용산가족공원",
        "난지한강공원",
        "남산공원",
        "노들섬",
        "뚝섬한강공원",
        "망원한강공원",
        "반포한강공원",
        "북서울꿈의숲",
        "불광천",
        "서리풀공원·몽마르뜨공원",
        "서울광장",
        "서울대공원",
        "서울숲공원",
        "아차산",
        "양화한강공원",
        "어린이대공원",
        "여의도한강공원",
        "월드컵공원",
        "응봉산",
        "이촌한강공원",
        "잠실종합운동장",
        "잠실한강공원",
        "잠원한강공원",
        "청계산",
        "청와대"
    ]
    
    private var congestionDataArray: [ParkCongestionDataModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        view.backgroundColor = Color.lightGreen
//        for placeName in parkList {
//            setupData(placeName: placeName)
//        }
        setupData()
        setupTableView()
        configureUI()
    }
    
    func setupTableView() {
        print(#function)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 250
        tableView.register(CongestionListCell.self, forCellReuseIdentifier: "ListCell")
        tableView.backgroundColor = Color.lightGreen
    }
//    
//    func setupData(placeName: String) {
//        SeoulDataManager.shared.fetchParkCongestionData(placeName: placeName) { [weak self] data in
//            guard let data = data, let self = self else { return }
//            self.queue.async {
//                self.congestionDataArray.append(contentsOf: data)
//            }
//        }
//    }
    
    func setupData() {
        let group = DispatchGroup()
        let lock = NSLock()
        var tempArray: [ParkCongestionDataModel] = []
        
        for placeName in parkList {
            group.enter()
            SeoulDataManager.shared.fetchParkCongestionData(placeName: placeName) { data in
                if let data = data {
                    lock.lock()
                    tempArray.append(contentsOf: data)
                    lock.unlock()
                }
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            self?.congestionDataArray = tempArray
        }
    }
    
    func configureUI(){
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
}

extension ListViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        return congestionDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! CongestionListCell
        let cellCongestionView = cell.parkCongestionView
        cell.parkNameLabel.text = congestionDataArray[indexPath.row].placeName
        cell.parkCongestionLabel.text = congestionDataArray[indexPath.row].placeCongestLV
        cell.selectionStyle = .none
        
        guard let parkName = cell.parkNameLabel.text else { return cell }
        let url = URL(string: "https://data.seoul.go.kr/resources/img/guide/hotspot/\(parkName).jpg")
      
        
        DispatchQueue.main.async {
            cell.parkImageView.kf.setImage(with: url)
            cell.parkImageView.kf.indicatorType = .activity
            
            switch cell.parkCongestionLabel.text {
            case "여유":
                return
            case "보통":
                cellCongestionView.backgroundColor = Color.congestionNormal
            case "약간 붐빔":
                cellCongestionView.backgroundColor = Color.congestionMiddle
            case "붐빔":
                cellCongestionView.backgroundColor = Color.congestionLot
            default:
                return
            }
        }
  
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    
}
