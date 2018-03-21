//
//  ReceiptDetailViewController.swift
//  Receipt_and_shopping_list
//
//  Created by USER on 2018/03/21.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit
import RealmSwift

protocol ShoppingListViewControllerDelegate
{
    func showShoppingList(data:Results<ShoppingList>?)
}

class ReceiptDetailViewController: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource, ReceiptDetailViewControllerDelegate {

    func createReceiptDetailView(data:Receipt) {
        print("createReceiptDetailView")
        
        receiptData = data
        
        //******** 画面描画
        createUI(data:data)

        //******** 選択済みItemを初期化
        selectItems = List<Item>()
    }
    
    private var myTabBar:TabBar!
    private var myTableView: UITableView!
    let titleName: String
    var rootViewCon:ReceiptListViewController? = nil
    var receiptData: Receipt? = nil
    var screenWidth: Int?
    var screenHeight: Int?
    var selectItems = List<Item>()

    //Delegateを定義
    var delegate: ShoppingListViewControllerDelegate?
    

    init(titleName: String) {
        self.titleName = titleName
        super.init(nibName: nil, bundle: nil)
        
//        screenWidth = Int(self.view.frame.width)
//        screenHeight = Int(self.view.frame.height)
        
        ShoppingListView?.rootView = self
        self.delegate = ShoppingListView
        
        self.navigationItem.title = "レシピ詳細"

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        //        super.viewDidLoad()
    }
    
