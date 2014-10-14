//
//  ViewController.swift
//  SwiftNewsReaderSample
//

import UIKit

/**
*  ニュース記事を表示するビューのController
*/
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView = UITableView()
    /// 記事データを格納する配列
    var entries = [AnyObject]()
    
    /**
    ビュー読み込み完了
    */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // テーブルビューのセットアップ
        self.tableView.frame = self.view.frame
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        
        // 記事のダウンロード
        download()
    }
    
    /**
    ニュース記事をダウンロードします
    */
    func download() {
        
        let url = NSURL(string: "https://api.myjson.com/bins/4dx6g")
        let req = NSURLRequest(URL: url)
        
        let q = NSOperationQueue.mainQueue()
        NSURLConnection.sendAsynchronousRequest(req, queue: q) { (resp:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            
            let json:NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            self.entries = json["data"] as NSArray
            self.tableView.reloadData()
        }
    }
    
    /**
    テーブルに表示するセルの数を返します
    
    :param: tableView tableView
    :param: section   section
    
    :returns: return セル数
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entries.count
    }
    
    /**
    セルの高さを指定します
    
    :param: tableView tableView
    :param: indexPath indexPath
    
    :returns: 100(固定)
    */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    /**
    引数で指定された行数目のセルを生成・返却します
    
    :param: tableView tableView
    :param: indexPath indexPath
    
    :returns: セル
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // テーブル行に対応する記事を配列から取り出す
        let entryData:NSDictionary! = self.entries[indexPath.row] as NSDictionary
        
        // タイトルをセット
        var cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "FeedCell")
        cell.textLabel?.text = entryData["title"] as String
        cell.textLabel?.font = UIFont.systemFontOfSize(14.0)
        cell.textLabel?.numberOfLines = 0
        
        // 画像セット
        let url = NSURL(string: entryData["picture"] as String)
        let original = UIImage(data: NSData(contentsOfURL: url))
        cell.imageView?.image = original.resizeForSize(CGSizeMake(100, 100))
        
        return cell
    }
}

/**
*  UIImage拡張
*/
extension UIImage {
    
    /**
    画像サイズを変更します
    
    :param: size 変更したいサイズ
    
    :returns: リサイズ後のUIImage
    */
    func resizeForSize(size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(size);
        self.drawInRect(CGRectMake(0, 0, size.width, size.height))
        var newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        
        UIGraphicsEndImageContext();
        
        return newImage
    }
}

