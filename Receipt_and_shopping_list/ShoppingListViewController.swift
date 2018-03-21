//
//  ShoppingListViewController.swift
//  Receipt_and_shopping_list
//
//  Created by USER on 2018/03/21.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit
import RealmSwift

class ShoppingListViewController: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource, ShoppingListViewControllerDelegate {

    func showShoppingList(data: Results<ShoppingList>?) {
        print("showShoppingList")
        print(data?.count ?? 0 as Any)
        
        shoppingListData = data
        
        //******** 画面描画
        createUI()

        //******** 選択済みItemを初期化
        selectItems = List<Item>()

    }
    

    private var myTabBar:TabBar!
    private var myTableView: UITableView!
    let titleName: String
//    var rootViewCon:ReceiptDetailViewController? = nil
    var shoppingListData:Results<ShoppingList>?
    var selectItems = List<Item>()

    //delegate
    var rootView: ReceiptDetailViewController? = nil
    
    init(titleName: String) {
        self.titleName = titleName
        super.init(nibName: nil, bundle: nil)
        
        self.navigationItem.title = "買物リスト"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        //        super.viewDidLoad()
        
        //******** 画面描画
        createUI()

        //******** 選択済みItemを初期化
        selectItems = List<Item>()

    }


    func createUI() {
        //**** UITab
        myTabBar = createUITab(width:self.view.frame.width, height:self.view.frame.height) as! TabBar
        myTabBar.delegate = self    //デリゲートを設定する
        self.view.addSubview(myTabBar)
        
        //**** TableView
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight + 50, width: displayWidth, height: displayHeight - barHeight - 210))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.backgroundColor = cBlue2
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
        
        
        //**** UIButton
        //「チェックを削除」ボタン
        let allCheckButton = UIButton(frame: CGRect(x: 10,y: self.view.frame.height - 150,width: self.view.frame.width/2 - 10,height:70))
        allCheckButton.setTitle("チェックを削除", for: .normal)
        allCheckButton.backgroundColor = cRed
        allCheckButton.addTarget(self, action: #selector(ShoppingListViewController.itemDelete(_:)), for: .touchUpInside)
        allCheckButton.layer.cornerRadius = 10
        view.addSubview(allCheckButton)
        
        //「全て削除」ボタン
        let addShoppingListButton = UIButton(frame: CGRect(x: self.view.frame.width/2 + 10,y: self.view.frame.height - 150,width: self.view.frame.width/2 - 20,height:70))
        addShoppingListButton.setTitle("全て削除", for: .normal)
        addShoppingListButton.backgroundColor = UIColor.lightGray
        addShoppingListButton.setTitleColor(UIColor.white, for: .normal)
        addShoppingListButton.addTarget(self, action: #selector(ShoppingListViewController.itemDeleteAll(_:)), for: .touchUpInside)
        addShoppingListButton.layer.cornerRadius = 10
        view.addSubview(addShoppingListButton)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        //        print("Value: \(myArray[indexPath.row])")
    }
    
    //何行分 作成するか？
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount: Int = 0
        
        if (shoppingListData != nil) {
            rowCount = (shoppingListData?.count)!
        }

        return rowCount
    }
    
    //各行の内容を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let shoppingList: ShoppingList = shoppingListData![indexPath.row]
        let cellData:Item = shoppingList.item!
        
        let cell = ReceiptDetailTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "myIdentifier")
        cell.backgroundColor = cBlue2
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


    @objc func itemDelete(_ sender: UIButton) {
        
        //******** ShoppingListを削除
        for item in selectItems {
            var predicates: [NSPredicate] = []
            predicates.append(NSPredicate(format: "item = %@", item))
            let compoundedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            let shoppingListData = Model.findShoppingList(filter: compoundedPredicate)
            let shoppingListOne = shoppingListData?.first
            
            Model.delShoppingList(shoppingList:shoppingListOne!)
        }
        
        //******** 画面リロード
        let data = Model.findShoppingList(filter: nil)
        showShoppingList(data:data)
    }

    @objc func itemDeleteAll(_ sender: UIButton) {
        
        //******** ShoppingListを削除
        for shoppingList in shoppingListData! {
            Model.delShoppingList(shoppingList:shoppingList)
        }
        
        //******** 画面リロード
        let data = Model.findShoppingList(filter: nil)
        showShoppingList(data:data)
    }

    
    @objc func selectItem(_ sender: UIButton) {
        //let itemName:String = (sender.titleLabel?.text)!
        
        //******** selectItemsに選択したItemを保持
        //**** indexPathを取得
        let point = myTableView.convert(sender.frame.origin, from: sender.superview)
        if let indexPath = myTableView.indexPathForRow(at: point) {
            print("section: \(indexPath.section) - row: \(indexPath.row)")
        }
        
        let itemData:Item = (shoppingListData![myTableView.indexPathForRow(at: point)!.row].item)!
        
        //******** ボタンの背景を変更
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
            self.navigationController?.popToRootViewController(animated: true)
        case 2:
            //買物リスト
            print("２")
            ShoppingListView?.shoppingListData = Model.findShoppingList(filter: nil)
            ShoppingListView?.view.backgroundColor = cBlue2
            //self.navigationController?.pushViewController(ShoppingListView!, animated: true, completion: nil)
        default : return
            
        }
    }

    
}

