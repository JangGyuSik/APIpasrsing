//
//  BookListTableViewController.swift
//  book
//
//  Created by D7702_10 on 2017. 10. 31..
//  Copyright © 2017년 D7702_10. All rights reserved.
//

import UIKit

class BookListTableViewController: UITableViewController, XMLParserDelegate, UISearchBarDelegate {

    @IBOutlet weak var search: UISearchBar!
    
    var item:[String:String] = [:]
    var items:[[String:String]] = []
    var key:String = ""
    let apikey = "12e019b25265e571f9c178f4d9e4540d" //key
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search.delegate = self
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(query: search.text!, pageno: self.page)
    }
    
    func search(query:String, pageno:Int){
    let str = "https:apis.daum.net/search/book?apikey=\(apikey)&output=xml&q=\(query)&result=20" as NSString //key주소
    
    let strURL = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    //한글을 %로 인코딩
    
    //파싱
    //옵셔널일 경우 if 사용
    if let strURL = strURL {
        if let url = URL(string: strURL){
            if let parser = XMLParser(contentsOf: url){
                parser.delegate = self
                let success =  parser.parse()
                if success {
                    print("success")
                    tableView.reloadData() // 데이터 넣기
                    print(items)
                } else {
                    print("fall")
                }
            }
        }
    }
}

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "itme" {
            item = [:]
        } else {
            key = elementName //
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        item[key] = string // key 와 vlaue 를 딕셔너리에 넣음
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            items.append(item) //item 을 만났을경우 배열에 딕셔너리 저장
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let book = items[indexPath.row]
        
        cell.textLabel?.text = book["title"]
        return cell
    }

}
