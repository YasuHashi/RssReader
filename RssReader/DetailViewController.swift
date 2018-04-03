//
//  DetailViewController.swift
//  RssReader
//
//  Created by sonicmoov on 2018/04/03.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import Foundation

import UIKit
import WebKit

class DetailViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var item: Item?
    
    // loadView()が完了した際に呼ばれるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let i = item else {
            return
        }
        
        if let url = URL(string: i.link) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
