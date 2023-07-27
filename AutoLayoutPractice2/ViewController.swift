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

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var numberUIView: UIView!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var textLabel: UITextView!
    @IBOutlet weak var iconImageView2: UIImageView!
    
    var constraints = [NSLayoutConstraint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        numberTextField.delegate = self
        numberTextField.keyboardType = .asciiCapableNumberPad
        
        iconView.layer.cornerRadius = 40
        numberUIView.layer.cornerRadius = 20
        numberTextField.borderStyle = .none
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.removeKeyboardAndConstraints))
        view.addGestureRecognizer(tap)
        
        print("Hello World")
    }
    
    @objc private func removeKeyboardAndConstraints() {
        print("Hello")
        self.view.endEditing(true)
        NSLayoutConstraint.deactivate(constraints)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.iconView.backgroundColor = UIColor(hex: "#010101")
            self.view.layoutIfNeeded()
        })
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
            self.iconView.backgroundColor = UIColor(hex: "#808080")
            self.view.layoutIfNeeded()
        })
        
    }
}

