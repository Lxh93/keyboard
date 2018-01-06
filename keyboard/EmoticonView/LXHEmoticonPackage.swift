//
//  LXHEmoticonPackage.swift
//  keyboard
//
//  Created by JinShiJinSheng on 2018/1/4.
//  Copyright © 2018年 JinShiJinSheng. All rights reserved.
//

import UIKit

class LXHEmoticonPackage: NSObject {
    
    var id: String?
    
    var group_name_cn: String?
    
    var emoticons: [LXHEmoticon]?
    
    private lazy var contains: [LXHEmoticon] = [LXHEmoticon]()
    
    init(id: String) {
        
        self.id = id
    }
    ///获取微博表情的主路径
    class func emoticonPath() -> NSString {
        return (Bundle.main.bundlePath as NSString).appendingPathComponent("Emoticons.bundle") as NSString
    }
    ///获取指定文件的全路径
    func infoPath(fileName: String) -> String
    {
        return (LXHEmoticonPackage.emoticonPath().appendingPathComponent(id!) as NSString).appendingPathComponent(fileName)
    }
    ///加载每一组的所有的表情
    func loadEmoticons(){
        let emoticonDic = NSDictionary.init(contentsOfFile: infoPath(fileName: "info.plist"))!
        group_name_cn = emoticonDic["group_name_cn"] as? String
        let dicArr = emoticonDic["emoticons"] as! [[String: String]]
        emoticons = [LXHEmoticon]()
        
        var index = 0
        for dic in dicArr {
            if index == 20
            {
                emoticons?.append(LXHEmoticon.init(isRemoveButton: true))
                index = 0
            }
            emoticons?.append(LXHEmoticon.init(dict: dic, id: id!))
            index += 1
        }
    }
    class func loadPackage() -> [LXHEmoticonPackage] {
        
        let path = Bundle.main.path(forResource: "emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")
        
        let dic = NSDictionary.init(contentsOfFile: path!)
        
        let dicArr = dic!["packages"] as! [[String: AnyObject]]
        
        var packages = [LXHEmoticonPackage]()
        //最近使用的表情
        let package = LXHEmoticonPackage.init(id: "")
        package.group_name_cn = "最近"
        package.emoticons = [LXHEmoticon]()
        package.appendEmtyEmoticons()
        packages.append(package)
        
        for dict in dicArr {
            
            let package = LXHEmoticonPackage.init(id: dict["id"] as! String)
            
            package.loadEmoticons()
            packages.append(package)
            package.appendEmtyEmoticons()
        }
        return packages
    }
    
    /**
     追加空白按钮
     如果一页不足21个,那么就添加一些空白按钮补齐
     */
    func appendEmtyEmoticons()
    {
        
        let count = emoticons!.count % 21
        
        // 追加空白按钮
        for _ in count..<20
        {
            // 追加空白按钮
            emoticons?.append(LXHEmoticon.init(isRemoveButton: false))
        }
        // 追加一个删除按钮
        emoticons?.append(LXHEmoticon.init(isRemoveButton: true))
        
    }
    
    /// 添加最近使用的表情
    ///
    /// - Parameter emoticon: 最近点击的表情模型
    func appendEmoticons(emoticon:LXHEmoticon,reload:()->()){
        
        if emoticon.isRemoveButton {
            return
        }
        let contain = emoticons!.contains(emoticon)
        
        if !contain{
            
            if contains.count == 40 {
                contains.removeLast()
                contains.insert(emoticon, at: 0)
            }else if contains.count == 0{
                contains.append(emoticon)
            }else{
                contains.insert(emoticon, at: 0)
            }
            
            if contains.count == 40 {//最多保存两页最近使用的表情
                emoticons?.removeLast()
                emoticons?.removeLast()
                emoticons?.insert(emoticon, at: 0)
                (emoticons![20],emoticons![21]) = (emoticons![21],emoticons![20])
                emoticons?.append(LXHEmoticon.init(isRemoveButton: true))
            }else if contains.count < 40 && contains.count > 20{
                emoticons?.insert(emoticon, at: 0)
                if contains.count == 21{
                    appendEmtyEmoticons()
                    (emoticons![20],emoticons![21]) = (emoticons![21],emoticons![20])
                    //回调刷新表格
                    reload()
                }else{
                    (emoticons![20],emoticons![21]) = (emoticons![21],emoticons![20])
                    emoticons?.removeLast()
                    emoticons?.removeLast()
                    
                    emoticons?.append(LXHEmoticon.init(isRemoveButton: true))
                }
            }else{
                emoticons?.removeLast()
                emoticons?.removeLast()
                emoticons?.insert(emoticon, at: 0)
                emoticons?.append(LXHEmoticon.init(isRemoveButton: true))
            }
        }else{
            
        }
        print(contains.count)
    }
}
class LXHEmoticon: NSObject {
    ///表情对应的文字
    var chs: String?
    ///表情对应的图片
    var png: String?
    {
        didSet{
            /*
            imagePath = (LXHEmoticonPackage.emoticonPath().appendingPathComponent(id!) as NSString).appendingPathComponent(png!)
             */
        }
    }
    ///emoji表情对应的十六进制字符串
    var code: String?
    {
        didSet{
            /*
            //创建一个扫描器，扫描器可以从字符串中提取我们想要的数据
            let scanner = Scanner.init(string: code)
            //将十六进制转换为字符串
            var result:UInt32 = 0
            scanner.scanHexInt32(&result)
            //将十六进制转换为emoji字符串
            emojiStr = "\(Character(UnicodeScalar(result)!))"
            */
        }
    }
    
    var emojiStr: String?
    ///当前表情对应的文件夹
    var id: String?
    ///表情图片的全路径
    var imagePath: String?
    
    var isRemoveButton: Bool = false
    
    init(dict: [String: String],id: String) {
        super.init()
        self.id = id
        chs = dict["chs"]
        if dict["code"] != nil {
            
            code = dict["code"]!
            //创建一个扫描器，扫描器可以从字符串中提取我们想要的数据
            let scanner = Scanner.init(string: code!)
            //将十六进制转换为字符串
            var result:UInt32 = 0
            scanner.scanHexInt32(&result)
            //将十六进制转换为emoji字符串
            emojiStr = "\(Character(UnicodeScalar(result)!))"
        }
        if dict["png"] != nil {
            png = dict["png"]
            imagePath = (LXHEmoticonPackage.emoticonPath().appendingPathComponent(id) as NSString).appendingPathComponent(png!)
        }
    }
    init(isRemoveButton: Bool) {
        super.init()
        self.isRemoveButton = isRemoveButton
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print(key,value as Any)
    }
}
