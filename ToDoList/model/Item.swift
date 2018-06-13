//
//  Item.swift
//  ToDoList
//
//  Created by Zhengyang Duan on 2018-06-13.
//  Copyright © 2018 Zhengyang Duan. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
