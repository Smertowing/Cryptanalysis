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
    func indexDistanceOfFirst(character: Character) -> Int? {
        guard let index = self.firstIndex(of: character) else { return nil }
        return self.distance(from: self.startIndex, to: index)
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
                text.remove(at: text.index(text.startIndex, offsetBy: j))
                text.insert(russianAlphabet[letter], at: text.index(text.startIndex, offsetBy: j))
                
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
    
    func getMostAccuracyChar(for portion: Double) -> Character {
        var diff:Double = 100
        var char: Character = " "
        for i in russianAlphabetFrequency {
            if (abs(portion - i.value) < diff) {
                diff = abs(portion - i.value)
                char = i.key
            }
        }
        return char
    }
    
    func getOffset(forTable table: [[Character: Double]]) -> [Int] {
        var result = [Int]()
        for numKey in table {
            var max: Double = 0
            var maxsymb: Character = "А"
            for char in numKey {
                if char.value > max {
                    max = char.value
                    maxsymb = char.key
                }
            }
            let tempChar = getMostAccuracyChar(for: max)
            result.append((russianAlphabet.indexDistanceOfFirst(character: tempChar)! - russianAlphabet.indexDistanceOfFirst(character: maxsymb)! + russianAlphabet.count) % russianAlphabet.count)
        }
        return result
    }
    
    func getSymbol(_ char: Character, withOffset offset: Int) -> Character{
        return russianAlphabet[(russianAlphabet.indexDistanceOfFirst(character: char)! + offset) % russianAlphabet.count]
    }
    
    func getTableParallel(table: [[Character: Double]]) -> [[Character: Character]] {
        let offsets: [Int] = getOffset(forTable: table)
        
        var parallel: [[Character: Character]] = []
        for i in 0..<key {
            var dictionaryOfMatching: [Character: Character] = [:]
            for dict in table[i] {
                dictionaryOfMatching[dict.key] = getSymbol(dict.key, withOffset: offsets[i])
            }
            parallel.append(dictionaryOfMatching)
        }
        return parallel
    }
    
    func decodeText(table: [[Character: Character]]) -> String {
        var messageText = text
        for i in 0..<key {
            var j = i
            while j < messageText.count {
                if let tempChar = table[i][messageText[j]] {
                    messageText.remove(at: messageText.index(messageText.startIndex, offsetBy: j))
                    messageText.insert(tempChar, at: messageText.index(messageText.startIndex, offsetBy: j))
                }
                j += key
            }
        }
        return messageText
    }
        
    func getTable() -> String {
        let tableOfFrequencies = self.getFrequency()
        var proceededString = ""
        for letter in 0..<key {
            proceededString.append("For letter number \(letter+1) in key: \n")
            for dict in tableOfFrequencies[letter] {
                let value = String(format: "%.2f", dict.value)
                proceededString.append("\(dict.key) - \(value) \n")
            }
            proceededString.append("\n")
        }
        let table = getTableParallel(table: tableOfFrequencies)
        
        proceededString.append("\nCryptotext without progressive part: \n")
        proceededString.append(text)
        proceededString.append("\n\nMost likely text is: \n")
        proceededString.append(decodeText(table: table))
        return proceededString
    }
    
}
