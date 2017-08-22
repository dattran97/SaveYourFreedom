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
    @IBOutlet weak var imgBaby: UIImageView!
    @IBOutlet weak var lblYourScoreText: UILabel!
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblMessage.alpha = 0
        lblScore.alpha = 0
        lblYourScoreText.alpha = 0
        btnTryAgain.alpha = 0
        imgBaby.alpha = 0
        imgBaby.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateKeyframes(withDuration: 3, delay: 0, options: UIViewKeyframeAnimationOptions(animationOptions: .curveEaseIn), animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.7, animations: {
                self.lblMessage.alpha = 1
                self.lblYourScoreText.alpha = 1
                self.btnTryAgain.alpha = 1
                self.imgBaby.alpha = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.3, animations: { 
                self.lblScore.alpha = 1
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
            
        }) { _ in
            
        }
        
    }
}
