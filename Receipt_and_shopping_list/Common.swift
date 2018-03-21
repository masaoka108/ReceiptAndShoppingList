//
//  Common.swift
//  Receipt_and_shopping_list
//
//  Created by USER on 2018/03/17.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit

let cRed = UIColor(hue: 0, saturation: 0.31, brightness: 0.92, alpha: 1.0)
let cRed2 = UIColor(hue: 0.9972, saturation: 0.13, brightness: 1, alpha: 1.0)
let cYellow = UIColor(hue: 0.1833, saturation: 0.13, brightness: 1, alpha: 1.0)
let cBlue = UIColor(hue: 0.5778, saturation: 0.44, brightness: 0.93, alpha: 1.0)
let cBlue2 = UIColor(hue: 0.5611, saturation: 0.17, brightness: 0.98, alpha: 1.0)
let cGreen = UIColor(hue: 0.3694, saturation: 0.16, brightness: 0.99, alpha: 1.0)

//********* ViewController
var RootView:ViewController?
let AddHavingItemView:AddHavingItemViewController = AddHavingItemViewController()
let ReceiptListItemView:ReceiptListViewController = ReceiptListViewController(titleName: "second")
let ReceiptDetailView: ReceiptDetailViewController? = ReceiptDetailViewController(titleName: "second")
var ShoppingListView:ShoppingListViewController? = ShoppingListViewController(titleName: "second")

func createUITab(width:CGFloat, height:CGFloat) ->UITabBar {

    var myTabBar:TabBar!
    
    let width = width
    let height = height
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
    myTabBar.tintColor = cBlue

    //ボタンを生成
    let mostRecent:UITabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
    let downloads:UITabBarItem = UITabBarItem(tabBarSystemItem: .featured , tag: 2)

    //ボタンをタブバーに配置する
    myTabBar.items = [mostRecent,downloads]
    
    return myTabBar
}
