//
//  CongestionListTableViewCell.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 2/21/25.
//

import UIKit
import SnapKit

class CongestionListCell: UITableViewCell {
    
    let parkImageView: UIImageView = {
       let imageView = UIImageView()
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = CornerRadius.normal
        imageView.backgroundColor = .red
        
        return imageView
    }()
    
    let parkCongestionLVImageView: UIImageView = {
       let imageView = UIImageView()
        
        imageView.image = DesignComponents.listTabCongestionDefault
        
        return imageView
    }()
    
    lazy var parkCongestionView: UIView = {
        let view = UIView()
        
        view.backgroundColor = Color.congestionBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = CornerRadius.normal
        view.addSubview(parkCongestionLabel)
        view.addSubview(parkCongestionLVImageView)
        
        return view
    }()
    
   let parkCongestionLabel: UILabel = {
       let label = UILabel()
        
        label.text = "여유"
        label.textColor = .white
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        
        return label
    }()
    
    let parkNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "공원 이름 이름 이름 이름"
        label.backgroundColor = .green
        
        return label
    }()
    
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [parkImageView, parkCongestionView, parkNameLabel].forEach { contentView.addSubview($0) }
        
        parkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(104)
            $0.leading.equalTo(20)
        }
        
        parkNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(15)
            $0.leading.equalTo(parkImageView.snp.trailing).offset(Pedding.normal)
        }
        
        parkCongestionView.snp.makeConstraints {
            $0.bottom.equalTo(parkNameLabel.snp.top).offset(-15)
            $0.leading.equalTo(parkNameLabel.snp.leading)
            $0.width.equalTo(70)
            $0.height.equalTo(30)
        }
        
        parkCongestionLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(5)
            $0.centerY.equalToSuperview()
        }
        
        parkCongestionLVImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(5)
            $0.centerY.equalToSuperview()
        }
        
    }

}


@available(iOS 17.0, *)
#Preview {
    ListViewController()
}

