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
    
    var times = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if times == 0 {
            if packages[0].recentlyEmos?.count == 0{
                if collectionView.contentOffset.x == 0{
                    
                    collectionView.contentOffset.x += collectionView.bounds.size.width
                }
//            }
//            times = 1
        }
    }
    
    
    
    init(emoticon:  @escaping (_ emoticon:LXHEmoticon)->()) {
        
        emoticonBlock = emoticon
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    
    private func setupUI()
    {
        view.backgroundColor = UIColor.init(red: 160, green: 160, blue: 160, alpha: 1.0)
        
        view.addSubview(collectionView)
        
        view.addSubview(pageController)
        
        view.addSubview(toolBar)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        pageController.translatesAutoresizingMaskIntoConstraints = false
//        let width = self.view.frame.size.width/7
        var cons = [NSLayoutConstraint]()
        
        let dic = ["collectionView":collectionView,"toolBar":toolBar,"pageController":pageController] as [String : Any]
        
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dic)
        
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dic)
        
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageController]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dic)
//        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:[collectionView(\(3*width+3))]-[toolBar(49)]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dic)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-[pageController(16)]-0-[toolBar(49)]-0-|", options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: dic)
        
        view.addConstraints(cons)
    }
    private lazy var collectionView:UICollectionView = {
        let clv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: emoticonLayout)
        clv.register(LXHEmoticonCell.self, forCellWithReuseIdentifier: lxhEmoticonCell)
        clv.dataSource = self
        clv.delegate = self
        clv.backgroundColor = UIColor.init(red: 160, green: 160, blue: 160, alpha: 0.3)
        clv.showsVerticalScrollIndicator = false
        clv.showsHorizontalScrollIndicator = false
        return clv
    }()
    private lazy var toolBar:UIToolbar = {
        let bar = UIToolbar()
        bar.tintColor = UIColor.darkGray
        
        var index = 0
        var items = [UIBarButtonItem]()
        
        for package in packages
        {
            let item = UIBarButtonItem.init(title: package.group_name_cn, style: UIBarButtonItemStyle.plain, target: self, action: #selector(itemClick(item:)))
            item.tag = 10 + index
            index += 1
            items.append(item)
            items.append(UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil))
            
        }
        items.removeLast()
        bar.items = items
        
        return bar
    }()
    lazy var pageController: LXHPageControl = {
        let page = LXHPageControl.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: sBounds.width, height: 16)), pages: packages)
        page.clickPoint { [weak self](index) in
            self?.itemCounts[(self?.currentEmos)!] = index!
            self?.collectionView.contentOffset.x = CGFloat(index!+(self?.numsOfPagesBefore)!) * sBounds.width
            
        }
        return page
    }()
    
    /// 记录每个表情包滑动到第几页
    var itemCounts: [NSInteger] = [0,0,0,0]
    
    /// 记录每个表情包的总页数
    lazy var numOfPages:[NSInteger] =
    {
        //最近使用的表情有几页
        let emoticons1 = packages[0].emoticons!.count/21
        //默认的表情有几页
        let emoticons2 = packages[1].emoticons!.count/21
        //emoji的表情有几页
        let emoticons3 = packages[2].emoticons!.count/21
        //浪小花的表情有几页
        let emoticons4 = packages[3].emoticons!.count/21
        
        return [emoticons1,emoticons2,emoticons3,emoticons4]
    }()
    
    /// 记录当前表情包之前的表情包有多少页
    var numsOfPagesBefore = 0
    
    /// 记录当前是第几个表情包
    var currentEmos = 0
    
    
    
    private lazy var emoticonLayout: LXHFlowLayout = {
        
        let flowlayout = LXHFlowLayout.init(numOfItemsInRow: 7, numOfItemsInColumn: 3)
        
        return flowlayout
    }()
    private lazy var packages: [LXHEmoticonPackage] = LXHEmoticonPackage.packages
    @objc func itemClick(item: UIBarButtonItem)
    {
        let index = item.tag - 10
        currentEmos = index
        var indexPath:IndexPath?
        if index == 0 {
            //一般来说 点击最近表情应该是想要最近使用的表情 所以默认为第一页
            indexPath = IndexPath.init(item: 0, section: index)
        }else{
            indexPath = IndexPath.init(item: itemCounts[index] * 21, section: index)
        }
        pageController.changePageControllerNums(pages:numOfPages[index] , current: itemCounts[index])
        
        collectionView.scrollToItem(at: indexPath!, at: UICollectionViewScrollPosition.left, animated: true)
        numsOfPagesBefore = 0
        for i in 0..<index {
            numsOfPagesBefore += numOfPages[i]
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
/*
class LXHPageController: UIPageControl {
    
    init(packages:[LXHEmoticonPackage]) {
        super.init(frame: CGRect.zero)
        initThring(packages: packages)
        addTarget(self, action: #selector(test), for: .valueChanged)
        addBotBtn()
    }
    func initThring(packages:[LXHEmoticonPackage]){
        numberOfPages = packages[0].emoticons!.count/21
        pageIndicatorTintColor = UIColor.lightGray
        currentPageIndicatorTintColor = UIColor.gray
        hidesForSinglePage = true
    }
    @objc func test(){
        
    }
    func addBotBtn() {
        for i in 0..<subviews.count {
            subviews[i].isUserInteractionEnabled = true
            let btn = UIButton.init(type: UIButtonType.custom)
            btn.frame = subviews[i].bounds
            btn.tag = 10+i
            btn.addTarget(self, action: #selector(botBtnClick(botBtn:)), for: .touchUpInside)
            subviews[i].addSubview(btn)
            print(subviews[i])
        }
    }
    @objc func botBtnClick(botBtn:UIButton){
        print(".....",botBtn.tag)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func changePageControllerNums(pages: Int,current:Int){
        numberOfPages = pages
        currentPage = current
    }
}
 */
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
        btn.backgroundColor = UIColor.clear
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
//        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.red : UIColor.green
        let package = packages[indexPath.section]
        let emoticon = package.emoticons![indexPath.item]
        
        cell.emoticon = emoticon
        
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let emoticon = packages[indexPath.section].emoticons![indexPath.item]
        collectionView.reloadData()

        emoticonBlock(emoticon)
        
        packages[0].appendEmoticons(emoticon: emoticon, reload: {
            
            collectionView.reloadSections(IndexSet.init(integer: 0))
            collectionView.contentOffset.x += collectionView.bounds.size.width
        })
        
    }
//    1.完成最近表情的添加及显示（目前支持两页，实际开发中应该只需要一页 ，在最近表情有多页时需要刷新表格视图会有一个闪烁的bug 这个如果采用的是一个表格视图应该是没办法解决的 -- 可能需要使用不同的表格视图或者控制器去控制）
//    2.明日目标 完成对最近表情的本地化处理及从本地加载图片表情
    
    //利用该方法只在手动滑动界面时才会调用（点击按钮改变contentOffset不会触发该方法）去记录滑动到表情包的第几页
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index: NSInteger = NSInteger(scrollView.contentOffset.x/collectionView.bounds.size.width)
        
        //记录滑动到当前表情的第几页表情
        var current = 0
        /// 记录当前表情包的总页数
        var pages = 0
        
        if index < numOfPages[0] {
            //记录滑动到最近表情的第几页表情
            itemCounts[0] = index
            current = index
            pages = numOfPages[0]
            currentEmos = 0
        }else if numOfPages[0] <= index && index < numOfPages[1]+numOfPages[0]{
            //记录滑动到默认表情的第几页表情
            itemCounts[1] = index - numOfPages[0]
            current = itemCounts[1]
            pages = numOfPages[1]
            currentEmos = 1
        }else if numOfPages[1] <= index && index < numOfPages[2]+numOfPages[1]+numOfPages[0]{
            //记录滑动到emoji表情的第几页表情
            itemCounts[2] = index - numOfPages[0] - numOfPages[1]
            current = itemCounts[2]
            pages = numOfPages[2]
            currentEmos = 2
        }else if numOfPages[2] <= index && index < numOfPages[3]+numOfPages[2]+numOfPages[1]+numOfPages[0]{
            //记录滑动到浪小花表情的第几页表情
            itemCounts[3] = index - numOfPages[0] - numOfPages[1] - numOfPages[2]
            current = itemCounts[3]
            pages = numOfPages[3]
            currentEmos = 3
        }
        numsOfPagesBefore = 0
        for i in 0..<currentEmos {
            numsOfPagesBefore += numOfPages[i]
        }
        pageController.changePageControllerNums(pages: pages, current: current)
        
    }
}
