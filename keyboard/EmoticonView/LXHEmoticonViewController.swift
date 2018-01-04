//
//  EmoticonViewController.swift
//  键盘
//  初始化一个键盘控制器
//  Created by JinShiJinSheng on 2018/1/4.
//  Copyright © 2018年 JinShiJinSheng. All rights reserved.
//  git@github.com:Lxh93/keyboard.git

import UIKit

let lxhEmoticonCell = "lxhEmoticonCell"

let width = UIScreen.main.bounds.width/7

class LXHEmoticonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("初始化一个键盘控制器")
        setupUI()
    }
    private func setupUI()
    {
        view.backgroundColor = UIColor.red
        
        view.addSubview(collectionView)
        
        view.addSubview(toolBar)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        
        let dic = ["collectionView":collectionView,"toolBar":toolBar] as [String : Any]
        
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dic)
        
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dic)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:[collectionView(\(3*width+3))]-[toolBar(49)]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dic)
        
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
        for title in ["最近","默认","emoji","浪小花"]
        {
            let item = UIBarButtonItem.init(title: title, style: UIBarButtonItemStyle.plain, target: self, action: #selector(itemClick(item:)))
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
        }
    }
    private func setupUI(){
        contentView.addSubview(imgBtn)
    }
    lazy var imgBtn:UIButton = {
        
        let btn = UIButton.init(type: UIButtonType.custom)
        btn.frame = contentView.bounds.insetBy(dx: 4, dy: 4)
        btn.backgroundColor = UIColor.white
        return btn
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class LXHemoticonLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
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
