//
//  Login.swift
//  PicPals
//
//  Created by Daniel Canas on 2/18/17.
//  Copyright © 2017 Fulton Garcia. All rights reserved.
//

import UIKit
import Alamofire

class Login: UIViewController {

    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var label: UILabel!
    
    
    @IBAction func login(_ sender: Any) {
    
        let username = self.user.text
        let password = self.pass.text
        let values = ["username": username!, "password": password!]
        let url = URL(string: "https://pic-pals.herokuapp.com/login")!
    
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: values)
        
        Alamofire.request(request).responseString{ response in
            
            print(response.request)
            print(response.response)
            print(response.data)
                    
            if let data = response.data, let responseString = String(data: data, encoding: .utf8){
                    print("This is responseString: \(responseString)")
                    if(responseString == "true"){
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        
                        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "mainMenu") as! ViewController
                        
                        self.present(resultViewController, animated:true, completion:nil)
                        }
                    else{
                        self.label.isHidden = false
                    }
                
            }
            
            
        }
        
        
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
