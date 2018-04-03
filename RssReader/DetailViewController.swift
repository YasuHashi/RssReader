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
import RealmSwift

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
    
    // ブックマークボタンを押した時に呼ばれるメソッド
    @IBAction func addBookmark(_ sender: Any) {
        
        //　コントローラーの実装
        let alert = UIAlertController(title:"確認", message: "ブックマークに追加しますか？",preferredStyle: UIAlertControllerStyle.alert)
        //　ボタンの実装
        let  okAction = UIAlertAction(title: "OK", style:UIAlertActionStyle.default) {
            (action: UIAlertAction) in
            
            // クリックされた時の処理
            guard let i = self.item else {
                return
            }
            
            let bookmark = Bookmark()
            bookmark.title = i.title
            bookmark.detail = i.detail
            bookmark.link = i.link
            bookmark.date = NSDate()
            
            let realm = try! Realm()
            try! realm.write {
                realm.add(bookmark)
            }
        }
        
        // CANCELボタンの実装
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
        //　ボタンの追加
        alert.addAction(cancelButton)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}

