//
//  OTPViewController.swift
//  AutoLayoutPractice2
//
//  Created by Jayaprakash on 29/07/23.
//

import UIKit

class OTPViewController: UIViewController {
    
    @IBOutlet weak var otpCollectionView: UICollectionView!
    @IBOutlet weak var displayMobileNumber: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    var mobileNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        otpCollectionView.dataSource = self
        otpCollectionView.delegate = self
        otpCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        continueButton.layer.cornerRadius = 20
        displayMobileNumber.text! += " \(mobileNumber)"
    }
    
    @IBAction func onClickBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func getEnteredOtp() -> String{
        
        var res = ""
        
        for item in self.otpCollectionView!.visibleCells as! [OTPCollectionViewCell] {
            var indexpath : IndexPath = self.otpCollectionView!.indexPath(for: item as OTPCollectionViewCell)!
            var cell : OTPCollectionViewCell = self.otpCollectionView!.cellForItem(at: indexpath) as! OTPCollectionViewCell
            res += cell.otpTextField.text!
        }
        
        return res
    }
    
    @IBAction func onClickContinueButton(_ sender: Any) {
        let url = URL(string: "https://dev-wearables.titan.in/api/register/otp")
        
        var request = URLRequest(url: url!)
        
        request.allHTTPHeaderFields = [
            "titan-context-group-code": "FASTRACK",
            "Context-Type": "application/json"
        ]
        
        let obj = ["mobile": "+91" + mobileNumber,    "otp": getEnteredOtp()]
        
        print(obj)
        
        do {
            let encodedData = try JSONEncoder().encode(obj)
            request.httpMethod = "POST"
            request.httpBody = encodedData
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                print("one")
                if let response = response as? HTTPURLResponse {
                    print(response.statusCode)
                    print(response.value(forHTTPHeaderField: "access-token"))
                    if let data = data {
                        print(data)
                    }
                }
                
            }.resume()
        }
        catch {
            print("error decoding")
        }
        
    }
    
}

extension OTPViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OTPCollectionViewCell
        
        cell.layer.cornerRadius = 20
        
        return cell
    }
    
    
}

extension OTPViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let width = self.view.frame.width/4 - 3*flowLayout.minimumInteritemSpacing
        
        return CGSize(width: width, height: width)
    }
}
