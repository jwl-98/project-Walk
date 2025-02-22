//
//  File.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/22/25.
//

import Foundation
import UIKit
import SnapKit

public enum Color {
    //시트컬러
    static let sheetColor = UIColor(hexCode: "F7F7F6")
    static let toiletBackGround = UIColor(hexCode: "365E32")
    static let congestionNone = UIColor(hexCode: "#d3d3d3")
    static let congestionRelex = UIColor(hexCode: "00D369") //여유
    static let congestionNormal = UIColor(hexCode: "FEB100") //보통
    static let congestionMiddle = UIColor(hexCode: "FF8041") //약간붐빔
    static let congestionLot = UIColor(hexCode: "DD1E3D") //혼잡
    static let lightGreen = UIColor(hexCode: "E7F0DC")
    static let congestionBackground = UIColor(hexCode: "80AF81")
}

public enum MarkerImage {
    static let markerDefault: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "Marker_기본")
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 41, height: 41)
        return imageView
    }()
    static let markerGreen: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "Marker_여유")
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 41, height: 41)
        return imageView
    }()
    static let markerYellow: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "Marker_보통")
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 41, height: 41)
        return imageView
    }()
    
    static let markerOrange: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "Marker_약간혼잡")
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 41, height: 41)
        return imageView
    }()
    static let markerRed: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "Marker_혼잡")
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 41, height: 41)
        return imageView
    }()
    
    static let MarkerToilet: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "Marker_화장실")
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 36, height: 45)
        return imageView
    }()
}


public enum DesignComponents {
    static let sheetGrabber = UIImage(named: "SheetGrabber")
    
    static let mainTabBarDefault: UIImage = {
        let image = UIImage(named: "탭바메인_기본")!
        let resizeImage =  image.resize(image: image, targetSize: CGSize(width: 28, height: 28))
        
        return resizeImage
    }()
    
    static let mainTabBarTapped: UIImage = {
        let image = UIImage(named: "탭바메인_클릭")!
        let resizeImage =  image.resize(image: image, targetSize: CGSize(width: 28, height: 28))
        
        return resizeImage
    }()
    
    static let listTabBarDefault: UIImage = {
        let image = UIImage(named: "리스트탭바_기본")!
        let resizeImage =  image.resize(image: image, targetSize: CGSize(width: 28, height: 28))
        
        return resizeImage
    }()
    
    static let listTabBarTapped: UIImage = {
        let image = UIImage(named: "리스트탭바_클릭")!
        let resizeImage =  image.resize(image: image, targetSize: CGSize(width: 28, height: 28))
        
        return resizeImage
    }()
    
    static let listTabCongestionDefault: UIImage = {
        let image = UIImage(named: "리스트_이미지")!
        let resizeImage =  image.resize(image: image, targetSize: CGSize(width: 24, height: 24))
        
        return resizeImage
    }()
}
public enum Pedding {
    static let normal: CGFloat = 20
    static let item: CGFloat = 12
}

public enum CornerRadius {
    static let normal: CGFloat = 8
}

extension UIImage {
    func resize(image: UIImage, targetSize: CGSize) -> UIImage {
        let render = UIGraphicsImageRenderer(size: targetSize)
        return render.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

extension UIColor {
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

extension Date {
    static func todayInt() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let todayString = dateFormatter.string(from: Date())
        
        return Int(todayString)!
    }
}
