//
//  Algorithm.swift
//  Cryptanalysis
//
//  Created by Kiryl Holubeu on 10/21/18.
//  Copyright © 2018 Kiryl Holubeu. All rights reserved.
//

import Foundation

extension String {
    subscript(i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
}

extension String {
    func get(indextOf c: Character) -> Int? {
        for i in 0..<self.count {
            if self[i] == c {
                return i
            }
        }
        return nil
    }
}

class Cryptoanalysis {
    
    var text: String
    var key: Int
    
    init(forText cryptotext: String, withKeyLenght keyLength: Int ) {
        self.text = cryptotext.uppercased().filter { return russianAlphabet.contains($0) }
        self.key = keyLength
    }
    
    func getFrequency() -> [[Character: Double]] {
        var result: [[Character: Double]] = []
        for i in 0..<key {
            var j = i
            var count = 0
            var dictionaryWithCount: [Character: Int] = [:]
            while j < text.count {
                let difference = russianAlphabet.get(indextOf: text[j])!
                let letter = (difference + russianAlphabet.count - (count % russianAlphabet.count)) % russianAlphabet.count
                if let temp = dictionaryWithCount[russianAlphabet[letter]] {
                    dictionaryWithCount.updateValue(temp+1, forKey: russianAlphabet[letter])
                } else {
                    dictionaryWithCount[russianAlphabet[letter]] = 1
                }
                count += 1
                j += key
            }
            var dictionaryWithPortion: [Character: Double] = [:]
            for letter in dictionaryWithCount {
                dictionaryWithPortion[letter.key] = Double(letter.value) / Double(count) * 100
            }
            result.append(dictionaryWithPortion)
        }
        return result
    }
        
    func getTable() -> String {
        let tableOfFrequencies = self.getFrequency()
        var result = ""
        for letter in 0..<key {
            result.append("For letter number \(letter) in key: \n")
            for dict in tableOfFrequencies[letter] {
                let value = String(format: "%.2f", dict.value)
                result.append("\(dict.key) - \(value) \n")
            }
            result.append("\n")
        }
        return result
    }
    
}
