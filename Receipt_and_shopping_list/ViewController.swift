//
//  ViewController.swift
//  Receipt_and_shopping_list
//
//  Created by USER on 2018/03/17.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit
import RealmSwift


protocol ReceiptListControllerDelegate
{
    // デリゲート関数を定義
    func showList()
}

class ViewController: UIViewController, UITabBarDelegate, ViewControllerDelegate, UITabBarControllerDelegate {

    func reloadScrollView() {
        print("reloadScrollView")
        
        //ScrollView 削除
        self.myScrollView.removeFromSuperview()
        //ScrollView 再描画
        self.createScrollView()

    }

    private var myTabBar:TabBar!
    private var myScrollView:UIScrollView!
    private var myView:UIView!
    
    //Delegateを定義
    var delegate: ReceiptListControllerDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
        ReceiptListItemView.rootViewCon = self
        ReceiptListItemView.rootViewCon?.delegate = ReceiptListItemView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.view.backgroundColor = cGreen
       
        // Delegate
        AddHavingItemView.delegate = self
        ReceiptListItemView.rootViewCon = self
        
        self.navigationItem.title = "持っている食材"

    
        //******** UI 配置
        createUI()
        
        //******** ボタンを配置
        createButton()

        //******** HavingItem(手持ちの材料)を画面に表示
        //showHavingItem()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func defaultDataLoad() {
        do {
            try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
        } catch {}
        
        //******** 初期データセット
        //****** Item
        let item1 = Item()
        item1.name1 = "お米"
        item1.name2 = "こめ"
        item1.name3 = ""
        item1.name4 = ""
        item1.name5 = ""
        item1.group = 1
        Model.saveItem(item:item1);
        
        let item2 = Item()
        item2.name1 = "豚肉"
        item2.name2 = "ぶたにく"
        item2.name3 = ""
        item2.name4 = ""
        item2.name5 = ""
        item2.group = 1
        Model.saveItem(item:item2);
        
        let item3 = Item()
        item3.name1 = "たまご"
        item3.name2 = "卵"
        item3.name3 = ""
        item3.name4 = ""
        item3.name5 = ""
        item3.group = 1
        Model.saveItem(item:item3);
        
        let item4 = Item()
        item4.name1 = "大根"
        item4.name2 = "だいこん"
        item4.name3 = ""
        item4.name4 = ""
        item4.name5 = ""
        item4.group = 1
        Model.saveItem(item:item4);
        
        let item5 = Item()
        item5.name1 = "キムチ"
        item5.name2 = ""
        item5.name3 = ""
        item5.name4 = ""
        item5.name5 = ""
        item5.group = 1
        Model.saveItem(item:item5);
        
        
        //****** Receipt
        let receipt1 = Receipt()
        receipt1.receipt_name = "チャーハン"
        receipt1.detail = "中華の定番！"
        receipt1.photo = "fried_rice.jpg"
        receipt1.items.append(item1)
        receipt1.items.append(item2)
        receipt1.items.append(item3)
        Model.saveReceipt(receipt:receipt1)
        
        
        let receipt2 = Receipt()
        receipt2.receipt_name = "豚バラ大根"
        receipt2.detail = "お肉と野菜のコンボ！"
        receipt2.photo = "pork_radish.jpg"
        receipt2.items.append(item2)
        receipt2.items.append(item4)
        Model.saveReceipt(receipt:receipt2)
        
        
        let receipt3 = Receipt()
        receipt3.receipt_name = "豚キムチ"
        receipt3.detail = "辛いのマニアに！"
        receipt3.photo = "pork_korean_pickles.jpg"
        receipt3.items.append(item5)
        Model.saveReceipt(receipt:receipt3)
        
        
        //****** HavingItem
        let havingItem1 = HavingItem()
        havingItem1.items = item2
        Model.saveHavingItem2(havingItem:havingItem1)

        let havingItem2 = HavingItem()
        havingItem2.items = item3
        Model.saveHavingItem2(havingItem:havingItem2)

