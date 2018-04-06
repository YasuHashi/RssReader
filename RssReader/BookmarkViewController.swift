//
//  BookmarkViewController.swift
//  RssReader
//
//  Created by sonicmoov on 2018/04/03.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import Foundation

import UIKit
import RealmSwift

class BookmarkViewController: UITableViewController {
    
    var bookmarks: Results<Bookmark>?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let realm = try! Realm()

        bookmarks = realm.objects(Bookmark.self).sorted(byKeyPath: "bookmarkIndex", ascending: true)

        tableView.reloadData()
        
        // ナビゲーションバーの右側に編集ボタンを追加.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) ->Int {
        return bookmarks?.count ?? 0
    }
    
    //　ブックマークデータの出力処理　　bookmarksに入れた順で表示
    override func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkViewCell", for: indexPath)
        guard let bm = bookmarks?[indexPath.row] else {
            return cell
        }
        cell.textLabel?.text = bm.title
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            guard let bm = bookmarks?[indexPath.row] else {
                return
            }
        let item = Item()
        item.link = bm.link
        item.title = bm.title
        item.detail = bm.detail
        
        let controller = segue.destination as! DetailViewController
        controller.item = item
        }
    }
    
    //Cellを挿入または削除しようとした際に呼び出される
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // 削除のとき.
        if editingStyle == UITableViewCellEditingStyle.delete {
            let realm = try! Realm()
                
            // トランザクションを開始してオブジェクトを削除します
            try! realm.write {
                realm.delete(bookmarks![indexPath.row])
            }
            
            tableView.reloadData()
        }
    }
    @IBAction func AllDelete(_ sender: Any) {
        //　コントローラーの実装
        let alert = UIAlertController(title:"確認", message: "全て削除しますか？",preferredStyle: UIAlertControllerStyle.alert)
        //　ボタンの実装
        let  okAction = UIAlertAction(title: "OK", style:UIAlertActionStyle.default) {
            (action: UIAlertAction) in
            
            let realm = try! Realm()
            try! realm.write {
            realm.deleteAll()
            }
        }
            let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
        
        //　ボタンの追加
        alert.addAction(cancelButton)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }

}
