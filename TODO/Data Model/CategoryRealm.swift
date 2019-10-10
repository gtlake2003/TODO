//
//  CategoryRealm.swift
//  TODO
//
//  Created by 姚佳雯 on 2019/10/8.
//  Copyright © 2019年 ywd. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryRealm: Object {
    @objc dynamic var name: String = ""
    
    let items = List<ItemRealm>()
}
