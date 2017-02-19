//
//  ViewController.swift
//  PicPals
//
//  Created by Fulton Garcia on 2/18/17.
//  Copyright © 2017 Fulton Garcia. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import Cosmos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var rating: UILabel!
    @IBOutlet var cosmos: CosmosView!
    @IBOutlet var Pic: UIImageView!
    @IBAction func btnClick(_ sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false;
        
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            Pic.image = image
            let data = UIImagePNGRepresentation(image)!
            let name = "\(Int(arc4random_uniform(1000000) + 1))"
            let sendUser = GlobalVariables.sharedManager.myName.data(using: .utf8)!
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(data, withName: "image", fileName: "\(name).png", mimeType: "image/png")
                multipartFormData.append(sendUser, withName: "username")
                }, to:"https://pic-pals.herokuapp.com/upload")
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseString{ result in
                        
                        
                        if let data = result.data, let responseString = String(data: data, encoding: .utf8){
                            
                            let values = ["username": responseString]
                            let url = URL(string: "https://pic-pals.herokuapp.com/sendPic")!
                            var request = URLRequest(url: url)
                            request.httpMethod = "POST"
                            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                            
                            request.httpBody = try! JSONSerialization.data(withJSONObject: values)
                            
                            Alamofire.request(request).responseImage { response in
                                let image = response.result.value
                                print("Picture: \(image)")
                                let alertController = UIAlertController(title: "New Picture!", message: "View Recieved Picture?", preferredStyle: .alert)
                                
                                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                                    print("Not Viewing")
                                }
                                alertController.addAction(cancelAction)
                                
                                let OKAction = UIAlertAction(title: "View", style: .default) { (action:UIAlertAction!) in
                                    self.Pic.image = image
                                    self.cosmos.isHidden = false
                                    self.cosmos.didFinishTouchingCosmos = { rating in
                                    self.rating.isHidden = false
                                    self.cosmos.settings.updateOnTouch = false
                                    }
                                    
                                }
                                alertController.addAction(OKAction)
                                
                                self.present(alertController, animated: true, completion:nil)
                                
                                
                            }

                            
                        }
                        
                        
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
                
            }
        
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Pic.layer.borderWidth = 2
        Pic.layer.masksToBounds = true
        cosmos.rating = 0
        cosmos.settings.fillMode = .half
        cosmos.isHidden = true
        rating.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
