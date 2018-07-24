//
//  NewsViewController.swift
//  NYS Challenge App
//
//  Created by Fikri Karadereli on 23.07.2018.
//  Copyright © 2018 Fikri Karadereli. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // Constants
    let NEWS_URL = "https://api.hurriyet.com.tr/v1/articles?$top=10"
    let API_KEY = "bfd3ae89089d4ab09965d7e1d0d2d67f"
    
    
    // Variables
    var dataSource = [News]()
    
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.navigationItem.rightBarButtonItem = nil

        tableView.delegate = self
        tableView.dataSource = self
        
        getNewsData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getNewsData() {
        
        let headers: [String: String] = ["apikey" : API_KEY]
        
        Alamofire.request(NEWS_URL, method: .get, headers: headers).responseJSON { response in
            
            if response.result.isSuccess {
                
                let newsJSON: JSON = JSON(response.result.value!)
                self.updateNewsData(json: newsJSON)
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateNewsData(json: JSON) {
        
        for item in json {
            let news = News()
            news.title = item.1["Title"].stringValue
            news.detail = item.1["Description"].stringValue
            news.imageUrlString = item.1["Files"][0]["FileUrl"].stringValue
            dataSource.append(news)
        }
        
        tableView.reloadData()
    }
    
    
    
    //MARK: - Table View Data Source Methods
    /***************************************************************/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        
            cell.newsTitleLabel.text = dataSource[indexPath.row].title
            cell.newsDetailTextView.text = dataSource[indexPath.row].detail

            let url = URL(string: dataSource[indexPath.row].imageUrlString)
            cell.newsImageView.kf.setImage(with: url)
        
        return cell
    }
    
    
    
    //MARK: - Table View Delegate Methods
    /***************************************************************/
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
