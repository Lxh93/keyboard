//
//  LXHEmoTextView.swift
//  keyboard
//
//  Created by JinShiJinSheng on 2018/1/6.
//  Copyright © 2018年 JinShiJinSheng. All rights reserved.
//

import UIKit

class LXHEmoTextView: UITextView {
    
    typealias finished = (_ text:String)->()
    /// 插入表情
    ///
    /// - Parameter emoticon: 需要的表情模型
    func insertEmoticon(emoticon: LXHEmoticon) {
        if emoticon.emojiStr != nil{
            self.replace(self.selectedTextRange!, withText: emoticon.emojiStr!)
            
        }
        if emoticon.png != nil {
            
            let attachment = LXHEmoAttachment.init()
            
            let font = self.font!
            
            attachment.image = UIImage.init(contentsOfFile: emoticon.imagePath!)
            attachment.bounds = CGRect.init(x: 0, y: -3.8, width: self.font!.lineHeight, height: self.font!.lineHeight)
            attachment.chs = emoticon.chs
            let imageText = NSAttributedString.init(attachment: attachment)
            
            let strM = NSMutableAttributedString.init(attributedString: self.attributedText)
            
            let range = self.selectedRange
            
            strM.replaceCharacters(in: range, with: imageText)
            strM.addAttribute(NSAttributedStringKey.font, value: font, range: NSRange.init(location: range.location, length: 1))
            //恢复光标的所在位置
            self.attributedText = strM
            self.selectedRange = NSRange.init(location: range.location+1, length: 0)
            
        }
        
        if emoticon.isRemoveButton {
            self.deleteBackward()
        }
    }
    /**
     获取需要发送给服务器的字符串
     */
    func emoticonAttributedText(finished:finished)
    {
        self.attributedText.enumerateAttributes(in: NSRange.init(location: 0, length: self.attributedText.length), options: NSAttributedString.EnumerationOptions.init(rawValue: 0)) { (objc, range, _) in
            
            var strM = String()
            
            if objc[NSAttributedStringKey.attachment] != nil{
                let attachment = objc[NSAttributedStringKey.attachment] as! LXHEmoAttachment
                strM += attachment.chs!
            }else{
                
                strM += (self.text as NSString).substring(with: range)
            }
            finished(strM)
        }
        
    }
    func test(finished:((_ block:String)->(String))){
        let str = finished("我是一个测试")
        print(str)
    }
    
}
