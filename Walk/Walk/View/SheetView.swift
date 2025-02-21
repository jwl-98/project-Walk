//
//  SheetView.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/22/25.
import UIKit
import SnapKit

class SheetView: UIView {
    
    
    private let sheetGrabber: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DesignComponents.sheetGrabber
        
        return imageView
        
    }()
    //MARK: 공원대표 사진, 이름 등 메인 탭
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = CornerRadius.normal
        view.addSubview(parkImageView)
        view.addSubview(congestionLable)
        view.addSubview(parkNameLable)
        
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.addSubview(mainView)
        view.addSubview(stackViewForToilet)
        view.addSubview(sectionLabel)
        view.addSubview(subView)
        
        return view
    }()
    //공원 도착 예정시간 레이블
    let leftTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "내 위치에서 N분 소요될 예정이에요!"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    //공원 이미지
    let parkImageView: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "공원 기본 이미지.png")
        image.clipsToBounds = true
        image.layer.cornerRadius = CornerRadius.normal
        
        return image
    }()
    
    //혼잡도 레이블
    let congestionLable: UILabel = {
        var label = UILabel()
        label.text = "혼잡도 정보가 없어요😢"
        label.layer.cornerRadius  = CornerRadius.normal
        label.clipsToBounds = true
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    let congestionInfoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "혼잡도 정보 버튼.png"), for: .normal)
        button.isHidden = true
        
        return button
    }()
    
    //공원이름 레이블
    var parkNameLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "공원이름"
        label.numberOfLines = 0
        
        return label
    }()
    
    //MARK: - 화장실 탭
     lazy var tolietViewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        
        return button
    }()
    
    private let tolietSFIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 28/2
        imageView.image = UIImage(named: "화장실icon")
       
        return imageView
    }()
    
    private let rightSFIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "chevron.right")
        
        return imageView
    }()
    
    private let tolietViewLabel: UILabel = {
        let label = UILabel()
        
        label.text = "화장실 위치 확인하기"
        //label.textAlignment = .center
        //label.backgroundColor = .red
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        
        return label
    }()
    
    private lazy var stackViewForToilet: UIStackView = {
        let st = UIStackView(arrangedSubviews: [tolietSFIcon,tolietViewLabel])
        st.distribution = .fill
        st.alignment = .center
        st.backgroundColor = Color.toiletBackGround
        st.spacing = 10
        st.axis = .horizontal
        st.clipsToBounds = true
        st.layer.cornerRadius = CornerRadius.normal
        st.addSubview(tolietViewButton)
        st.isLayoutMarginsRelativeArrangement = true
        
        return st
    }()
    
    //MARK: 공원 관련 정보 탭 (시설, 행사)
    
    
    private lazy var eventCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: "EventCell")
        collectionView.showsVerticalScrollIndicator = false
        //collectionView.backgroundColor = .red
        collectionView.contentInset = .zero
        return collectionView
    }()
    
    private let noEventLabel: UILabel = {
        let label = UILabel()
        label.text = "예정 행사가 없는거 같아요 \n😢"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    //섹션 레이블
    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.text = "주요시설과 행사정보"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    private lazy var subView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = CornerRadius.normal
        view.addSubview(facilitiesSection)
        view.addSubview(nofacilities)
        view.addSubview(eventLabel)
        view.addSubview(eventCollectionView)
        view.addSubview(noEventLabel)
        view.addSubview(facilitiesTableView)
        
        return view
    }()
    //공원 시설 정보 표시 레이블
    private let facilitiesSection: UILabel = {
        let label = UILabel()
        
        label.text = "시설 관련 정보"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        // 하단 선 추가
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.gray // 회색 테두리 색상
        bottomLine.frame = CGRect(x: 0, y: label.frame.height - 1, width: label.frame.width, height: 1)
        label.addSubview(bottomLine)
        
        return label
    }()
    
    private let nofacilities: UILabel = {
        let label = UILabel()

        label.text = "시설물 정보가 없어요 \n😢"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // 시설 정보 테이블 뷰 추가
    let facilitiesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .green
        tableView.register(FacilityCell.self, forCellReuseIdentifier: "FacilityCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    private let lines: UIView = {
        let line = UIView()

        return line
    }()
    //행사 정보 표시 레이블
    private let eventLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "공원 주변 행사"
        
        return label
    }()
    
    
    @objc
    func toiletButton() {
        print("화장실 버튼 눌림")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Color.sheetColor
        topLabelConfigureUI()
        scrollViewConfigureUI()
        mainViewConfigureUI()
        toiletConfigureUI()
        bottomViewConfigureUI()
        infoButtonConfigureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        private func topLabelConfigureUI() {
        self.addSubview(leftTimeLabel)
            self.addSubview(sheetGrabber)
        
        leftTimeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(40)
        }
            sheetGrabber.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.width.equalTo(41)
                $0.height.equalTo(6)
                $0.bottom.equalTo(leftTimeLabel.snp.top).offset(-20)
            }
    }
    private func scrollViewConfigureUI() {
        self.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(leftTimeLabel.snp.bottom).offset(20)
            $0.bottom.equalToSuperview()
        }
    }
    private func mainViewConfigureUI() {
        //self.addSubview(mainView)
        
        mainView.snp.makeConstraints {
//            $0.top.equalTo(leftTimeLabel.snp.bottom).offset(Fedding.normal)
            $0.top.equalTo(scrollView.contentLayoutGuide)
            $0.height.equalTo(182)
            $0.width.equalTo(368)
            $0.centerX.equalToSuperview()
//           $0.leading.equalTo(scrollView.contentLayoutGuide).offset(Pedding.normal)
//            $0.trailing.equalToSuperview()
 
//            $0.leading.equalToSuperview().offset(Fedding.normal)
//            $0.trailing.equalToSuperview().inset(Fedding.normal)
        }
        
        parkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Pedding.normal)
            $0.height.width.equalTo(150)
        }
        
        congestionLable.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.width.equalTo(180)
            $0.trailing.equalToSuperview().inset(Pedding.normal)
            $0.top.equalTo(parkImageView.snp.top)
            $0.leading.equalTo(parkImageView.snp.trailing).offset(Pedding.normal)
        }
        
        parkNameLable.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(174)
            $0.leading.equalTo(parkImageView.snp.trailing).offset(Pedding.normal)
        }
    }
    
    private func toiletConfigureUI() {
        //self.addSubview(stackViewForToilet)
        
        tolietViewButton.snp.makeConstraints {
            $0.edges.equalTo(stackViewForToilet)
        }
        stackViewForToilet.snp.makeConstraints {
            $0.centerX.equalTo(mainView.snp.centerX)
            $0.top.equalTo(mainView.snp.bottom).offset(30)
            $0.height.equalTo(70)
            $0.width.equalTo(mainView.snp.width)
        }
        
        tolietSFIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(90)
//            $0.leading.equalToSuperview().offset(Fedding.normal)
           // $0.trailing.equalTo(tolietViewLabel.snp.leading).offset(20)
            $0.height.width.equalTo(28)
            $0.centerY.equalToSuperview()
        }
        tolietViewLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
