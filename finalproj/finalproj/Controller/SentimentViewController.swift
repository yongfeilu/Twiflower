//
//  SentimentViewController.swift
//  finalproj
//
//  Created by 卢勇霏 on 3/3/21.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

//https://github.com/mattdonnelly/Swifter

//MARK:  - SentimentViewController: UIViewController
class SentimentViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var keyWordLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let tweetCount = 100
    let sentimentClassifier = try! TweetSentimentClassifier(configuration: MLModelConfiguration.init())
    let swifter = Swifter(consumerKey: "t8JHzPiYhRS5AfzCf1YgWzWKp", consumerSecret: "8he49so3M6RfB8IlWl9DxVZlJLHUHIf1gLXA5hmugtC8UCPBAp")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        spinner.hidesWhenStopped = true
    }
    
    // fetchTweets(): fetch tweets from Tweeter standard API and conduct emotional
    // analysis on the tweets
    func fetchTweets() {
        spinner.startAnimating()
        if let searchText = searchTextField.text {
            keyWordLabel.text = searchText
            swifter.searchTweet(using: searchText, lang: "en", count: tweetCount, tweetMode: .extended) { (results, metadata) in
                print("Using SwifteriOS to fetch data from Tweeter standard API...")
                var tweets = [TweetSentimentClassifierInput]()
                
                var tweetsForManager = [Tweet]()
                for i in 0..<self.tweetCount {
                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                        let prediction = try! self.sentimentClassifier.prediction(text: tweet)
                        let tweetToAppend = Tweet(userImageUrlString: results[i]["user"]["profile_image_url_https"].string, userName: results[i]["user"]["name"].string, createdAt: results[i]["created_at"].string ?? "", fullText: tweet, emotion: prediction.label)
                        tweetsForManager.append(tweetToAppend)
                    }
                }
                DataManager.sharedInstance.tweets = tweetsForManager
                self.makePrediction(with: tweets)
            } failure: { (error) in
                print("There was an error with the Twitter API Request, \(error)")
            }
        }
    }
    
    // makePrediction(with tweets:): make emotional predictions on the tweets fetched from the API
    // and update the UI with emoji and sentiment scores.
    func makePrediction(with tweets: [TweetSentimentClassifierInput]) {
        do {
            let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
            var sentimentScore = 0
            for pred in predictions {
                let sentiment = pred.label
                if sentiment == "Pos" {
                    sentimentScore += 1
                } else if sentiment == "Neg" {
                    sentimentScore = sentimentScore - 1
                }
            }
            updateUI(with: sentimentScore)
        } catch {
            print("There was an error with making a prediction, \(error)")
        }
    }
    
    // updateUI(with sentimentScore:): updates the UI based on the result
    // of sentiment analysis
    func updateUI(with sentimentScore: Int) {
        
        scoreLabel.text = String(sentimentScore)
        if sentimentScore > 20 {
            self.sentimentLabel.text = "😍"
        } else if sentimentScore > 10 {
            self.sentimentLabel.text = "😄"
        } else if sentimentScore > 0 {
            self.sentimentLabel.text = "😊"
        } else if sentimentScore == 0 {
            self.sentimentLabel.text = "😑"
        } else if sentimentScore > -10 {
            self.sentimentLabel.text = "😕"
        } else if sentimentScore > -20 {
            self.sentimentLabel.text = "💢"
        } else {
            self.sentimentLabel.text = "🤮"
        }
        spinner.stopAnimating()
    }
    
    
    @IBAction func predictPressed(_ sender: Any) {
        print("Search button pressed: starting to fetch tweets and conduct sentiment analysis...")
        searchTextField.endEditing(true)
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

//MARK:  - UITextFieldDelegate
extension SentimentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let word = searchTextField.text {
            fetchTweets()
            searchTextField.text = word
        }
    }
}
