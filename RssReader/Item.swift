//
//  Item.swift
//  RssReader
//
//  Created by sonicmoov on 2018/04/02.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import Foundation
import Ji
import SDWebImage

class Item {
    var title = ""
    var detail = ""
    var link = ""
    var imgUrl: URL?
    var jiDoc : Ji? = nil {
        didSet {
            if let img = jiDoc?.xPath("//img[@class='entry-image']")?.first {
                imgUrl = URL(string: img["src"]!)
            } else {
                imgUrl = nil
            }
        }
    }
}
