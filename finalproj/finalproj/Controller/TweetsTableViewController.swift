//
//  TweetsTableViewController.swift
//  finalproj
//
//  Created by 卢勇霏 on 3/7/21.
//

import UIKit

class TweetsTableViewController: UITableViewController {

    
    var tweets: [Tweet]?
    var delegate: TweetViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tweets = DataManager.sharedInstance.tweets
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tweets?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTableViewCell
        cell.setCell(with: self.tweets?[indexPath.row])
        return cell
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! TweetDetailViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            detailVC.tweet = tweets?[indexPath.row]
        }
    }
   

}

//MARK:  - TweetViewDelegate
protocol TweetViewDelegate {
    func setTweets()
}
