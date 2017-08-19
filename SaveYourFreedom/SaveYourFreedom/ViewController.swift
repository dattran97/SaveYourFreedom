//
//  ViewController.swift
//  SaveYourFreedom
//
//  Created by Dat on 8/17/17.
//  Copyright © 2017 Dat Tran. All rights reserved.
//

import UIKit

struct ScreenSize{
    static let width:CGFloat            = UIScreen.main.bounds.size.width
    static let height:CGFloat           = UIScreen.main.bounds.size.height
}

enum GameState{
    case pending
    case playing
    case end
}

enum Direction{
    case top
    case left
    case right
    case bottom
}

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
    let vwPlayer = UIImageView()
    let playerSize:CGFloat = 36
    //Enemies
    var enemies = [UIImageView]()
    let enemySize:CGFloat = 24
    let enemySpeed:CGFloat = 1
    var enemyTimer:Timer?
    var enemyDirections:[Direction] = [.top, .left, .right, .bottom]
    var enemyColors = [#colorLiteral(red: 0.08235294118, green: 0.6980392157, blue: 0.5411764706, alpha: 1), #colorLiteral(red: 0.07058823529, green: 0.5725490196, blue: 0.4470588235, alpha: 1), #colorLiteral(red: 0.9333333333, green: 0.7333333333, blue: 0, alpha: 1), #colorLiteral(red: 0.9411764706, green: 0.5450980392, blue: 0, alpha: 1), #colorLiteral(red: 0.1411764706, green: 0.7803921569, blue: 0.3529411765, alpha: 1), #colorLiteral(red: 0.1176470588, green: 0.6431372549, blue: 0.2941176471, alpha: 1), #colorLiteral(red: 0.8784313725, green: 0.4156862745, blue: 0.03921568627, alpha: 1), #colorLiteral(red: 0.7882352941, green: 0.2470588235, blue: 0, alpha: 1), #colorLiteral(red: 0.1490196078, green: 0.5098039216, blue: 0.8352941176, alpha: 1), #colorLiteral(red: 0.1137254902, green: 0.4156862745, blue: 0.6784313725, alpha: 1), #colorLiteral(red: 0.8823529412, green: 0.2, blue: 0.1607843137, alpha: 1), #colorLiteral(red: 0.7019607843, green: 0.1411764706, blue: 0.1098039216, alpha: 1), #colorLiteral(red: 0.537254902, green: 0.2352941176, blue: 0.662745098, alpha: 1), #colorLiteral(red: 0.4823529412, green: 0.1490196078, blue: 0.6235294118, alpha: 1), #colorLiteral(red: 0.6862745098, green: 0.7137254902, blue: 0.7333333333, alpha: 1), #colorLiteral(red: 0.1529411765, green: 0.2196078431, blue: 0.2980392157, alpha: 1), #colorLiteral(red: 0.1294117647, green: 0.1843137255, blue: 0.2470588235, alpha: 1), #colorLiteral(red: 0.5137254902, green: 0.5843137255, blue: 0.5843137255, alpha: 1), #colorLiteral(red: 0.4235294118, green: 0.4745098039, blue: 0.4784313725, alpha: 1)]
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
    }
    
    //MARK: - TouchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //First touch
        if state == .pending{
            state = .playing
            enemyTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.generateEnemy), userInfo: nil, repeats: true)
            createDisplayLink()
            lblTouchToStart.isHidden = true
            lblScore.text = "0"
            beginTime = 0
        }
        
        if let touchLocation = event?.allTouches?.first?.location(in: view) {
            Animator.move(view: self.vwPlayer, to: touchLocation, duration: 4).startAnimation()
            for enemy in enemies{
                Animator.move(view: enemy, to: touchLocation, duration: getEnemyDuration(enemy)).startAnimation()
            }
        }
    }

    //MARK: - Initial functions
    private func setupPlayer(){
        vwPlayer.image = UIImage(named: "player")
        vwPlayer.frame.size = CGSize(width: playerSize, height: playerSize)
        vwPlayer.center = view.center
        vwPlayer.layer.cornerRadius = vwPlayer.frame.size.width/2
        view.addSubview(vwPlayer)
    }

    func generateEnemy(){
        let enemy = UIImageView()
//        enemy.backgroundColor = enemyColors.getRandomItem()
//        enemy.image = UIImage(named: "enemy_blue_1")
        enemy.animationImages = [UIImage(named: "enemy_blue_1")!, UIImage(named: "enemy_blue_2")!, UIImage(named: "enemy_blue_3")!, UIImage(named: "enemy_blue_2")!]
        enemy.animationDuration = 0.33
        enemy.startAnimating()
        enemy.frame.size = CGSize(width: enemySize, height: enemySize)
        switch enemyDirections.getRandomItem()!{
        case .top:
            enemy.frame.origin = CGPoint(x: CGFloat(arc4random_uniform(UInt32(ScreenSize.width))), y: -enemySize)
        case .bottom:
            enemy.frame.origin = CGPoint(x: CGFloat(arc4random_uniform(UInt32(ScreenSize.width))), y: ScreenSize.height + enemySize)
        case .left:
            enemy.frame.origin = CGPoint(x: -enemySize, y: CGFloat(arc4random_uniform(UInt32(ScreenSize.height))))
        case .right:
            enemy.frame.origin = CGPoint(x: ScreenSize.width + enemySize, y: CGFloat(arc4random_uniform(UInt32(ScreenSize.height))))
        }
        
        self.enemies.append(enemy)
        self.view.addSubview(enemy)
        
        Animator.move(view: enemy, to: vwPlayer.frame.origin, duration: getEnemyDuration(enemy)).startAnimation()
    }
    
    //MARK: - Support function

    func getEnemyDuration(_ enemy: UIView) -> TimeInterval {
        let dx = vwPlayer.center.x - enemy.center.x
        let dy = vwPlayer.center.y - enemy.center.y
        return TimeInterval(sqrt(dx * dx + dy * dy) / enemySpeed)
    }
    
    func createDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(self.checkIntersection))
        displayLink?.add(to: .current, forMode: .defaultRunLoopMode)
    }
    
    func checkIntersection(displaylink: CADisplayLink) {
        if beginTime == 0{
            beginTime = displaylink.timestamp
        }
        lblScore.text = String(Int((displaylink.timestamp - beginTime).rounded(toPlaces: 1)*10))
        guard let playerFrame = vwPlayer.layer.presentation()?.frame else{ return }
        for (index, enemy) in enemies.enumerated() {
            guard let enemyFrame = enemy.layer.presentation()?.frame else{ return }
            if playerFrame.intersects(enemyFrame){
                self.gameOver()
                return
            }
            if index + 1 > enemies.count - 1 { return }
            for ene in enemies[index + 1..<enemies.count]{
                guard let eneFrame = ene.layer.presentation()?.frame else{ return }
                if eneFrame.intersects(enemyFrame){
                    enemy.removeFromSuperview()
                    self.enemies.remove(at: index)
                    break
                }
            }
        }
    }
    
    func gameOver(){
        enemyTimer?.invalidate()
        enemyTimer = nil
        
        lblTouchToStart.isHidden = false
        state = .pending
        
        displayLink?.isPaused = true
        displayLink?.remove(from: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        displayLink = nil
        
        Animator.move(view: vwPlayer, to: view.center, duration: 1.5).startAnimation()
        
        for enemy in enemies{
            enemy.removeFromSuperview()
        }
        enemies = []
    }
}

