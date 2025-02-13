//
//  EventCell.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 2/5/25.
//

import UIKit

// MARK: - Event Collection View Cell
class EventCell: UICollectionViewCell {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = CornerRadius.normal
        view.clipsToBounds = true
        view.addSubview(eventImageView)
        view.addSubview(titleLabel)
        view.addSubview(placeLabel)
        view.addSubview(dateLabel)
        view.addSubview(dateImage)

        return view
    }()
    private let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = CornerRadius.normal
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray6
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()
    
    private let dateImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "캘린더")
        
        return image
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(158)
            $0.top.equalToSuperview()
            //$0.height.equalTo(280)
            //$0.edges.equalToSuperview().inset(5)
        }
        
        eventImageView.snp.makeConstraints {
            $0.width.equalTo(158)
            $0.height.equalTo(180)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(eventImageView.snp.centerX)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(eventImageView.snp.bottom).offset(10)
            //$0.top.leading.trailing.equalToSuperview().inset(12)
        }
        
        
        placeLabel.snp.makeConstraints {
            $0.centerX.equalTo(titleLabel.snp.centerX)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
        }
        
        dateImage.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel.snp.centerY)
            $0.trailing.equalTo(dateLabel.snp.leading).offset(-2)
            $0.width.height.equalTo(18)
        }
    }
    
    func configure(with event: Row) {
        titleLabel.text = event.title
        placeLabel.text = event.place
        loadImage(imageUrl: event.mainImg)
        
        let startDate = String(event.strtdate.prefix(10))
        let endDate = String(event.endDate.prefix(10))
        dateLabel.text = "\(startDate) ~ \(endDate)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        placeLabel.text = nil
        dateLabel.text = nil
        eventImageView.image = nil
    }
    
    private func loadImage(imageUrl: String) {
        guard let url = URL(string: imageUrl) else { return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self , let data = data, error == nil, let image = UIImage(data: data) else {return}
            DispatchQueue.main.async {
                self.eventImageView.image = image
            }
        }
        task.resume()
    }
}

//@available(iOS 17.0, *)
//#Preview {
//    CellViewController()
//}
