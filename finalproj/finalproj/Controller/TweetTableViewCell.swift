//
//  TweetTableViewCell.swift
//  finalproj
//
//  Created by 卢勇霏 on 3/7/21.
//

import UIKit

//MARK:  - UITableViewCell
class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emotionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
   //setCell(with tweet:):  update the image and labels of each table cell
    func setCell(with tweet: Tweet?) {
        self.userNameLabel.text = tweet?.userName
        self.emotionLabel.text = tweet?.emotion
        if let imageUrl = tweet?.userImageUrlString {
            let url = URL(string: imageUrl)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    self.userProfileImage.image = UIImage(data: data!)
                }
            }
        }
    }
}
