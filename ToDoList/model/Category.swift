//
//  Category.swift
//  ToDoList
//
//  Created by Zhengyang Duan on 2018-06-13.
//  Copyright © 2018 Zhengyang Duan. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
