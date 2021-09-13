//
//  DataManager.swift
//  finalproj
//
//  Created by 卢勇霏 on 3/7/21.
//

import Foundation
// DataManager class is used to help keep track of the tweets
// fetched from the Tweeter API, which are accessible through
// the application
public class DataManager {
    
    var tweets: [Tweet]
    
    public static let sharedInstance = DataManager()
    
    // init(): DataManager initializer/ construtor
    fileprivate init() {
        self.tweets = []
    }
    
}
