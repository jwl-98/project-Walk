//
//  PopoverViewController.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 2/20/25.
//

import UIKit
import SnapKit

class PopoverViewController: UIViewController {
    let congestionMSGLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureLabel()
        // Do any additional setup after loading the view.
    }
    
    private func configure() {
        view.backgroundColor = Color.popViewBackground
        preferredContentSize = .init(width: 200, height: 100)
        modalPresentationStyle = .popover
    }
    
    private func configureLabel() {
        view.addSubview(congestionMSGLable)
        
        congestionMSGLable.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().inset(5)
            $0.bottom.equalToSuperview().offset(5)
        }
    }

}

extension PopoverViewController: UIPopoverPresentationControllerDelegate {
    // Popover 스타일 표시하려면 필수
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}

@available(iOS 17.0, *)
#Preview {
    PopoverViewController()
}
