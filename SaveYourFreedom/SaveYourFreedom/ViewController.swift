//
//  ViewController.swift
//  SaveYourFreedom
//
//  Created by Dat on 8/17/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var lblHighscore: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblTouchToStart: UILabel!
    
    //MARK: - Support variables
    private var state:GameState = .pending
    private var displayLink:CADisplayLink?
    private var beginTime:Double = 0
    
    //Player
    private let player = Player()
    
    //Enemies
    private var enemies = [Enemy]()
    private var enemyTimer:Timer?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblHighscore.text = "\(UserDefaults.highscore)"
        self.view.addSubview(self.player.element)
    }
    
    //MARK: - touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //First touch
        if state == .end{
            for enemy in enemies{
                enemy.element.removeFromSuperview()
            }
            enemies = []
            player.moveAnimator?.stopAnimation(true)
            player.move(to: view.center, duration: 1.5)
            state = .pending
        }else{
            if state == .pending{
                startGame()
            }
            
            if let touchLocation = event?.allTouches?.first?.location(in: view) {
                player.move(to: touchLocation, duration: 4)
                for enemy in enemies{
                    enemy.move(to: touchLocation)
                }
            }
        }
    }
    
    //MARK: - Game state support functions
    private func startGame(){
        state = .playing
        lblTouchToStart.isHidden = true
        lblScore.text = "0"
        beginTime = 0
        
        startTimer()
        startDisplayLink()
    }
    
    private func stopGame(intersectedEnemy: Enemy){
        state = .end
        lblTouchToStart.isHidden = false
        
        stopTimer()
        stopDisplayLink()
        saveScore()
        
        for enemy in enemies{
            if enemy.element != intersectedEnemy.element{
                enemy.element.removeFromSuperview()
            }
        }
        
        player.moveAnimator?.pauseAnimation()
        intersectedEnemy.moveAnimator?.pauseAnimation()
        intersectedEnemy.rotateAnimator?.pauseAnimation()
        intersectedEnemy.rotateAnimator?.fractionComplete = 1
        enemies = [intersectedEnemy]
        
//        player.move(to: view.center, duration: 1.5)
        
//        for i in (0..<enemies.count).reversed(){
//            removeEnemy(at: i)
//        }
    }
    
    private func saveScore(){
        guard let txtScore = lblScore.text, let score:Int = Int(txtScore) else { return }
        if score > UserDefaults.highscore{
            UserDefaults.highscore = score
            lblHighscore.text = "\(score)"
        }
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
        enemy.rotate(to: player.element.center, duration: 0.1)
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
    private func removeEnemy(at index:Int){
        enemies[index].element.removeFromSuperview()
        self.enemies.remove(at: index)
    }
}

