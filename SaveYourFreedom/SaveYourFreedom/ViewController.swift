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
    var state:GameState = .pending
    var displayLink:CADisplayLink?
    var beginTime:Double = 0
    
    //Player
    let player = Player()
    
    //Enemies
    var enemies = [Enemy]()
    var enemyTimer:Timer?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.player.element)
    }
    
    //MARK: - touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //First touch
        if state != .playing{
            startGame()
        }
        
        if let touchLocation = event?.allTouches?.first?.location(in: view) {
            player.move(to: touchLocation, duration: 4)
            for enemy in enemies{
                enemy.move(to: touchLocation)
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
    
    private func stopGame(){
        state = .pending
        lblTouchToStart.isHidden = false
        
        stopTimer()
        stopDisplayLink()
        
        player.move(to: view.center, duration: 1.5)
        
        for i in 0..<enemies.count{
            removeEnemy(at: i)
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
    }
    
    //MARK: - DisplayLink
    private func startDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(self.checkIntersection))
        displayLink?.add(to: .current, forMode: .defaultRunLoopMode)
    }
    
    private func stopDisplayLink(){
        displayLink?.isPaused = true
        displayLink?.remove(from: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        displayLink = nil
    }
    
    func checkIntersection(displaylink: CADisplayLink) {
        if beginTime == 0{
            beginTime = displaylink.timestamp
        }
        lblScore.text = String(Int((displaylink.timestamp - beginTime).rounded(toPlaces: 1)*10))
        guard let playerFrame = self.player.element.presentationFrame else{ return }
        for (index, enemy) in enemies.enumerated() {
            guard let enemyFrame = enemy.element.presentationFrame else{ return }
            if playerFrame.intersects(enemyFrame){
                self.stopGame()
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
    
    //MARK: - Support functions
    private func removeEnemy(at index:Int){
        enemies[index].element.removeFromSuperview()
        self.enemies.remove(at: index)
    }
}

