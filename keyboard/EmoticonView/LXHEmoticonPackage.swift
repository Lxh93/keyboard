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
        for dic in dicArr {
            emoticons?.append(LXHEmoticon.init(dict: dic, id: id!))
        }
    }
    class func loadPackage() -> [LXHEmoticonPackage] {
        let path = Bundle.main.path(forResource: "emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")
        
        let dic = NSDictionary.init(contentsOfFile: path!)
        
        let dicArr = dic!["packages"] as! [[String: AnyObject]]
        
        var packages = [LXHEmoticonPackage]()
        
        for dict in dicArr {
            
            let package = LXHEmoticonPackage.init(id: dict["id"] as! String)
            package.loadEmoticons()
            packages.append(package)
        }
        return packages
    }
}
class LXHEmoticon: NSObject {
    ///表情对应的文字
    var chs: String?
    ///表情对应的图片
    var png: String?
    {
        didSet{
            imagePath = (LXHEmoticonPackage.emoticonPath().appendingPathComponent(id!) as NSString).appendingPathComponent(png!)
        }
    }
    ///emoji表情对应的十六进制字符串
    var code: String?
    {
        didSet{
            //创建一个扫描器，扫描器可以从字符串中提取我们想要的数据
            let scanner = Scanner.init(string: code!)
            //将十六进制转换为字符串
            var result:UInt32 = 0
            scanner.scanHexInt32(&result)
            //将十六进制转换为emoji字符串
            emojiStr = "\(Character(UnicodeScalar(result)!))"
        }
    }
    
    var emojiStr: String?
    ///当前表情对应的文件夹
    var id: String?
    ///表情图片的全路径
    var imagePath: String?
    
    init(dict: [String: String],id: String) {
        super.init()
        self.id = id
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print(key,value as Any)
    }
}
