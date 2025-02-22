//
//  CheckViewController.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 2/22/25.
//

import UIKit

class CheckViewController: UIViewController {
    let ce = CongestionListCell()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = ce.contentView

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
