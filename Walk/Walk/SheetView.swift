//
//  SheetView.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/22/25.
//

import UIKit
import SnapKit

class SheetView: UIView {
    
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
    //공원 도착 예정시간 레이블
    let leftTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "내 위치에서 N분 소요될 예정이에요!"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    //공원 이미지
    let parkImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = CornerRadius.normal
        image.image = UIImage(named: "parkImageDummy")
        
        return image
    }()
    
    //혼잡도 레이블
    let congestionLable: UILabel = {
        let label = UILabel()
        label.text = "혼잡"
        label.layer.cornerRadius  = CornerRadius.normal
        label.clipsToBounds = true
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.backgroundColor = Color.congestionLot
        
        return label
    }()
    
    //공원이름 레이블
    let parkNameLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "공원이름"
        
        return label
    }()
    
    //MARK: - 화장실 탭
    private lazy var tolietViewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(toiletButton), for: .touchUpInside)
        
        return button
    }()
    
    private let tolietSFIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "toilet.circle.fill")
        
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
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        
        return label
    }()
    
    private lazy var stackViewForToilet: UIStackView = {
        let st = UIStackView(arrangedSubviews: [tolietSFIcon,tolietViewLabel,rightSFIcon])
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
    
    @objc
    func toiletButton() {
        print("화장실 버튼 눌림")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Color.sheetColor
        configureUI()
        toiletConfigureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [mainView, leftTimeLabel].forEach {self.addSubview($0)}
        
        mainView.snp.makeConstraints {
            $0.top.equalTo(leftTimeLabel.snp.bottom).offset(Fedding.normal)
            $0.height.equalTo(182)
            $0.width.equalTo(368)
            $0.leading.equalToSuperview().offset(Fedding.normal)
            $0.trailing.equalToSuperview().inset(Fedding.normal)
        }
        
        parkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Fedding.normal)
            $0.height.width.equalTo(150)
        }
        
        congestionLable.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.width.equalTo(41)
            $0.top.equalTo(parkImageView.snp.top)
            $0.leading.equalTo(parkImageView.snp.trailing).offset(Fedding.normal)
        }
        
        parkNameLable.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(parkImageView.snp.trailing).offset(Fedding.normal)
        }
        
        
        leftTimeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(Fedding.normal)
        }
        
    }
    
    private func toiletConfigureUI() {
        [stackViewForToilet].forEach { self.addSubview($0)}
        
        tolietViewButton.snp.makeConstraints {
            $0.edges.equalTo(stackViewForToilet)
        }
        stackViewForToilet.snp.makeConstraints {
            $0.centerX.equalTo(mainView.snp.centerX)
            $0.top.equalTo(mainView.snp.bottom).offset(20)
            $0.height.equalTo(70)
            $0.width.equalTo(mainView.snp.width)
        }
        
        tolietSFIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Fedding.normal)
            $0.height.width.equalTo(38)
            $0.centerY.equalToSuperview()
        }
        tolietViewLabel.snp.makeConstraints {
            $0.leading.equalTo(tolietSFIcon.snp.trailing).offset(10)
            $0.trailing.equalTo(rightSFIcon.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }
        rightSFIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Fedding.normal)
            $0.width.equalTo(15)
            $0.height.equalTo(24)
            $0.centerY.equalToSuperview()
        }
        
    }
    
    
}



@available(iOS 17.0, *)
#Preview {
    SheetViewController()
}

