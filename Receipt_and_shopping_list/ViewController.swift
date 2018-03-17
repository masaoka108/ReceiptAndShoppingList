//
//  ViewController.swift
//  Receipt_and_shopping_list
//
//  Created by USER on 2018/03/17.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit
import RealmSwift

//import Model

//class Dog: Object {
//    @objc dynamic var name = ""
//    @objc dynamic var age = 0
//}
//
//class Person: Object {
//    @objc dynamic var name = ""
//    let dogs = List<Dog>()
//}



class ViewController: UIViewController, UITabBarDelegate {

    private var myTabBar:TabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //******** デフォルトのデータをロード
        defaultDataLoad()

        //******** タブメニューを作成
        createTabUI()
        


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
        receipt1.photo = "fried_rice"
        receipt1.items.append(item1)
        receipt1.items.append(item2)
        receipt1.items.append(item3)
        Model.saveReceipt(receipt:receipt1);
        
        
        let receipt2 = Receipt()
        receipt2.receipt_name = "豚バラ大根"
        receipt2.detail = "お肉と野菜のコンボ！"
        receipt2.photo = "pork_radish"
        receipt2.items.append(item2)
        receipt2.items.append(item4)
        Model.saveReceipt(receipt:receipt2);
        
        
        let receipt3 = Receipt()
        receipt3.receipt_name = "豚キムチ"
        receipt3.detail = "辛いのマニアに！"
        receipt3.photo = "pork_korean_pickles"
        receipt3.items.append(item5)
        Model.saveReceipt(receipt:receipt3);
    }
    
    func createTabUI() {
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        //デフォルトは49
        let tabBarHeight:CGFloat = 70
        
        /**   TabBarを設置   **/
        myTabBar = TabBar()
        myTabBar.frame = CGRect(x:0,y:height - tabBarHeight,width:width,height:tabBarHeight)
        //バーの色
        myTabBar.barTintColor = UIColor.black
        //選択されていないボタンの色
        myTabBar.unselectedItemTintColor = UIColor.white
        //ボタンを押した時の色
        myTabBar.tintColor = UIColor(hue: 0.5778, saturation: 0.44, brightness: 0.93, alpha: 1.0)
        
        //ボタンを生成
        let mostRecent:UITabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        let downloads:UITabBarItem = UITabBarItem(tabBarSystemItem: .featured , tag: 2)

        //ボタンをタブバーに配置する
        myTabBar.items = [mostRecent,downloads]
        //デリゲートを設定する
        myTabBar.delegate = self
        
        self.view.addSubview(myTabBar)
 
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag{
        case 1:
            print("１")
        case 2:
            print("２")
//        case 3:
//            print("３")
//        case 4:
//            print("４")
//        case 5:
//            print("５")
        default : return
            
        }
    }


}



class TabBar: UITabBar {
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 70
        return size
    }
    
}
