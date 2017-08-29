//
//  GameVC.swift
//  SaveYourFreedom
//
//  Created by Dat on 8/17/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import UIKit

final class GameVC: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var vwTopBar: UIView!
    @IBOutlet weak var vwGameBackground: UIView!
    @IBOutlet weak var vwBottomBar: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblHighscore: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    
    //MARK: - Support variables
    private var level:Int = 1
    private var state:GameState = .pending
    private var displayLink:CADisplayLink?
    private var beginTime:Double = 0
    private var currentMessage:String! {
        didSet{
            lblMessage.text = currentMessage
        }
    }
    
    //Player
    private var player = Player()
    
    //Enemies
    private var enemies = [Enemy]()
    private var enemyTimer:Timer?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configZPosition()
        lblHighscore.text = "\(UserDefaults.highscore)"
        self.view.addSubview(self.player.element)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblHighscore.text = "\(UserDefaults.highscore)"
        self.currentMessage = "Touch to start"
        self.state = .pending
        
        self.player.element.backgroundColor = UIColor.clear
        self.player.element.alpha = 1
        self.player.element.center = view.center
    }
    
    //MARK: - touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if state == .animating { return }
        //First touch
        if state == .pending{
            self.player.element.layer.removeAllAnimations()
            startGame()
        }
        
        if let touchLocation = event?.allTouches?.first?.location(in: view) {
            guard touchLocation.y > vwTopBar.frame.size.height && touchLocation.y < ScreenSize.height - vwBottomBar.frame.size.height else { return }
            player.rotate(to: touchLocation)
            player.move(to: touchLocation, duration: 4)
            for enemy in enemies{
                enemy.move(to: touchLocation)
            }
        }
    }
    
    //MARK: - Game state support functions
    private func startGame(){
        state = .playing
        currentMessage = "Touch around to keep your eggs away from tadpoles"
        lblScore.text = "0"
        beginTime = 0
        
        startTimer()
        startDisplayLink()
    }
    
    private func stopGame(intersectedEnemy: Enemy){
        state = .animating
        
        stopTimer()
        stopDisplayLink()
        
        for i in (0..<enemies.count).reversed(){
            removeEnemy(at: i)
        }
        
        player.moveAnimator?.stopAnimation(false)
        player.rotateAnimator?.stopAnimation(false)
        animateEndGame()
    }
    
    
    //MARK: - Timer
    private func startTimer(){
        enemyTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.generateEnemy), userInfo: nil, repeats: true)
    }
    
    private func stopTimer(){
        guard let timer = enemyTimer, timer.isValid else { return }
        timer.invalidate()
    }
    
    func generateEnemy(){
        let enemy = Enemy()
        self.enemies.append(enemy)
        self.view.addSubview(enemy.element)
        
        enemy.move(to: player.element.center)
    }
    
    //MARK: - DisplayLink
    private func startDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(self.update))
        displayLink?.add(to: .current, forMode: .defaultRunLoopMode)
    }
    
    private func stopDisplayLink(){
        displayLink?.isPaused = true
        displayLink?.remove(from: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        displayLink = nil
    }
    
    func update(displayLink: CADisplayLink){
        self.updateScore(displayLink.timestamp)
        for (index, enemy) in enemies.enumerated() {
            guard let playerFrame = self.player.element.presentationFrame else{ return }
            //Rotate player to nearest enemy
            if let center = player.element.presentationCenter{
                enemy.rotate(to: center)
            }
            //Check intersection
            guard let enemyFrame = enemy.element.presentationFrame else{ return }
            if playerFrame.intersects(enemyFrame){
                self.stopGame(intersectedEnemy: enemy)
                return
            }
            if index + 1 > enemies.count - 1 { return }
            for ene in enemies[index + 1..<enemies.count]{
                guard let eneFrame = ene.element.presentationFrame else{ return }
                if eneFrame.intersects(enemyFrame){
                    self.removeEnemy(at: index)
                    break
                }
            }
        }
    }

    private func updateScore(_ timestamp: CFTimeInterval){
        if beginTime == 0{
            beginTime = timestamp
        }
        lblScore.text = String(Int((timestamp - beginTime).rounded(toPlaces: 1)*10))
    }
    
    //MARK: - Support functions
    private func configZPosition(){
        vwGameBackground.layer.zPosition = -.greatestFiniteMagnitude
    }
    private func removeEnemy(at index:Int){
        enemies[index].element.removeFromSuperview()
        self.enemies.remove(at: index)
    }
    
    private func animateEndGame(){
        //Support variables
        let playerView = self.player.element
        let duration:Double = 2
        var rotateDuration:Double = 0.5
        let rotate = Animator.rotateWithRepeat(view: playerView, duration: rotateDuration)
        let rotateAnimationKey:String = "end-screen-rotation"
        
        //Add sublayer
        let whiteCircle = UIView()
        whiteCircle.frame.size = CGSize(width: PlayerConstants.size, height: PlayerConstants.size)
        whiteCircle.center = playerView.center
        whiteCircle.layer.backgroundColor = UIColor.white.cgColor
        whiteCircle.layer.cornerRadius = playerView.layer.cornerRadius
        whiteCircle.alpha = 0
        whiteCircle.layer.zPosition = -1
        self.view.addSubview(whiteCircle)
        
        //Add rotation
        playerView.layer.add(rotate, forKey: rotateAnimationKey)
        _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
            if rotateDuration > 0.1{
                rotateDuration = rotateDuration - 0.1
                Animator.changeRotationDuration(view: playerView, toDuration: rotateDuration, animationKey: rotateAnimationKey)
            }else{
                timer.invalidate()
            }
        }
        
        //Add keyframes
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [UIViewKeyframeAnimationOptions(animationOptions: .curveEaseIn)], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1, animations: {
                playerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                playerView.center.x += 10
                whiteCircle.center.x += 10
            })
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.1, animations: {
                playerView.transform = CGAffineTransform(scaleX: 2, y: 2)
                playerView.center.y += 10
                whiteCircle.center.y += 10
                playerView.center.x -= 10
                whiteCircle.center.x -= 10
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.1, animations: {
                playerView.transform = .identity
                playerView.center.x += 10
                whiteCircle.center.x += 10
                
            })
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.1, animations: {
                playerView.center.y -= 10
                whiteCircle.center.y -= 10
                playerView.center.x -= 10
                whiteCircle.center.x -= 10
            })
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4, animations: {
                playerView.backgroundColor = UIColor.white
                playerView.alpha = 0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.05, relativeDuration: 0.75, animations: {
                whiteCircle.alpha = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 0.42, relativeDuration: 0.55, animations: {
                whiteCircle.transform = CGAffineTransform(scaleX: 45, y: 45)
            })
            
        }, completion: { _ in
            whiteCircle.removeFromSuperview()

            let vc = EndVC.getInstance(score: Int(self.lblScore.text!)!)
            self.present(vc, animated: false, completion: nil)
        })
    }
}


