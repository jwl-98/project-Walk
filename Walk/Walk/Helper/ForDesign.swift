//
//  File.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/22/25.
//

import Foundation
import UIKit

public enum Color {
    //시트컬러
    static let sheetColor = UIColor(hexCode: "F7F7F6")
    static let toiletBackGround = UIColor(hexCode: "007AFF")
    static let congestionRelex = UIColor(hexCode: "91C6FF") //여유
    static let congestionNormal = UIColor(hexCode: "7BE7AA") //보통
    static let congestionMiddle = UIColor(hexCode: "FFAF88") //약간붐빔
    static let congestionLot = UIColor(hexCode: "FFA39E") //혼잡
    
}

public enum Fedding {
    static let normal: CGFloat = 20
}

public enum CornerRadius {
    static let normal: CGFloat = 8
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
