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
    @IBOutlet var cryptotextView: NSTextView!
    @IBOutlet weak var cryptotextField: NSTextField!
    @IBOutlet weak var statisticTable: NSTableView!
    
    var cryptotextInRussian = ""
    var keySize = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statisticTable.delegate = self
        statisticTable.dataSource = self
        statisticTable.reloadData()
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
        let crypto = Cryptoanalysis(forText: cryptotextInRussian, withKeyLenght: keySize)
        cryptotextView.string = crypto.getTable()
    }
    
    @IBAction func loadCryptotext(_ sender: Any) {
        cryptotextField.stringValue = openFile()
    }
    
}

extension CryptoanalysisVC: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return russianAlphabet.count
    }
    
}

extension CryptoanalysisVC: NSTableViewDelegate{

    fileprivate enum CellIdentifiers {
        static let LetterCell = "LetterCellID"
        static let FrequencyCell = "FrequencyCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        guard let item = russianAlphabetFrequency[russianAlphabet[row]] else {
            return nil
        }
        if tableColumn == tableView.tableColumns[0] {
            text = String(russianAlphabet[row])
            cellIdentifier = CellIdentifiers.LetterCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = String(item)
            cellIdentifier = CellIdentifiers.FrequencyCell
        }
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
    
}
