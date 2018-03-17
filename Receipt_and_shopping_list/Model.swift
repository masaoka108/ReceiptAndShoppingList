//
//  Common.swift
//  Receipt_and_shopping_list
//
//  Created by USER on 2018/03/17.
//  Copyright © 2018年 Hiliberate. All rights reserved.
//

import Foundation
import RealmSwift

class Receipt: Object {
    @objc dynamic var receipt_name = ""
    @objc dynamic var detail = ""
    @objc dynamic var photo = ""
    let items = List<Item>()
    //    let dogs = List<Dog>()
}

class Item: Object {
    @objc dynamic var name1 = ""
    @objc dynamic var name2 = ""
    @objc dynamic var name3 = ""
    @objc dynamic var name4 = ""
    @objc dynamic var name5 = ""
    @objc dynamic var group = 0
    let root_receipt = LinkingObjects(fromType: Receipt.self, property: "items")
    //    let dogs = List<Dog>()
}

let realm = try! Realm() // Create realm pointing to default file


class Model: NSObject {

//    override init() {
//        // perform some initialization here
//        do {
//            try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
//        } catch {}
//    }
    
    class func saveItem(item:Item){

        try! realm.write {
            realm.add(item)
        }

        let results = realm.objects(Item.self)
        print("Number of Item: \(results.count)")
    }

    class func saveReceipt(receipt:Receipt){
        
        try! realm.write {
            realm.add(receipt)
        }
        
        let results = realm.objects(Receipt.self)
        print("Number of Receipt: \(results.count)")
    }

    
}
