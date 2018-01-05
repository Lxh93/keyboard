//
//  EmoticonViewController.swift
//  键盘
//  初始化一个键盘控制器
//  Created by JinShiJinSheng on 2018/1/4.
//  Copyright © 2018年 JinShiJinSheng. All rights reserved.
//  git@github.com:Lxh93/keyboard.git
//1.完成表情的显示
//2.追加空白按钮及删除的按钮
//3.添加最近使用的表情组
import UIKit

let sBounds = UIScreen.main.bounds

let lxhEmoticonCell = "lxhEmoticonCell"

//let width = UIScreen.main.bounds.width/7

class LXHEmoticonViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI()
    {
        view.backgroundColor = UIColor.red
        
        view.addSubview(collectionView)
        
        view.addSubview(toolBar)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
//        let width = self.view.frame.size.width/7
        var cons = [NSLayoutConstraint]()
        
        let dic = ["collectionView":collectionView,"toolBar":toolBar] as [String : Any]
        
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dic)
        
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dic)
        
//        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:[collectionView(\(3*width+3))]-[toolBar(49)]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dic)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-[toolBar(49)]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dic)
        
        view.addConstraints(cons)
    }
    private lazy var collectionView:UICollectionView = {
        let clv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: LXHemoticonLayout())
        clv.register(LXHEmoticonCell.self, forCellWithReuseIdentifier: lxhEmoticonCell)
        clv.dataSource = self
        return clv
    }()
    private lazy var toolBar:UIToolbar = {
        let bar = UIToolbar()
        bar.tintColor = UIColor.darkGray
        
        var index = 0
        var items = [UIBarButtonItem]()
        
        for title in packages
        {
            let item = UIBarButtonItem.init(title: title.group_name_cn, style: UIBarButtonItemStyle.plain, target: self, action: #selector(itemClick(item:)))
            item.tag = 10 + index
            index += 1
            items.append(item)
            items.append(UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        bar.items = items
        return bar
    }()
    private lazy var packages: [LXHEmoticonPackage] = LXHEmoticonPackage.loadPackage()
    @objc func itemClick(item: UIBarButtonItem)
    {
        
    }
    
    
}
class LXHEmoticonCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    var emoticon: LXHEmoticon?
    {
        didSet{
            // 1.判断是否是图片表情
            if emoticon!.chs != nil
            {
                imgBtn.setImage(UIImage(contentsOfFile: emoticon!.imagePath!), for: .normal)
            }else
            {
                // 防止重用
                imgBtn.setImage(nil, for: .normal)
            }
            
            // 2.设置emoji表情
            // 注意: 加上??可以防止重用
            imgBtn.setTitle(emoticon!.emojiStr ?? "", for: .normal)
            // 3.判断是否是删除按钮
            if emoticon!.isRemoveButton
            {
                imgBtn.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
                imgBtn.setImage(UIImage(named: "compose_emotion_delete_highlighted"), for: .highlighted)
            }
        }
    }
    private func setupUI(){
        contentView.addSubview(imgBtn)
    }
    lazy var imgBtn:UIButton = {
        
        let btn = UIButton.init(type: UIButtonType.custom)
        btn.frame = contentView.bounds.insetBy(dx: 4, dy: 4)
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        return btn
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class LXHemoticonLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        let width = collectionView!.bounds.size.width/7
        
        itemSize = CGSize.init(width: width, height: width)
        
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
        //设置0.5在5s等小屏机型上可能会出问题
        
        let offY = (collectionView!.bounds.height - 3*width)*0.49
        
        collectionView?.contentInset = UIEdgeInsetsMake(offY, 0, offY, 0)
    }
}
extension LXHEmoticonViewController:UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return packages.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: lxhEmoticonCell, for: indexPath) as! LXHEmoticonCell
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.red : UIColor.green
        let package = packages[indexPath.section]
        let emoticon = package.emoticons![indexPath.item]
        
        cell.emoticon = emoticon
        
        return cell
    }
}
