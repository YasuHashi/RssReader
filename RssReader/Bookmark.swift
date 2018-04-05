//
//  Bookmark.swift
//  RssReader
//
//  Created by sonicmoov on 2018/04/03.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import Foundation

import RealmSwift

class Bookmark: Object {
    @objc dynamic var title = ""
    @objc dynamic var detail = ""
    @objc dynamic var link = ""
    @objc dynamic var date: NSDate? = nil
    @objc dynamic var bookmarkIndex = 0
}
