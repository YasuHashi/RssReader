//
//  ListViewController.swift
//  RssReader
//
//  Created by sonicmoov on 2018/04/02.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import Foundation

import UIKit

class ListViewController: UITableViewController {
    
    var xml:ListViewXmlParser?
    
    // Viewの表示が完了後に呼び出されるメソッド
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // XML解析
        xml = ListViewXmlParser()
        xml?.parse(url: Setting.RssUrl, completionHandler: { () -> () in
            self.tableView.reloadData()
        })
    }
    
    // セルの個数を指定する
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xml?.items.count ?? 0
    }
    
    // セルに値を設定する
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell", for: indexPath) as? ListViewCell else {
            fatalError("Invalid cell")
        }
        
        guard let x = xml else {
            return cell
        }
        
        cell.item = x.items[indexPath.row]
        
        return cell
    }
    
    //一覧からWebView画面へ行く時に呼び出されるメソッド
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let x = xml else {
            return
        }
        
        //　選択した項目情報をWebView画面に渡す
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let controller = segue.destination as! DetailViewController
            controller.item = x.items[indexPath.row]
        }
    }
}

// リストビューのセルクラス
class ListViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var item: Item? {
        didSet {
            titleLabel.text = item?.title
            descriptionLabel.text = item?.detail
        }
    }
}

// XML解析クラス
class ListViewXmlParser: NSObject, XMLParserDelegate {
    
    var item: Item?
    var items = [Item]()
    var currentString = ""
    var completionHandler: (() -> ())?
    
    /// 指定のURLからXMLを解析する
    ///
    /// - Parameters:
    ///   - url: 解析するURLを指定
    ///   - completionHandler: 解析完了時に呼び出されるメソッドを指定
    func parse(url: String, completionHandler: @escaping () -> ()) {
        guard let url = URL(string: url) else {
            return
        }
        guard let xml_parser = XMLParser(contentsOf: url) else {
            return
        }
        
        items = []
        self.completionHandler = completionHandler
        xml_parser.delegate = self
        xml_parser.parse()
    }
    
    // 解析中に要素の開始タグがあったときに呼び出されるメソッド
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentString = ""
        if elementName == "item" {
            item = Item()
        }
    }
    
    // 開始タグと終了タグでくくられたデータがあったときに呼び出されるメソッド
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentString += string
    }
    
    // 解析中に要素の終了タグがあったときに呼び出されるメソッド
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        guard let i = item else {
            return
        }
        
        switch elementName {
        case "title": i.title = currentString
        case "description": i.detail = currentString
        case "link": i.link = currentString
        case "item": items.append(i)
        default: break
        }
    }
    
    // 解析終了時に呼び出されるメソッド
    func parserDidEndDocument(_ parser: XMLParser) {
        completionHandler?()
    }
}


