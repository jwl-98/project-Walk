//
//  ScrollViewController.swift
//  Walk
//
//  Created by 진욱의 Macintosh on 2/10/25.
//

import UIKit
import SnapKit

class ScrollViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .green
        
        view.addSubview(contentsView)
        
        return view
        
    }()
    
    let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        configureUI()

        // Do any additional setup after loading the view.
    }
    
    
    
    func configureUI(){
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints {
            $0.leading.trailing.equalTo(scrollView.contentLayoutGuide)
            $0.top.equalTo(scrollView.contentLayoutGuide)
            $0.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(100)
            $0.height.equalTo(10000)
        }
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

@available(iOS 17.0, *)
#Preview {
    ScrollViewController()
}

