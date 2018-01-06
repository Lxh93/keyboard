//
//  ViewController.swift
//  键盘
//
//  Created by JinShiJinSheng on 2018/1/4.
//  Copyright © 2018年 JinShiJinSheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var customTextView: LXHEmoTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController(emoticonVC)
        customTextView.inputView = emoticonVC.view
        
    }
    @IBAction func itemClick(_ sender: UIBarButtonItem) {
        self.customTextView.emoticonAttributedText { (text) in
            print(text)
        }
        self.customTextView.test { (text) in
            print("我是一个测试")
            return "测试成功"
        }
    }
    // MARK: - 懒加载
    // weak 相当于OC中的 __weak , 特点对象释放之后会将变量设置为nil
    // unowned 相当于OC中的 unsafe_unretained, 特点对象释放之后不会将变量设置为nil
    private lazy var emoticonVC:LXHEmoticonViewController = LXHEmoticonViewController.init { [unowned self] (emoticon: LXHEmoticon) in
        
        self.customTextView.insertEmoticon(emoticon: emoticon)
        /*
        if emoticon.emojiStr != nil{
            self.customTextView.replace(self.customTextView.selectedTextRange!, withText: emoticon.emojiStr!)
            
        }
        if emoticon.png != nil {
            
            let attachment = LXHEmoAttachment.init()
            
            let font = self.customTextView.font!
            
            attachment.image = UIImage.init(contentsOfFile: emoticon.imagePath!)
            attachment.bounds = CGRect.init(x: 0, y: -3.8, width: 20.2, height: 20.2)
            attachment.chs = emoticon.chs
            let imageText = NSAttributedString.init(attachment: attachment)
            
            let strM = NSMutableAttributedString.init(attributedString: self.customTextView.attributedText)
            
            let range = self.customTextView.selectedRange
            
            strM.replaceCharacters(in: range, with: imageText)
            strM.addAttribute(NSAttributedStringKey.font, value: font, range: NSRange.init(location: range.location, length: 1))
            //恢复光标的所在位置
            self.customTextView.attributedText = strM
            self.customTextView.selectedRange = NSRange.init(location: range.location+1, length: 0)
            
        }
        
        if emoticon.isRemoveButton {
            self.customTextView.deleteBackward()
        }
         */
    }
}

