//
//  CongestionListTableViewCell.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 2/21/25.
//

import UIKit
import SnapKit

class CongestionListCell: UITableViewCell {
    
    lazy var parkImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = CornerRadius.normal
        imageView.addSubview(parkCongestionView)
        
        return imageView
    }()
    
    lazy var parkCongestionView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.congestionBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = CornerRadius.normal
        view.addSubview(parkCongestionLabel)
        
        return view
    }()
    
    let parkCongestionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "여유"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
        return label
    }()
    
    let parkNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "공원 이름 이름 이름 이름"
        
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        parkCongestionView.backgroundColor = Color.congestionBackground
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Color.lightGreen
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [parkImageView, parkNameLabel].forEach { contentView.addSubview($0) }
        
        parkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(150)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }
        
        parkNameLabel.snp.makeConstraints {
            $0.top.equalTo(parkImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        parkCongestionView.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.height.equalTo(30)
            $0.bottom.equalToSuperview()
        }
        
        parkCongestionLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }
    
}


@available(iOS 17.0, *)
#Preview {
    CheckViewController()
}

