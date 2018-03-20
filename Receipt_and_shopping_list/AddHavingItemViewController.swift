//
//  AddHavingItemController.swift
//  Receipt_and_shopping_list
//
//  Created by USER on 2018/03/17.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import UIKit

protocol ViewControllerDelegate
{
    // デリゲート関数を定義
    func reloadScrollView()
}

class AddHavingItemViewController: UIViewController, UITextFieldDelegate {
    
    var nameTextField: UITextField?
    var delegate: ViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //******** UIを配置
        createUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func addHavingItem(_ sender: UIButton) {
        guard let itemName = nameTextField?.text else {
            fatalError("名前が入力されていません。")
        }
        
         Model.saveHavingItem(itemName:itemName);
        
        //**** Alert表示
        let alert: UIAlertController = UIAlertController(title: "完了メッセージ", message: "材料の登録が完了しました。", preferredStyle:  UIAlertControllerStyle.alert)
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ）
            (action: UIAlertAction!) -> Void in
            print("OK")

//            ViewController.viewDidLoad(ViewController)

            self.dismiss(animated: true, completion: {
                () -> Void in
                print("画面遷移後")
                
                if let dg = self.delegate {
                    dg.reloadScrollView()
                } else {
                    print("delegate 未設定")
                }
            })
            
        })
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    func createUI() {

        //「名前」ラベル
        let nameLabel = UILabel(frame: CGRect(x: 30,y: self.view.frame.height/2 - 150,width: self.view.frame.width - 20,height:40))
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.text = "名前"
        nameLabel.textAlignment = NSTextAlignment.left
        view.addSubview(nameLabel)
        
        //「名前」テキスト
        let nameText =  UITextField(frame: CGRect(x: 30, y: self.view.frame.height/2 - 110 , width: self.view.frame.width - 60, height: 70))
        nameText.placeholder = "食材を入力して下さい"
        nameText.font = UIFont.systemFont(ofSize: 15)
        nameText.borderStyle = UITextBorderStyle.roundedRect
        nameText.autocorrectionType = UITextAutocorrectionType.no
        nameText.keyboardType = UIKeyboardType.default
        nameText.returnKeyType = UIReturnKeyType.done
        nameText.clearButtonMode = UITextFieldViewMode.whileEditing;
        nameText.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        nameText.delegate = self
        self.view.addSubview(nameText)
        nameTextField = nameText
        
        //「追加」ボタン
        let addButton = UIButton(frame: CGRect(x: 10,y: self.view.frame.height - 75,width: self.view.frame.width - 20,height:70))
        addButton.setTitle("追加", for: .normal)
        addButton.backgroundColor = cRed
        addButton.addTarget(self, action: #selector(AddHavingItemViewController.addHavingItem(_:)), for: .touchUpInside)
        addButton.layer.cornerRadius = 10
        view.addSubview(addButton)
        
        //「キャンセル」ボタン
        let backButton = UIButton(frame: CGRect(x: 10,y: self.view.frame.height - 150,width: self.view.frame.width - 20,height:70))
        backButton.setTitle("キャンセル", for: .normal)
        backButton.backgroundColor = UIColor.lightGray
        backButton.addTarget(self, action: #selector(AddHavingItemViewController.back(_:)), for: .touchUpInside)
        backButton.layer.cornerRadius = 10
        view.addSubview(backButton)

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        nameTextField?.resignFirstResponder()
        return true;
    }
    
}
