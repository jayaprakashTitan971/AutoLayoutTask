//
//  ViewController.swift
//  AutoLayoutPractice2
//
//  Created by Jayaprakash on 20/07/23.
//

import UIKit


//struct User:Codable {
//    var name: String
//    var mobile: Int
//    var imageUrl:String
//
//    enum CodingKeys:String,CodingKey {
//        case name
//        case imageUrl = "image"
//    }
//}

class ViewController: UIViewController {

    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var numberUIView: UIView!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var textLabel: UITextView!
    @IBOutlet weak var iconImageView2: UIImageView!
    
    let applicationId = Int.random(in: 1000000...10000000)
    
    var constraints = [NSLayoutConstraint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        numberTextField.delegate = self
        numberTextField.keyboardType = .asciiCapableNumberPad
        
        iconView.layer.cornerRadius = 40
        numberUIView.layer.cornerRadius = 20
        numberTextField.borderStyle = .none
        continueButton.layer.cornerRadius = 15
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.removeKeyboardAndConstraints))
        view.addGestureRecognizer(tap)
        
        print("Hello World")
    }
    
    @objc private func removeKeyboardAndConstraints() {
        print("Hello")
        self.view.endEditing(true)
        NSLayoutConstraint.deactivate(constraints)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.iconView.backgroundColor = UIColor(hexString: "#93DCA7")
            self.view.layoutIfNeeded()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        if let otpViewController = segue.destination as? OTPViewController {
            otpViewController.mobileNumber = numberTextField.text!
        }
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        let url = URL(string: "https://dev-wearables.titan.in/api/registry/users/mobiles")
        
        var request = URLRequest(url: url!)
        request.allHTTPHeaderFields = [
            "titan-version": "1.3",
            "titan-context-group-code": "FASTRACK",
            "Content-Type": "application/json"
        ]
        
        
        let obj = [ "mobile": "+91"+numberTextField.text!, "appId": "\(applicationId)"]
        
        do {
            let encodedData = try JSONEncoder().encode(obj)
            request.httpMethod = "POST"
            request.httpBody = encodedData
            print("two")
            
            URLSession.shared.dataTask(with: request) {(data, response, error) in
                
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 || response.statusCode == 201 {
                        
                    }
                    else if let error = error {
                        print(error)
                        let alert = UIAlertController(title: "Alert", message: "OTP Failed", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                
                print("three")
                
            }.resume()
        }
        catch {
            print("data encoding failed")
        }
        
        performSegue(withIdentifier: "otpSegue", sender: self)
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    private func addConstraints() {
        print("addConstraints")
        numberUIView.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        
        constraints.append(NSLayoutConstraint(item: numberUIView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 0.4, constant: 0))

        constraints.append(NSLayoutConstraint(item: continueButton, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 0.65, constant: 0))

        constraints.append(NSLayoutConstraint(item: textLabel, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 0.23, constant: 0))
        
        
        constraints.append(iconView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -self.view.frame.height/3))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //textField.becomeFirstResponder()
        print("textFieldDidBeginEditing")
        
        addConstraints()
       
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.iconView.backgroundColor = nil
            self.view.layoutIfNeeded()
        })
        
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

