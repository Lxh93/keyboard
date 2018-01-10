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
    
    var recentlyEmos: [LXHEmoticon]?
    
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
//                emoticons?.append(LXHEmoticon.init(isRemoveButton: true))
                index = 0
            }
            emoticons?.append(LXHEmoticon.init(dict: dic, id: id!))
            index += 1
        }
    }
    static let packages:[LXHEmoticonPackage] = loadPackage()
    //加载所有表情包
    private class func loadPackage() -> [LXHEmoticonPackage] {
        
        let path = Bundle.main.path(forResource: "emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")
        
        let dic = NSDictionary.init(contentsOfFile: path!)
        
        let dicArr = dic!["packages"] as! [[String: AnyObject]]
        
        var packages = [LXHEmoticonPackage]()
        
        //最近使用的表情
        let package = LXHEmoticonPackage.init(id: "")
        package.group_name_cn = "最近"
        if package.loadRecentlyEmos() != nil{
            
            package.recentlyEmos = package.loadRecentlyEmos()!
            package.replaceBundlePath(recentlyEmos: package.recentlyEmos!)
            package.saveRecentlyEmos(recentlyEmos: package.recentlyEmos!)
            package.emoticons = package.loadRecentlyEmos()!
        }else{
            package.recentlyEmos = [LXHEmoticon]()
            package.emoticons = [LXHEmoticon]()
        }
        package.appendEmtyEmoticons()
        packages.insert(package, at: 0)
        
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
        let page = emoticons!.count/20
        
        var deletes = 0
        
        
        if page > 0 {//超过一页
            for index in 1 ... page{
                
                emoticons?.insert(LXHEmoticon.init(isRemoveButton: true), at: index*21-1)
                //                emoticons?.removeLast()
                deletes += 1
            }
        }
        //        39
        let count = (emoticons!.count - 21*page)%21
        if count == 0 && emoticons?.count != 0 && recentlyEmos == nil{//除第一页以外 整除的不需要加空白按钮了
            return
        }
        if recentlyEmos != nil {
            if recentlyEmos!.count%20 == 0 && recentlyEmos!.count != 0 {
                return
            }
        }
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
        
        if emoticon.isRemoveButton || (emoticon.png == nil && emoticon.code == nil) {//点击删除或者空白按钮直接返回
            return
        }
        
        var contain = false
        var index = 0
        var recentlyIndex = 0
        if emoticons?.count == 0 || recentlyEmos?.count == 0{
            contain = false
        }else{
            for emo in emoticons!.enumerated() {
                if emo.element.imagePath == emoticon.imagePath && emo.element.code == emoticon.code{
                    contain = true
                    
                    index = emo.offset
                   
//                    emoticon = emo
                }
            }
            for emo in recentlyEmos!.enumerated() {
                if emo.element.imagePath == emoticon.imagePath && emo.element.code == emoticon.code{
                    contain = true
                    
                    recentlyIndex = emo.offset
                   
                }
            }
        }
        if !contain{
            //计算需要保存的表情模型
            if recentlyEmos?.count == 0{
                recentlyEmos?.insert(emoticon, at: 0)
            }else if recentlyEmos?.count == 40 {
                recentlyEmos!.removeLast()
                recentlyEmos!.insert(emoticon, at: 0)
            }else{
                recentlyEmos?.insert(emoticon, at: 0)
            }
            
            //计算需要显示的表情模型
            if recentlyEmos?.count == 40 {//最多保存两页最近使用的表情
                emoticons?.removeLast()
                emoticons?.removeLast()
                emoticons?.insert(emoticon, at: 0)
                (emoticons![20],emoticons![21]) = (emoticons![21],emoticons![20])
                emoticons?.append(LXHEmoticon.init(isRemoveButton: true))
            }else if recentlyEmos!.count < 40 && recentlyEmos!.count > 20{
                emoticons?.insert(emoticon, at: 0)
                if recentlyEmos!.count == 21{
                    emoticons?.removeLast()//此时最后一个是删除按钮
                    appendEmtyEmoticons()
//                    (emoticons![20],emoticons![21]) = (emoticons![21],emoticons![20])
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
            if index>20{
                recentlyEmos!.remove(at: recentlyIndex)
                recentlyEmos?.insert(emoticon, at: 0)
                emoticons!.remove(at: index)
                emoticons!.insert(emoticon, at: 0)
                (emoticons![20],emoticons![21]) = (emoticons![21],emoticons![20])

            }else{
                
                emoticons!.remove(at: index)
                emoticons!.insert(emoticon, at: 0)
                recentlyEmos!.remove(at: recentlyIndex)
                recentlyEmos?.insert(emoticon, at: 0)
            }
        }
        saveRecentlyEmos(recentlyEmos: recentlyEmos!)
        
    }
    private func saveRecentlyEmos(recentlyEmos: [LXHEmoticon]){
        NSKeyedArchiver.archiveRootObject(recentlyEmos, toFile: "recentlyEmos.plist".docDir())
    }
    func loadRecentlyEmos() -> [LXHEmoticon]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: "recentlyEmos.plist".docDir()) as? [LXHEmoticon]
    }
    //本地加载的表情模型需要替换地址
    func replaceBundlePath(recentlyEmos:[LXHEmoticon]){
        for emoticon in recentlyEmos {
            if emoticon.png != nil{
                emoticon.imagePath = (LXHEmoticonPackage.emoticonPath().appendingPathComponent(emoticon.id!) as NSString).appendingPathComponent(emoticon.png!)
            }
        }
    }
}
class LXHEmoticon: NSObject,NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(chs, forKey: "chs")
        aCoder.encode(png, forKey: "png")
        aCoder.encode(code, forKey: "code")
        aCoder.encode(emojiStr, forKey: "emojiStr")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(imagePath, forKey: "imagePath")
        aCoder.encode(isRemoveButton, forKey: "isRemoveButton")
    }
    
    required init?(coder aDecoder: NSCoder) {
        chs = aDecoder.decodeObject(forKey: "chs") as? String
        png = aDecoder.decodeObject(forKey: "png") as? String
        code = aDecoder.decodeObject(forKey: "code") as? String
        emojiStr = aDecoder.decodeObject(forKey: "emojiStr") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        imagePath = aDecoder.decodeObject(forKey: "imagePath") as? String
        isRemoveButton = (aDecoder.decodeObject(forKey: "isRemoveButton") != nil)
    }
    
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
