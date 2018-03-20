//
//  ReceiptListViewController.swift
//  Receipt_and_shopping_list
//
//  Created by USER on 2018/03/20.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit
import RealmSwift

class ReceiptListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ReceiptListControllerDelegate {

    func showList() {
       print("showList")

        //******** 表示データを取得
        //**** HavingItemを取得
        let filterStr: String? = "selectFlg == true"
        havinItemData = Model.findHavingItem(filter:filterStr)
        
        //**** Receiptを取得
        receiptData = Model.receiptFind(havingItemData:havinItemData)
        print("receipt count" + String(receiptData!.count))

//        for receipt in receiptData! {
//            print("receipt_name" + receipt.receipt_name)
//        }

        if (myTableView != nil) {
            myTableView.reloadData()
        }
        
    }
    
    
    private let myArray: NSArray = ["First","Second","Third","Four","Five"]
    private var myTableView: UITableView!
    let titleName: String
    let TableViewCellIdentifier:String = "CELL"
    var havinItemData:Results<HavingItem>?
    var receiptData:Results<Receipt>?

    var rootViewCon:ViewController? = nil

    
    
    init(titleName: String) {
        self.titleName = titleName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
//        super.viewDidLoad()
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        //Table View 表示
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
        
//        //delegate
//        self.rootViewCon?.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(myArray[indexPath.row])")
    }
    
    //何行分 作成するか？
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        
        if (receiptData != nil) {
            rowCount = receiptData!.count
        }
        
        return rowCount
    }
    
    //各行の内容を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath) as! CustomTableViewCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell


        let cellData:Receipt = receiptData![indexPath.row]
        let image = UIImage(named: cellData.photo)
        let cgSize = CGSize(width:200, height:200)
        let resizeImage = image?.resize(size: cgSize)

        let cell = CustomTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "myIdentifier")
        cell.name.text = cellData.receipt_name
        cell.button.setImage(resizeImage, for: UIControlState.normal)
        
        return cell
    }

    //RowHeightを設定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 200.0;//Choose your custom row height
    }
}



class CustomTableViewCell: UITableViewCell {
    
//    var myLabel1: UILabel!
//    var myLabel2: UILabel!
//    var myButton1 : UIButton!
//    var myButton2 : UIButton!

    var img: UIImage!
    var button: UIButton!
    var name: UILabel!

    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        let gap : CGFloat = 10
//        let labelHeight: CGFloat = 30
//        let labelWidth: CGFloat = 150
//        let lineGap : CGFloat = 5
//        let label2Y : CGFloat = gap + labelHeight + lineGap
//        let imageSize : CGFloat = 30
//
//        myLabel1 = UILabel()
//        myLabel1.frame = CGRect(x: gap, y: gap, width: labelWidth, height: labelHeight)
//        myLabel1.textColor = UIColor.black
//        contentView.addSubview(myLabel1)
//
//        myLabel2 = UILabel()
//        myLabel2.frame = CGRect(x: gap, y: label2Y, width: labelWidth, height: labelHeight)
//        myLabel2.textColor = UIColor.black
//        contentView.addSubview(myLabel2)
//
//        myButton1 = UIButton()
//        myButton1.frame = CGRect(x: bounds.width-imageSize - gap, y: gap, width: imageSize, height: imageSize)
//        myButton1.setImage(UIImage(named: "browser.png"), for: UIControlState.normal)
//        contentView.addSubview(myButton1)
//
//        myButton2 = UIButton()
//        myButton2.frame = CGRect(x: bounds.width-imageSize - gap, y: label2Y, width: imageSize, height: imageSize)
//        myButton2.setImage(UIImage(named: "telephone.png"), for: UIControlState.normal)
//        contentView.addSubview(myButton2)
     
        
//        img = UIImage()
//        img.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
//        contentView.addSubview(img)

        button = UIButton()
        button.frame = CGRect(x:0 ,y:0, width: 200, height: 200)
//        button.setImage(UIImage(named: "telephone.png"), for: UIControlState.normal)
        contentView.addSubview(button)

        
        name = UILabel()
        name.frame = CGRect(x: 250, y: 50, width: 150, height: 50)
        name.textColor = UIColor.black
        contentView.addSubview(name)
    }
    
}
