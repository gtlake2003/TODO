//
//  ItemRealm.swift
//  TODO
//
//  Created by 姚佳雯 on 2019/10/8.
//  Copyright © 2019年 ywd. All rights reserved.
//

import Foundation
import RealmSwift

class ItemRealm: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: CategoryRealm.self, property: "items")
}