//            $0.trailing.equalTo(rightSFIcon.snp.leading).offset(-10)
            //$0.centerY.equalToSuperview()
            $0.width.equalTo(60)
        }
//        rightSFIcon.snp.makeConstraints {
//            $0.trailing.equalToSuperview().inset(Fedding.normal)
//            $0.width.equalTo(15)
//            $0.height.equalTo(24)
//            $0.centerY.equalToSuperview()
//        }
        
    }

    private func bottomViewConfigureUI() {
        //[subView,sectionLabel].forEach {self.addSubview($0)}
        //섹션 레이블
        sectionLabel.snp.makeConstraints {
            $0.top.equalTo(tolietViewButton.snp.bottom).offset(Pedding.normal)
            $0.leading.equalTo(Pedding.normal)
        }
        //이벤트 컬렉션뷰
        eventCollectionView.snp.makeConstraints {
            $0.top.equalTo(eventLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(400)
            $0.bottom.equalToSuperview()
        }
        noEventLabel.snp.makeConstraints {
            $0.center.equalTo(eventCollectionView)
        }
        subView.snp.makeConstraints {
            $0.centerX.equalTo(mainView.snp.centerX)
            $0.top.equalTo(sectionLabel.snp.bottom).offset(Pedding.normal)
            $0.width.equalTo(368)
            $0.height.equalTo(300)
            $0.bottom.equalTo(scrollView.contentLayoutGuide)
        }
        facilitiesSection.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview()
//            $0.top.equalToSuperview()
//            $0.bottom.equalTo(eventLabel.snp.top)
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(Pedding.normal)
            $0.height.equalTo(30)
        }
        
        facilitiesTableView.snp.makeConstraints {
            $0.top.equalTo(facilitiesSection.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(Pedding.normal)
            $0.height.equalTo(100)
            //$0.bottom.equalTo(eventLabel.snp.top)
        }

 
        //시설 정보 없음 레이블
        nofacilities.snp.makeConstraints {
            $0.center.equalTo(facilitiesTableView)
        }
        
        eventLabel.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(116)
//            $0.bottom.equalToSuperview()
            $0.top.equalTo(facilitiesTableView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(Pedding.normal)
            $0.height.equalTo(30)
        }
    }
    
     func infoButtonConfigureUI() {
        self.addSubview(congestionInfoButton)
        
        congestionInfoButton.snp.makeConstraints {
            $0.centerY.equalTo(congestionLable.snp.centerY)
            $0.trailing.equalTo(congestionLable.snp.trailing).inset(25)
            $0.width.height.equalTo(24)
        }
    }
}

// MARK: - Public Methods
extension SheetView {
    func updateEventList(isEmpty: Bool) {
        print(#function)
        print(isEmpty)
        if isEmpty == false {
            subView.snp.updateConstraints {
                $0.height.equalTo(650)
            }
        } else {
            subView.snp.updateConstraints {
                $0.height.equalTo(350)
            }
        }
        eventCollectionView.reloadData()
        noEventLabel.isHidden = !isEmpty
    }
    
    func updateFacilitiesItem(isEmpty: Bool) {
        facilitiesTableView.reloadData()
        print(#function)
        print(isEmpty)
        nofacilities.isHidden = !isEmpty
    }
    
    func setupEventCollectionView(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        eventCollectionView.delegate = delegate
        eventCollectionView.dataSource = dataSource
    }
}

//@available(iOS 17.0, *)
//#Preview {
//    SheetViewController()
//}
//
