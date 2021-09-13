//
//  TweetDetailViewController.swift
//  finalproj
//
//  Created by 卢勇霏 on 3/7/21.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userAvatarImage: UIImageView!
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var tweetTextField: UITextView!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tweet = self.tweet {
            updateDetailView(with: tweet)
        }
        
    }
//   updateDetailView(with tweet:): update the labels and image of the TweetDetailViewController
    func updateDetailView(with tweet: Tweet?) {
        self.userNameLabel.text = tweet?.userName
        self.dateLabel.text = tweet?.createdAt
        self.emotionLabel.text = tweet?.emotion
        self.tweetTextField.text = tweet?.fullText!
        
        if let imageUrl = tweet?.userImageUrlString {
            let url = URL(string: imageUrl)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    self.userAvatarImage.image = UIImage(data: data!)
                }
            }
        }
    }
    override var shouldAutorotate: Bool{
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
