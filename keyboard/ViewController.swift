//
//  ViewController.swift
//  键盘
//
//  Created by JinShiJinSheng on 2018/1/4.
//  Copyright © 2018年 JinShiJinSheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var customTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController(emoticonVC)
        customTextView.inputView = emoticonVC.view
        
    }

    private lazy var emoticonVC:LXHEmoticonViewController = {
       let eVC = LXHEmoticonViewController()
        
        return eVC
    }()


}

