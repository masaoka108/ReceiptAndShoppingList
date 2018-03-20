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
}

class Item: Object {
    @objc dynamic var name1 = ""
    @objc dynamic var name2 = ""
    @objc dynamic var name3 = ""
    @objc dynamic var name4 = ""
    @objc dynamic var name5 = ""
    @objc dynamic var group = 0
    let root_receipt = LinkingObjects(fromType: Receipt.self, property: "items")
}

class HavingItem: Object {
//    @objc dynamic var user_id = ""
//    let items = List<Item>()
//    @objc dynamic var items = Item()
    @objc dynamic var items: Item? // optionals supported
    @objc dynamic var selectFlg = false
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

    class func findHavingItem(filter:String?) -> Results<HavingItem> {
        let ret: Results<HavingItem>
        
        if (filter == nil) {
            ret = realm.objects(HavingItem.self)
        } else {
            if let filterUnwrap = filter {
                ret = realm.objects(HavingItem.self).filter(filterUnwrap)
            } else {
                ret = realm.objects(HavingItem.self)
            }
        }
        
        return ret
    }
    
    class func saveHavingItem(itemName:String){

        //名前からItemを検索
        let ret = realm.objects(Item.self).filter("""
            name1 contains '\(itemName)' OR
            name2 contains '\(itemName)' OR
            name3 contains '\(itemName)' OR
            name4 contains '\(itemName)' OR
            name5 contains '\(itemName)'
            """
        )

        if (ret.count > 0) {

            for item in ret {
                let havingItem = HavingItem()
                //havingItem.items.append(item)
                havingItem.items = item

                try! realm.write {
                    realm.add(havingItem)
                }
            }
        } else {
            print("該当の食材がありませんでした。");
        }

        let results = realm.objects(HavingItem.self)
        print("Number of Item: \(results.count)")
    }

    class func saveHavingItem2(havingItem:HavingItem){
        
        try! realm.write {
            realm.add(havingItem)
        }
        
        let results = realm.objects(HavingItem.self)
        print("Number of Item: \(results.count)")
    }

    class func havingItemUpdate(itemName:String) -> HavingItem? {
        //名前からHavingItemを取得する
        let itemData = realm.objects(Item.self).filter("""
            name1 contains '\(itemName)'
            """
        ).first

        let havingItemData = realm.objects(HavingItem.self).filter("items = %@", itemData ?? Item())
        
        if let havingItem = havingItemData.first {
            try! realm.write {
                if (havingItem.selectFlg) {
                    havingItem.selectFlg = false
                } else {
                    havingItem.selectFlg = true
                }
            }
        } else {
            print("error")
        }

        let havingItem:HavingItem? = havingItemData.first
        
        //HavingItem をUpdate
        return havingItem
    }
    
    class func receiptFind(havingItemData:Results<HavingItem>?) -> Results<Receipt> {

//        var predicates: [NSPredicate] = []
//
//        for word in wordsArray {
//            predicates.append(NSPredicate(format: "search_word CONTAINS %@ OR name CONTAINS %@", word, word))
//        }

        var predicates: [NSPredicate] = []
        
        for havingItem in havingItemData! {
            predicates.append(NSPredicate(format: "ANY items.name1 = %@", (havingItem.items?.name1)!))
        }

        let compoundedPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)        
        let receiptData = realm.objects(Receipt.self).filter(compoundedPredicate)
        
        //HavingItem をUpdate
        return receiptData
    }
    
}
