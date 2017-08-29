//
//  EndVC.swift
//  SaveYourFreedom
//
//  Created by Dat on 8/23/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import UIKit

final class EndVC: UIViewController{
    
    static func getInstance(score: Int) -> EndVC{
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EndVC") as! EndVC
        vc.score = score
        return vc
    }
    
    //MARK: - Outlet
    @IBOutlet weak var vwTopbar: UIView!
    @IBOutlet weak var lblHighscore: UILabel!
    @IBOutlet weak var imgBaby: UIImageView!
    @IBOutlet weak var lblYourScoreText: UILabel!
    @IBOutlet weak var lblHighscoreText: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var btnTryAgain: UIButton!
    
    //MARK: - Support variables
    private var score:Int = 0
    
    //MARK: - Action
    @IBAction func tryAgainAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblScore.text = "\(score)"
        lblHighscore.text = "\(UserDefaults.highscore)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblMessage.alpha = 0
        lblYourScoreText.alpha = 0
        imgBaby.alpha = 0
        imgBaby.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animateKeyframes(withDuration: 2, delay: 0, options: UIViewKeyframeAnimationOptions(animationOptions: .curveEaseIn), animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.7, animations: {
                self.lblMessage.alpha = 1
                self.lblYourScoreText.alpha = 1
                self.imgBaby.alpha = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                self.imgBaby.transform = .identity
            })
            UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.25, animations: {
                self.lblMessage.transform = CGAffineTransform(scaleX: 2, y: 2)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2, animations: {
                self.lblMessage.transform = .identity
            })
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1, animations: { 
                self.lblScore.textColor = self.btnTryAgain.backgroundColor
            })
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                self.lblScore.center.y += (self.lblYourScoreText.center.y - self.lblScore.center.y + 20)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.35, relativeDuration: 0.2, animations: {
                self.lblScore.center.x += (self.lblYourScoreText.center.x - self.lblScore.center.x + self.lblYourScoreText.frame.width/2 + 35)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.3, animations: { 
                self.lblScore.center.y -= 20
            })
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
                self.lblScore.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
            })
        }) { _ in
            self.lblScore.center.x = self.lblScore.center.x + self.lblYourScoreText.center.x - self.lblScore.center.x + self.lblYourScoreText.frame.width/2 + 35
            self.lblScore.center.y = self.lblScore.center.y + self.lblYourScoreText.center.y - self.lblScore.center.y
            self.saveScore()
        }
        
    }
    
    //MARK: - Support functions
    private func saveScore(){
        guard let txtScore = lblScore.text, let score:Int = Int(txtScore) else { return }
        if score > UserDefaults.highscore{
            UserDefaults.highscore = score
            UIView.animateKeyframes(withDuration: 1, delay: 0, options: UIViewKeyframeAnimationOptions(animationOptions: .curveEaseIn), animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                    self.lblYourScoreText.alpha = 0
                    self.lblScore.transform = .identity
                    self.lblScore.center.x = self.lblHighscore.center.x
                })
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4, animations: {
                    self.lblScore.frame.origin.y = self.vwTopbar.frame.height
                })
                UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.15, animations: {
                    self.lblScore.frame.origin.y = self.lblHighscore.frame.height + self.lblHighscore.frame.origin.y
                })
                UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.15, animations: {
                    self.lblScore.frame.origin.y = self.lblHighscore.frame.origin.y
                    self.lblHighscore.frame.origin.y = -self.lblHighscore.frame.height
                })
                UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: { 
                    self.lblHighscoreText.center.x = self.view.center.x
                    self.lblHighscoreText.alpha = 1
                })
            }) { _ in
                self.lblScore.textColor = UIColor.white
            }
        }
    }
}
