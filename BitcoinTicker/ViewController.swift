//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Bilal on 2018-03-22.
//  Copyright © 2018 Bilal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var currencySelected = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    @IBOutlet weak var textField: UITextField!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        textField.text = "1"
        
       
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        finalURL = baseURL + currencyArray[row]
        currencySelected = currencySymbolArray[row]
        getBitcoinData(url:finalURL)

    }
    
    
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

//                    print("Sucess! Got the Bitcoin data")
                    let bitcoinJSON : JSON = JSON(response.result.value!)

                    self.updateBitcoinData(json: bitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitcoinData(json : JSON) {
        
        if let bitcoinResult = json["ask"].double  {
        
            if textField.text?.isInt == true {
                var resultWithMultiplier =  bitcoinResult * Double(textField.text!)!
                bitcoinPriceLabel.text = "\(currencySelected) \(resultWithMultiplier)"
            }else {
                
                let alert = UIAlertController(title: "Alert", message: "Please enter a Valid Number", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                textField.text = ""
            }
            
            
     
        }else {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
        
       
    }
    

 
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        
        if let textFieldCount = textField.text, textFieldCount.count >= 1 {
            getBitcoinData(url: finalURL)
        }
        
        
    }
    
    

}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

