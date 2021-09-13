//
//  Tweet.swift
//  finalproj
//
//  Created by 卢勇霏 on 3/7/21.
//

import Foundation

// Tweet struct is built to fetch data from APIs and
// helps to store data in this object.
struct Tweet {
    
    let userImageUrlString: String?
    let userName: String?
    let createdAt: String?
    let fullText: String?
    let emotion: String?
    
    // init(): used to initialize and create a Tweet struct
    init(userImageUrlString: String?, userName: String?, createdAt: String?, fullText: String?, emotion: String?){
        self.userImageUrlString = userImageUrlString
        self.userName = userName
        self.createdAt = createdAt
        self.fullText = fullText!
        self.emotion = emotion
    }
    
}
