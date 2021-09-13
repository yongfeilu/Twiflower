## Twiflower
### Author: Yongfei Lu
### Date: March 18th, 2021



### Summary:
	Twiflower uses AI to recognize flowers around and help you gain knowledge of the flowers from Wikipedia. Moreover, it can conduct a sentiment analysis on the most recent tweets concerning the keywords user provides. It helps users know what people are thinking of the issues recently.



### Key Features:
	Twiflower uses AI to recognize flowers around and help you gain knowledge of the flowers from Wikipedia. Moreover, it can conduct a sentiment analysis on the most recent tweets concerning the keywords user provides. It helps users know what people are thinking of the issues recently.
	
### Technical Details:
	1. The flower recognition part recognizes the flower photos taken by the users by applying the flower classifier machine learning model, then uses the result (flower name) to fetch relevant information from the wikipedia pages. It also provides a window for users to see more information via going through the safari browser.
	
	2. The tweet sentiment analysis part fetches the most recent 100 tweets concerning the keywords provided by the users through Twitter standard APIs, then conduct sentiment analysis on these tweets via the NLP model trained before, and finally delivered a emotional score as the result.


### Third-Party Framework:
	In this app, we use Cocoapods to incorporate Alamofire, SwiftyJSON, and SwifteriOS to deal with the data we fetch from the APIs. Alamofire helps request and organize the data we get from the the Wikipedia API：https://en.wikipedia.org/w/api.php, SwiftyJSON helps parse JSON data from the APIs we use,) SDWebImage helps load images from the APIs, and SwifteriOS helps work with Twitter standard APIs (searching and filtering tweets according to our demands). We also use Reachability
	to keep track of the Internet connection, which is required to use the app.

### Consulted Resousces:
	1. UIActivityIndicator: https://www.youtube.com/watch?v=FIXU6d370K8
	2. UIAlertView: https://www.youtube.com/watch?v=kMK8m2P4Cec
				    https://www.youtube.com/watch?v=tPPRmB_EZkY
	3. iOS Locking Orientations - Portrait or Landscape: https://www.youtube.com/watch?v=BL9pVPiBy8I
					https://stackoverflow.com/questions/37168888/ios-9-warning-all-interface-orientations-must-be-supported-unless-the-app-req
	4. 'requestReview()' was deprecated in iOS 14.0:
					https://stackoverflow.com/questions/63953891/requestreview-was-deprecated-in-ios-14-0/63954318
	5. UserDefaults: https://developer.apple.com/documentation/foundation/userdefaults
	6. Reachablity: https://github.com/ashleymills/Reachability.swift
	7. Checking WiFi connection: https://github.com/jeary1988/Checking-WiFi-connection
	8. How to Create Launch Screen / Image in Swift 5 and Xcode 11: https://www.youtube.com/watch?v=FdiqRol8weU






