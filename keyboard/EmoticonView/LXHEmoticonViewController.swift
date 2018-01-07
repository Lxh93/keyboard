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
    
    var emoticonBlock: (_ emoticon:LXHEmoticon)->()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    init(emoticon:  @escaping (_ emoticon:LXHEmoticon)->()) {
        
        emoticonBlock = emoticon
        
        super.init(nibName: nil, bundle: nil)
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
        let clv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: emoticonLayout)
        clv.register(LXHEmoticonCell.self, forCellWithReuseIdentifier: lxhEmoticonCell)
        clv.dataSource = self
        clv.delegate = self
//        clv.backgroundColor = UIColor.red
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
    var itemCounts: [NSInteger] = [0,0,0,0]
    private lazy var emoticonLayout: LXHFlowLayout = {
        let flowlayout = LXHFlowLayout.init(numOfItemsInRow: 7, numOfItemsInColumn: 3)
        
        return flowlayout
    }()
    private lazy var packages: [LXHEmoticonPackage] = LXHEmoticonPackage.loadPackage()
    @objc func itemClick(item: UIBarButtonItem)
    {
        let index = item.tag - 10
        
        let indexPath = IndexPath.init(item: itemCounts[index] * 21, section: index)
        
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: true)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            //设置emoji表情
            // 注意: 加上??可以防止重用
            imgBtn.setTitle(emoticon!.emojiStr ?? "", for: .normal)
            
            // 判断是否是图片表情
            if emoticon!.chs != nil
            {
                imgBtn.setImage(UIImage(contentsOfFile: emoticon!.imagePath!), for: .normal)
                
            }else
            {
                // 防止重用
                imgBtn.setImage(nil, for: .normal)
            }
            // 判断是否是删除按钮
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
        btn.isUserInteractionEnabled = false
        btn.backgroundColor = UIColor.white
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        return btn
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
/*
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
        
        self.sectionInset = UIEdgeInsetsMake(offY, 0, offY, 0)
//        collectionView?.contentInset = UIEdgeInsetsMake(offY, 0, offY, 0)
    }
}
 */
extension LXHEmoticonViewController:UICollectionViewDataSource,UICollectionViewDelegate
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
//        imagePath    String?    "/Users/lixiaohua/Library/Developer/CoreSimulator/Devices/25CF0C57-5B44-42F9-B066-D52F96D1D12E/data/Containers/Bundle/Application/23A80BF9-25DE-4EFF-AF57-5F94053ABF0A/keyboard.app/Emoticons.bundle/com.sina.default/d_zuiyou.png"    some
//        imagePath    String?    "/Users/lixiaohua/Library/Developer/CoreSimulator/Devices/25CF0C57-5B44-42F9-B066-D52F96D1D12E/data/Containers/Bundle/Application/634F0FA8-18AE-4978-BED7-56488C6DDF9E/keyboard.app/Emoticons.bundle/com.sina.default/d_zuiyou.png"    some
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let emoticon = packages[indexPath.section].emoticons![indexPath.item]
        collectionView.reloadData()
//       imagePath    String?    "/var/containers/Bundle/Application/C21310ED-6D53-4862-9C4F-5C99A7B213C4/keyboard.app/Emoticons.bundle/com.sina.lxh/lxh_xiaohaha.png"    some
//        imagePath    String?    "/var/containers/Bundle/Application/E950C78D-87F3-4BEA-810C-3FFF6D649DA3/keyboard.app/Emoticons.bundle/com.sina.lxh/lxh_xiaohaha.png"    some
//        imagePath    String?    "/var/containers/Bundle/Application/C21310ED-6D53-4862-9C4F-5C99A7B213C4/keyboard.app/Emoticons.bundle/com.sina.lxh/lxh_xiaohaha.png"    some
        emoticonBlock(emoticon)
        if indexPath.section != 0{
            packages[0].appendEmoticons(emoticon: emoticon, reload: {
                
                collectionView.reloadSections(IndexSet.init(integer: 0))
                collectionView.contentOffset.x += collectionView.bounds.size.width
            })
        }
    }
//    1.完成最近表情的添加及显示（目前支持两页，实际开发中应该只需要一页 ，在最近表情有多页时需要刷新表格视图会有一个闪烁的bug 这个如果采用的是一个表格视图应该是没办法解决的 -- 可能需要使用不同的表格视图或者控制器去控制）
//    2.明日目标 完成对最近表情的本地化处理及从本地加载图片表情
    //利用该方法只在手动滑动界面时才会调用（点击按钮改变contentOffset不会触发该方法）去记录滑动到表情包的第几页
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index: NSInteger = NSInteger(scrollView.contentOffset.x/collectionView.bounds.size.width)
        //最近使用的表情有几页
        let emoticons1 = packages[0].emoticons!.count/21
        //默认的表情有几页
        let emoticons2 = packages[1].emoticons!.count/21
        //emoji的表情有几页
        let emoticons3 = packages[2].emoticons!.count/21
        //浪小花的表情有几页
        let emoticons4 = packages[3].emoticons!.count/21
        
        if index < emoticons1 {
            //记录滑动到最近表情的第几页表情
            itemCounts[0] = index
            
        }else if emoticons1 <= index && index < emoticons2+emoticons1{
            //记录滑动到默认表情的第几页表情
            itemCounts[1] = index - emoticons1
            
        }else if emoticons2 <= index && index < emoticons3+emoticons2+emoticons1{
            //记录滑动到emoji表情的第几页表情
            itemCounts[2] = index - emoticons1 - emoticons2
            
        }else if emoticons3 <= index && index < emoticons4+emoticons3+emoticons2+emoticons1{
            //记录滑动到浪小花表情的第几页表情
            itemCounts[3] = index - emoticons1 - emoticons2 - emoticons3
        }
        
    }
}
