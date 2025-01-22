//
//  ModalViewController.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/22/25.
//

import UIKit

class SheetViewController: UIViewController {
    let sheetView = SheetView()
    
    override func loadView() {
        view = sheetView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

@available(iOS 17.0, *)
#Preview {
    SheetViewController()
}

