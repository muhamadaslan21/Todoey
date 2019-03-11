//
//  Category.swift
//  Todoey
//
//  Created by Muhamad Aslan on 10/03/19.
//  Copyright © 2019 Muh Aslan. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
