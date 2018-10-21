//
//  Cryptoanalysis.swift
//  Cryptanalysis
//
//  Created by Kiryl Holubeu on 10/21/18.
//  Copyright © 2018 Kiryl Holubeu. All rights reserved.
//

import Cocoa

class CryptoanalysisVC: ViewController {

    @IBOutlet weak var keyLength: NSTextField!
    @IBOutlet weak var cryptotextField: NSTextField!
    @IBOutlet weak var statisticTable: NSTableView!
    var cryptotextInRussian = ""
    var keySize = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func inputCorrect() -> Bool {
        cryptotextInRussian = cryptotextField.stringValue.uppercased().filter { return russianAlphabet.contains($0) }
        guard cryptotextInRussian.count > 0 else  {
            dialogError(question: "Error!", text: "Text does not contain russian letters!")
            return false
        }
        
        guard (Int(keyLength.stringValue) != nil) && (Int(keyLength.stringValue)! > 0) else {
            dialogError(question: "Error!", text: "Key length is incorrect")
            return false
        }
        keySize = Int(keyLength.stringValue)!
        
        return true
    }
    
    @IBAction func proceedCryptotext(_ sender: Any) {
        guard inputCorrect() else {
            return
        }
        
        
    }
    
    
    
    
    @IBAction func loadCryptotext(_ sender: Any) {
        cryptotextField.stringValue = openFile()
    }

}
