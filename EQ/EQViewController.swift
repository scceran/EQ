//
//  EQViewController.swift
//  EQ
//
//  Created by Can Ceran on 10/01/16.
//  Copyright © 2016 Ceran. All rights reserved.
//

import UIKit

class EQViewController: UIViewController {
    
    // MARK: PROPOERTIES
    
    let yellowColor = UIColor(red: CGFloat(254.0/255.0), green: CGFloat(199.0/255.0), blue: CGFloat(75.0/255.0), alpha: 1.0)
    var currentEmoji: String?
    var currentQuestion = 1 {
        didSet {
            questionNumberLabel.text = "\(self.currentQuestion) / \(self.brain.quizLength)"
        }
    }
    
    @IBOutlet weak var questionNumberLabel: UILabel! {
        didSet {
            if self.currentQuestion <= self.brain.quizLength {
                questionNumberLabel.text = "\(self.currentQuestion) / \(self.brain.quizLength)"
            }
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel! {
        didSet {
            scoreLabel.text = "0%"
        }
    }
    @IBOutlet weak var emojiLabel: UILabel!
    
    @IBOutlet var optionButtonLabels: [UIButton]!
    
    var brain = EQBrain()
    
    // MARK: ACTIONS
    
    @IBAction func nextButton(sender: UIButton) {
        updateEmoji()
        if currentQuestion == brain.quizLength {
            brain.saveScore()
            performSegueWithIdentifier("EndQuizSegue", sender: self)
        } else {
            currentQuestion++
        }
    }

    @IBAction func option0Button(sender: UIButton) {
        checkOption(sender)
    }
    @IBAction func option1Button(sender: UIButton) {
        checkOption(sender)
    }
    @IBAction func option2Button(sender: UIButton) {
        checkOption(sender)
    }
    @IBAction func option3Button(sender: UIButton) {
        checkOption(sender)
    }
    
    private func checkOption(sender: UIButton) {
        if let optionDescription = sender.currentTitle, let emoji = currentEmoji, let currentEmojiDescription = emojiDictionary[emoji] {
            if brain.checkOption(currentEmojiDescription, option: optionDescription) {
                sender.backgroundColor = UIColor.greenColor()
                questionNumberLabel.text = "Correct"
            } else {
                questionNumberLabel.text = "Wrong"
                sender.backgroundColor = UIColor.redColor()
            }
            for button in optionButtonLabels {
                button.enabled = false
            }
            scoreLabel.text = "\(brain.score)%"
        }
    }
    
    private func updateEmoji() {
        if let emoji = brain.pickTheNextEmoji() {
            currentEmoji = emoji
            emojiLabel.text = emoji
            if let optionsArray = brain.createOptionSetWith(emoji) {
                for i in 0..<optionsArray.count {
                    optionButtonLabels[i].setTitle(optionsArray[i], forState: .Normal)
                }
            }
            for button in optionButtonLabels {
                button.enabled = true
                button.backgroundColor = UIColor.clearColor()
            }
            
        }
    }
    
    // MARK: VC LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        updateEmoji()
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
