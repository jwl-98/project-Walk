//
//  TabVarViewController.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 2/21/25.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainVC = MainViewController()
        let listVC = ListViewController()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12, weight: .bold)
        ]
        
        self.setViewControllers([mainVC, listVC], animated: true)
        self.modalPresentationStyle = .fullScreen
        self.tabBar.backgroundColor = .white
        
        mainVC.tabBarItem = UITabBarItem(title: "내 주변 공원", image: DesignComponents.mainTabBarDefault.withRenderingMode(.alwaysOriginal), selectedImage: DesignComponents.mainTabBarTapped.withRenderingMode(.alwaysOriginal))
        
        listVC.tabBarItem = UITabBarItem(title: "한눈에 혼잡도 보기", image: DesignComponents.listTabBarDefault.withRenderingMode(.alwaysOriginal), selectedImage: DesignComponents.listTabBarTapped.withRenderingMode(.alwaysOriginal))
        
        
        mainVC.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        listVC.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
    }
    
}
