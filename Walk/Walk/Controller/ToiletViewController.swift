//
//  ToiletViewController.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 1/26/25.
//

import UIKit

class ToiletViewController: UIViewController {
    
    let toiletView = ToiletView()
    
    override func loadView() {
        view = toiletView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