    func createUI(data:Receipt) {
        //**** UITab
        myTabBar = createUITab(width:self.view.frame.width, height:self.view.frame.height) as! TabBar
        
        //デリゲートを設定する
        myTabBar.delegate = self
        
        self.view.addSubview(myTabBar)

        
        //**** UIImage
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        let image = UIImage(named: (receiptData?.photo)!)
        let cgSize = CGSize(width:180, height:180)
        let resizeImage = image?.resize(size: cgSize)
        
        let imageView = UIImageView(image:resizeImage)
        imageView.frame = CGRect(x:displayWidth/2 - 200, y:barHeight + 40, width: 200, height:200)
        imageView.center.x = self.view.center.x
        
        self.view.addSubview(imageView)
        
        //**** TableView
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight + 250, width: displayWidth, height: displayHeight - barHeight - 140 - 240))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.backgroundColor = cYellow
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)

        
        //**** UIButton
        //「全てチェックする」ボタン
        let allCheckButton = UIButton(frame: CGRect(x: 10,y: self.view.frame.height - 150,width: self.view.frame.width/2 - 10,height:70))

        allCheckButton.setTitle("全てチェックする", for: .normal)
        allCheckButton.backgroundColor = cBlue
        allCheckButton.addTarget(self, action: #selector(ViewController.goNext(_:)), for: .touchUpInside)
        allCheckButton.layer.cornerRadius = 10
        view.addSubview(allCheckButton)
        
        //「チェックを買物リストに追加」ボタン
        let addShoppingListButton = UIButton(frame: CGRect(x: self.view.frame.width/2 + 10,y: self.view.frame.height - 150,width: self.view.frame.width/2 - 20,height:70))

        addShoppingListButton.setTitle("チェックを買物リストに追加", for: .normal)
        addShoppingListButton.backgroundColor = cRed
        addShoppingListButton.setTitleColor(UIColor.white, for: .normal)
        addShoppingListButton.addTarget(self, action: #selector(ReceiptDetailViewController.addShoppingList(_:)), for: .touchUpInside)
        addShoppingListButton.layer.cornerRadius = 10
        view.addSubview(addShoppingListButton)

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        //        print("Value: \(myArray[indexPath.row])")
    }
    
    //何行分 作成するか？
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = receiptData?.items.count
        
        return rowCount!
    }
    
    //各行の内容を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData:Item = (receiptData?.items[indexPath.row])!

        let cell = ReceiptDetailTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "myIdentifier")
        cell.backgroundColor = cYellow
        cell.button.frame = CGRect(x:20 ,y:0, width: self.view.frame.width - 40, height: 50)
        cell.button.setTitle(cellData.name1, for: .normal)
        cell.button.tag = 0
        cell.button.addTarget(self, action: #selector(ReceiptDetailViewController.selectItem(_:)), for: .touchUpInside)
        
        return cell
    }
    
    //RowHeightを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0;//Choose your custom row height
    }
    
    @objc func addShoppingList(_ sender: UIButton) {
        print("addShoppingList")

        //******** selectItems を ShoppingList　に追加(すでに存在するものは追加しない。)
        for item in selectItems {
            var predicates: [NSPredicate] = []
            predicates.append(NSPredicate(format: "item = %@", item))
            let compoundedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            let data = Model.findShoppingList(filter:compoundedPredicate)
        
            if (data == nil || data?.count == 0) {
                //**** ShoppingList へ追加
                let shoppingList:ShoppingList = ShoppingList()
                shoppingList.item = item
                Model.saveShoppingList(shoppingList: shoppingList)
            }
            
        }
        
        //******** ShoppingList を取得
        let shoppingListdata: Results<ShoppingList>? = Model.findShoppingList(filter:nil)
        
        //ページ遷移
//        let receiptDataSelect:Receipt = receiptData![indexPath.row]
//        let data: Results<ShoppingList>? = nil
        
        self.delegate?.showShoppingList(data: shoppingListdata)
        ShoppingListView?.view.backgroundColor = cBlue2
        self.navigationController?.pushViewController(ShoppingListView!, animated: true)
    }
    
    @objc func selectItem(_ sender: UIButton) {
        //let itemName:String = (sender.titleLabel?.text)!
        
        //******** selectItemsに選択したItemを保持
        //**** indexPathを取得
        let point = myTableView.convert(sender.frame.origin, from: sender.superview)
        if let indexPath = myTableView.indexPathForRow(at: point) {
            print("section: \(indexPath.section) - row: \(indexPath.row)")
        }

        let itemData:Item = (receiptData?.items[myTableView.indexPathForRow(at: point)!.row])!
        
        //**** ボタンの背景を変更
//        guard let havingItemUnwrap = havingItem else { return }

        if (sender.tag == 0) {
            //選択状態にする
            let image = UIImage(named: "check_ok.png")
            let cgSize = CGSize(width:30, height:30)
            let resizeImage = image?.resize(size: cgSize)
            sender.setImage(resizeImage, for: .normal)

            sender.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            sender.imageEdgeInsets = UIEdgeInsetsMake(0.0, -30.0, 0, 0);

            sender.tag = 1

            if (selectItems.index(of: itemData) != nil) {
                //存在している
            } else {
                //存在していない
                selectItems.append(itemData)
            }

        } else {
            //非選択状態にする
            sender.setImage(nil, for: .normal)

            sender.tag = 0
            
            if (selectItems.index(of: itemData) != nil) {
                //存在している
                selectItems.remove(at: selectItems.index(of: itemData)!)
            } else {
                //存在していない
            }
        }
        
    }

    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag{
        case 1:
            //ホーム画面(持ってる食材リスト)
            print("１")
//            self.navigationController?.pushViewController(RootView!, animated: true)
            self.navigationController?.popToRootViewController(animated: true)
        case 2:
            //買物リスト
            print("２")
            ShoppingListView?.shoppingListData = Model.findShoppingList(filter: nil)
            ShoppingListView?.view.backgroundColor = cBlue2
            self.navigationController?.pushViewController(ShoppingListView!, animated: true)
        default : return
            
        }
    }
}

class ReceiptDetailTableViewCell: UITableViewCell {
    
    var img: UIImage!
    var button: UIButton!
//    var name: UILabel!
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        button = UIButton()
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10
        contentView.addSubview(button)
        
        
//        name = UILabel()
//        name.frame = CGRect(x: 250, y: 50, width: 150, height: 50)
//        name.textColor = UIColor.black
//        contentView.addSubview(name)
    }
}