        let havingItem3 = HavingItem()
        havingItem3.items = item4
        Model.saveHavingItem2(havingItem:havingItem3)

    }
    
    
    func createLabelUI() {
        
        //ラベルを生成
        let titleLabel = UILabel(frame: CGRect(x:0, y:20, width:self.view.frame.width, height:30))
        titleLabel.textAlignment = .center
        titleLabel.text = "持っている材料"
        self.view.addSubview(titleLabel)
        
    }

    
    func createTabUI() {
        
        myTabBar = createUITab(width:self.view.frame.width, height:self.view.frame.height) as! TabBar
        
        //デリゲートを設定する
        myTabBar.delegate = self

        self.view.addSubview(myTabBar)
 
    }

    func createButton() {
        
        //「材料追加」ボタン
        let addHavingItemButton = UIButton(frame: CGRect(x: 10,y: self.view.frame.height - 230,width: self.view.frame.width/2 - 10,height:70))
        addHavingItemButton.setTitle("材料追加", for: .normal)
        addHavingItemButton.backgroundColor = cRed
        addHavingItemButton.addTarget(self, action: #selector(ViewController.goNext(_:)), for: .touchUpInside)
        addHavingItemButton.layer.cornerRadius = 10
        view.addSubview(addHavingItemButton)
        
        //「選択を削除」ボタン
        let delButton = UIButton(frame: CGRect(x: self.view.frame.width/2 + 10,y: self.view.frame.height - 230,width: self.view.frame.width/2 - 20,height:70))
        delButton.setTitle("選択を削除", for: .normal)
        delButton.backgroundColor = UIColor.lightGray
        //delButton.addTarget(self, action: #selector(ViewController.goNext(_:)), for: .touchUpInside)
        delButton.layer.cornerRadius = 10
        view.addSubview(delButton)

        //「選択した材料でレシピを検索」ボタン
        let searchButton = UIButton(frame: CGRect(x: 10,y: self.view.frame.height - 150,width: self.view.frame.width - 20,height:70))
        searchButton.setTitle("選択した材料でレシピを検索", for: .normal)
        searchButton.backgroundColor = cBlue
        searchButton.setTitleColor(UIColor.white, for: .normal)
        searchButton.addTarget(self, action: #selector(ViewController.receiptSearch(_:)), for: .touchUpInside)
        searchButton.layer.cornerRadius = 10
        view.addSubview(searchButton)

    }
    
    func createScrollView() {
        
        // ScrollView
        let addScrollView = UIScrollView(frame: CGRect(x:0,y:50,width: self.view.frame.width,height:self.view.frame.height - 285))
        addScrollView.backgroundColor = cGreen
        addScrollView.contentSize = CGSize(width: self.view.frame.width, height: 1000)
        let havinItemData = Model.findHavingItem(filter:nil)

        
        var i: Int = 1

        for havingItem in havinItemData {

            //******** positionを判定
            var positionX: CGFloat = 0
            var positionY: CGFloat = 0
            var rowNo: Int = 1
            
            //****　X軸 / Y軸
            if (i % 2 == 0) {
                //右
                positionX = self.view.frame.width/2 + 5
                rowNo = (i / 2)
            } else {
                //左
                positionX = 10
                rowNo = (i / 2) + 1
            }

            positionY = CGFloat(10 + (80 * (rowNo - 1)))
            
            
            
            let addHavingItemButton = UIButton(frame: CGRect(x: positionX,y: positionY,width: self.view.frame.width/2 - 15,height:70))
            addHavingItemButton.setTitle(havingItem.items?.name1, for: .normal)
            addHavingItemButton.backgroundColor = UIColor.white
            addHavingItemButton.setTitleColor(UIColor.black, for: .normal)
            addHavingItemButton.layer.borderWidth = 1
            addHavingItemButton.layer.borderColor = UIColor.black.cgColor
            addHavingItemButton.addTarget(self, action: #selector(ViewController.selectItem(_:)), for: .touchUpInside)
            addHavingItemButton.layer.cornerRadius = 10
            addScrollView.addSubview(addHavingItemButton)

            i = i + 1
        }
        
        view.addSubview(addScrollView)
        myScrollView = addScrollView

    }
    
    @objc func goNext(_ sender: UIButton) {// selectorで呼び出す場合Swift4からは「@objc」をつける。

        AddHavingItemView.view.backgroundColor = UIColor(hue: 0.1833, saturation: 0.13, brightness: 1, alpha: 1.0)
        self.present(AddHavingItemView, animated: true, completion: {
            () -> Void in
            print("HavingItem追加へ遷移後")
        })
    }

    @objc func receiptSearch(_ sender: UIButton) {

        self.delegate?.showList()
        ReceiptListItemView.view.backgroundColor = cRed2
        self.navigationController?.pushViewController(ReceiptListItemView, animated: true)

    
    }

    @objc func selectItem(_ sender: UIButton) {
        let itemName:String = (sender.titleLabel?.text)!
        
        //**** HavingItem update
        let havingItem:HavingItem? = Model.havingItemUpdate(itemName:itemName)

        //**** ボタンの背景を変更
        guard let havingItemUnwrap = havingItem else { return }
        
        if (havingItemUnwrap.selectFlg) {
            //選択状態
            let image = UIImage(named: "check_ok.png")
            let cgSize = CGSize(width:30, height:30)
            let resizeImage = image?.resize(size: cgSize)
            sender.setImage(resizeImage, for: .normal)
            
            sender.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            sender.imageEdgeInsets = UIEdgeInsetsMake(0.0, -30.0, 0, 0);
        
        } else {
            //非選択状態
            sender.setImage(nil, for: .normal)
        }
        
    }

    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag{
        case 1:
            //ホーム画面(持ってる食材リスト)
            print("１")
        case 2:
            //買物リスト
            print("２")
            ShoppingListView?.shoppingListData = Model.findShoppingList(filter: nil)
            ShoppingListView?.view.backgroundColor = cBlue2
            self.navigationController?.pushViewController(ShoppingListView!, animated: true)
            
        default : return
            
        }
    }

    func showHavingItem(){
        var havinItemData:Results<HavingItem>? = Model.findHavingItem(filter:nil)
    }

    func createUI() {
        //******** デフォルトのデータをロード
        defaultDataLoad()

        //******** タイトルラベル
        createLabelUI()

        //******** タブメニューを配置
        createTabUI()

        //******** Scroll View
        createScrollView()
        
    }
    
    
}



class TabBar: UITabBar {
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 70
        return size
    }
    
}


