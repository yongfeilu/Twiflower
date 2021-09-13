//
//  ReviewService.swift
//  finalproj

//  Created by 卢勇霏 on 3/17/21.
//

import Foundation
import StoreKit

//  ReviewService: The class is built to control the process of
//  requesting App Store ratings and reviews from users.
class ReviewService {
    
    private init() {}
    
    static let shared = ReviewService()
    
    // requestReview(): invoke the UIAlertView to request reviews of the app from users
    func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
