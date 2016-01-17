//
//  EndViewController.swift
//  EQ
//
//  Created by Can Ceran on 10/01/16.
//  Copyright © 2016 Ceran. All rights reserved.
//

import UIKit
import GameKit
import Social

struct UserLevel {
    static let Newbie = "Newbie"
    static let Rookie = "Rookie"
    static let Familiar = "Familiar"
    static let Talented = "Talented"
    static let Expert = "Expert"
    static let Prodigy = "Prodigy"
}

struct LevelDescription {
    static let Newbie = "You know what an emoji is, right? Do more tests to improve your knowledge!"
    static let Rookie = "Don't allow this to let you down. Do more tests to learn your emojis better!"
    static let Familiar = "Way to go. Do more tests to be an expert."
    static let Talented = "You have the force strong in you. Train more to be a true master!"
    static let Expert = "You are a true emoji master. You can use emojis eyes closed!"
    static let Prodigy = "You are the Yoda of emoji Jedis! May the force be with you!"
}

class EndViewController: UIViewController {
    
    // MARK: PROPERTIES
    
    @IBOutlet weak var levelImageView: UIImageView!
    @IBOutlet weak var levelTitleLabel: UILabel!
    @IBOutlet weak var levelDescriptionLabel: UILabel!
    
    // MARK: ACTIONS
    
    @IBAction func facebookButton(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            let defaults = NSUserDefaults.standardUserDefaults()
            let score = defaults.valueForKey("Last Score") as? Double
            facebookSheet.setInitialText("I scored \(score)% in Emoji Quiz. I am \(levelTitleLabel.text) :-) Play now to learn your level!")
            let logo = UIImage(named: "logo")
            facebookSheet.addImage(logo)
            facebookSheet.addURL(NSURL(string: "http://www.appstorelink.com"))
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            if #available(iOS 8.0, *) {
                let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
            }
            
        }

    }
    
    @IBAction func twitterButton(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            let defaults = NSUserDefaults.standardUserDefaults()
            let score = defaults.valueForKey("Last Score") as? Double
            twitterSheet.setInitialText("I scored \(score)% in Emoji Quiz. I am \(levelTitleLabel.text) :-) Play now to learn your level!")
            let logo = UIImage(named: "logo")
            twitterSheet.addImage(logo)
            twitterSheet.addURL(NSURL(string: "http://www.appstorelink.com"))
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            if #available(iOS 8.0, *) {
                let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
            }
            
        }
    }
    
    private func retrieveScore() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let score = defaults.valueForKey("Last Score") as? Double {
            let level = checkLevel(score)
            levelTitleLabel.text = "\(score)% - \(level)"
            levelDescriptionLabel.text = retreiveDescription(score)
        }
    }
    
    private func retreiveDescription(score: Double) -> String {
        switch score {
        case 50..<70: return LevelDescription.Rookie
        case 70..<80: return LevelDescription.Familiar
        case 80..<90: return LevelDescription.Talented
        case 90..<95: return LevelDescription.Expert
        case 95...100: return LevelDescription.Prodigy
        default: return LevelDescription.Newbie
        }
    }
    
    private func checkLevel(score: Double) -> String {
        switch score {
        case 50..<70: return UserLevel.Rookie
        case 70..<80: return UserLevel.Familiar
        case 80..<90: return UserLevel.Talented
        case 90..<95: return UserLevel.Expert
        case 95...100: return UserLevel.Prodigy
        default: return UserLevel.Newbie
        }
    }
    
    private func submitScore() {
        let sScore = GKScore(leaderboardIdentifier: "Leaderboard")
        let defaults = NSUserDefaults.standardUserDefaults()
        if let score = defaults.valueForKey("Highest Score") as? Double {
            print("Highest score is \(score).")
            sScore.value = Int64(score)
            let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
            GKScore.reportScores([sScore], withCompletionHandler: { (error: NSError?) -> Void in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Score submitted")
                }
            })
        }
    }
    
    // MARK: VC LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        self.retrieveScore()
        self.submitScore()
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


