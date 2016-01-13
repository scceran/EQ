//
//  EQBrain.swift
//  EQ
//
//  Created by Can Ceran on 10/01/16.
//  Copyright © 2016 Ceran. All rights reserved.
//

import Foundation

class EQBrain {
    
    // MARK: PROPERTIES
    var quizSet = [String]()
    let quizLength: Int = 3
    var rawScore: Int = 0
    var score: Double {
        get {
            let percentScore = Double(rawScore) * 100 / Double(quizLength)
            return Double(round(percentScore * 10) / 10)
        }
    }
    
    // MARK: ACTIONS
    
    private func createQuiz () {
        var emojiUniverse = emojiCodes
        for _ in 0..<quizLength {
            // pick a random index
            let index = Int(arc4random_uniform(UInt32(emojiUniverse.count)))
            let randomEmoji = emojiUniverse.removeAtIndex(index)
            quizSet.append(randomEmoji)
        }
    }
    
    func pickTheNextEmoji () -> String? {
        if quizSet.count > 0 {
            let emoji = quizSet.removeFirst()
            return emoji
        } else {
            return nil
        }
    }
    
    func createOptionSetWith (emojiCode: String) -> [String]? {
        var optionSet = [String]()
        if let correctOption = emojiDictionary[emojiCode] {
            optionSet.append(correctOption)
        }
        var emojiUniverse = emojiCodes
        var i = 0
        while (i < 3) {
            let index = Int(arc4random_uniform(UInt32(emojiUniverse.count)))
            let randomEmojiCode = emojiUniverse.removeAtIndex(index)
            if emojiCode != randomEmojiCode {
                if let emojiDescription = emojiDictionary[randomEmojiCode] {
                    optionSet.append(emojiDescription)
                    i++
                }
            }
        }
        if optionSet.count == 4 {
            return optionSet.sort()
        } else {
            return nil
        }
    }
    
    func checkOption (emoji: String, option: String) -> Bool {
        if emoji == option {
            rawScore += 1
            return true
        } else {
            return false
        }
    }
    
    func saveScore() {
        // Save the score to User Defaults in percentage form with 1 decimal point
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(score, forKey: "Last Score")
        
        // Update the highest score if the last score is exceeding the previous one
        if let highestScore = defaults.objectForKey("Highest Score") as? Double {
            if score > highestScore {
                defaults.setObject(score, forKey: "Highest Score")
            }
        }
        defaults.synchronize()
    }
    
    
    
    // MARK: INIT
    
    init () {
        // Initialize the class here
        createQuiz()
    }
    
}


