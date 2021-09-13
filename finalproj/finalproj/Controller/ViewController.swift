//
//  ViewController.swift
//  finalproj
//
//  Created by 卢勇霏 on 3/3/21.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON
import SDWebImage
import SafariServices


let reachability = try! Reachability()
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let wikipediaURL = "https://en.wikipedia.org/w/api.php"
    let imagePicker = UIImagePickerController()
    var wikipediaInfoURL: String?
    let reviewService = ReviewService.shared
    
  
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        spinner.hidesWhenStopped = true
        spinner.color = .red
       
        imageView.image = UIImage(named: "Cover")
        reviewService.requestReview()
        
        checkInternetConnection()
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        spinner.startAnimating()
        self.imagePicker.view.addSubview(spinner)
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            guard let convertedCIImage = CIImage(image: userPickedImage) else {
                fatalError("Cannot convert to CIImage.")
            }
            
            detect(image: convertedCIImage)
            imageView.image = userPickedImage
        }
 
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
   
        guard let mlModel = try? FlowerClassifier(configuration: .init()).model,
              let model = try? VNCoreMLModel(for: mlModel) else {
            fatalError("Cannot import model")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let classification = request.results?.first as? VNClassificationObservation else {
                fatalError("Could not classify image.")
            }
            self.navigationItem.title = classification.identifier.capitalized
            self.requestInfo(flowerName: classification.identifier)
        }
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
        spinner.stopAnimating()
    }
    //requestInfo(flowerName:): Get data from wikipedia API based on flowerName
    func requestInfo(flowerName: String) {
        print("Fetching data from wikipedia API \(wikipediaURL)...")
        let parameters : [String:String] = [
        "format" : "json",
        "action" : "query",
        "prop" : "extracts|pageimages",
        "exintro" : "",
        "explaintext" : "",
        "titles" : flowerName,
        "indexpageids" : "",
        "redirects" : "1",
        "pithumbsize": "500"
        ]
        Alamofire.request(wikipediaURL, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("Got the wikipedia info.")
                let flowerJSON: JSON = JSON(response.result.value!)
                let pageid = flowerJSON["query"]["pageids"][0].stringValue
                self.wikipediaInfoURL = "https://en.wikipedia.org/?curid=" + pageid
                let flowerDescription = flowerJSON["query"]["pages"][pageid]["extract"].stringValue
                let flowerImageURL = flowerJSON["query"]["pages"][pageid]["thumbnail"]["source"].stringValue
                if flowerImageURL != "" {
                    self.imageView.sd_setImage(with: URL(string: flowerImageURL))
                }
                self.descriptionTextView.text = flowerDescription
            }
        }
    }
    //checkInternetConnection():check Internet connection of the app. It will show alert if there is no Internet connection
    func checkInternetConnection() {
        reachability.whenReachable = {reachability in
            if reachability.connection == .wifi {
                print("Reachable via wifi")
            } else {
                print("Reachable via cellular")
            }
        }
        reachability.whenUnreachable = {_ in
            print("Not reachable")
            self.showAlert()
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("unable to start notifier")
        }
    }
    //showAlert(): show alert of no Internet connection
    func showAlert() {
        let alert = UIAlertController(title: "No Internet", message: "This App Requires wifi/internet connection!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        print("camera button pressed...")
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func safariButtonTapped(_ sender: UIBarButtonItem) {
        if let wikipediaInfoUrl = self.wikipediaInfoURL {
            print("safari button pressed, going to \(String(describing: wikipediaInfoURL))")
            if let url = URL(string: wikipediaInfoUrl) {
                let safariViewController = SFSafariViewController(url: url)
                present(safariViewController, animated: true, completion: nil)
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

