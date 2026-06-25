//
//  GameScene.swift
//
//  Created by Diego Henrick on 19/03/24.
//

import SpriteKit
import GameplayKit
import SwiftUI
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var kick = CGFloat(5)
    
    var rotation: CGFloat = 0.0

    var initialPositionY: CGFloat = UIScreen.main.bounds.height - 300
    var initialPositionX: CGFloat = (UIScreen.main.bounds.width / 2) - 20
    
    @Binding var score: Int
    
    var touch = false
    var heightInTouch = 0.0
    
    var highscore = 0
    
    var fruits: [String] = []
    var currentFruit = 0
    
    var spriteBall = SKSpriteNode(imageNamed: "Group-0")
    let leg = SKSpriteNode(imageNamed: "legTorto")
    let scoreNumberLabel = SKLabelNode(fontNamed: "SigmarOne-Regular")
    let backgroundImage = SKSpriteNode(imageNamed: "backgroundPark")
    let ground = SKSpriteNode(imageNamed: "chaoCampo")
    let scoreLabel = SKLabelNode(fontNamed: "SigmarOne-Regular")

    var changed = false
    
    var started = false
    
    let playLabel = SKLabelNode(fontNamed: "SigmarOne-Regular")
    let highscoreLabelTextStart = SKLabelNode(fontNamed: "SigmarOne-Regular")
    let scoreLabelTextStart = SKLabelNode(fontNamed: "SigmarOne-Regular")
    let highscoreLabelStart = SKLabelNode(fontNamed: "SigmarOne-Regular")

    let juggleLabel = SKLabelNode(fontNamed: "SigmarOne-Regular")

    
    var startGameScene = true
    
    @Binding var showGameOver: Bool
    
    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
    init(size: CGSize, showGameOver: Binding<Bool>, score: Binding<Int>) {
        self._showGameOver = showGameOver
        self._score = score
        super.init(size: size)
    }
    
    
    override func didMove(to view: SKView) {
        fruits = []
        for i in 0...31 {
            fruits.append("Group-\(i)")
        }
        
        self.view?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
                    
        if startGameScene == false {
            backgroundImage.removeFromParent()
            ground.removeFromParent()
            scoreNumberLabel.removeFromParent()
            spriteBall.removeFromParent()
            leg.removeFromParent()
            spriteBall.physicsBody?.affectedByGravity = false
            showStartGame()
            self.backgroundColor = UIColor(named: "ColorYellow") ?? SKColor.yellow

        } else {
            juggleLabel.removeFromParent()
            highscoreLabelTextStart.removeFromParent()
            scoreLabelTextStart.removeFromParent()
            playLabel.removeFromParent()
            highscoreLabelStart.removeFromParent()
            playGame()
            
            started = true
            startGameScene = true
        }
    }
    func playGameNoAdd() {
        backgroundImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundImage.size = CGSize(width: 494*0.65, height: 844*0.65)
        backgroundImage.zPosition = -2
        
        ground.position = CGPoint(x: size.width / 2, y: 20)
        ground.size = CGSize(width: 423 * 0.7, height: 180 * 0.7)
        ground.zPosition = -1

        
        rotation = 1
        
        spriteBall.position = CGPoint(x: initialPositionX, y: initialPositionY )
        spriteBall.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spriteBall.size = CGSize(width: 50, height: 50)
        spriteBall.zPosition = 1
        spriteBall.name = "ballNode"
        spriteBall.alpha = 1
        spriteBall.blendMode = .alpha
        
        spriteBall.physicsBody = SKPhysicsBody(texture: spriteBall.texture! , size: spriteBall.size)
        spriteBall.physicsBody?.affectedByGravity = false
        
        leg.size = CGSize(width: 105.6, height: 456)
        leg.position = CGPoint(x: 0, y: 200)
        
        leg.physicsBody = SKPhysicsBody(texture: leg.texture! , size: leg.size)
        leg.physicsBody?.affectedByGravity = false
        leg.physicsBody?.pinned = true
        leg.physicsBody?.allowsRotation = true
        leg.physicsBody?.isDynamic = true
        leg.zRotation = rotation
        leg.physicsBody?.mass = 5
        leg.physicsBody?.friction = 0.2
        leg.physicsBody?.restitution = 0.2
        leg.physicsBody?.linearDamping = 0.1
        leg.physicsBody?.angularDamping = 0.1
        leg.physicsBody?.angularVelocity = 0
        leg.physicsBody?.velocity = CGVector(dx: 0, dy: 0)

        
        showScoreAnimation()
        
        highscore = UserDefaults.standard.integer(forKey: "highscore")
        
        self.physicsWorld.contactDelegate = self
        setupCollision()
    }
    func playGame() {

        backgroundImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundImage.size = CGSize(width: 494*0.65, height: 844*0.65)
        backgroundImage.zPosition = -2
        backgroundImage.removeFromParent()
        addChild(backgroundImage)
        
        ground.position = CGPoint(x: size.width / 2, y: 20)
        ground.size = CGSize(width: 423 * 0.7, height: 180 * 0.7)
        ground.zPosition = -1
        addChild(ground)
        
        animateGround()
        
        
        rotation = 1

        spriteBall.position = CGPoint(x: initialPositionX, y: initialPositionY )
        spriteBall.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spriteBall.size = CGSize(width: 50, height: 50)
        spriteBall.zPosition = 1
        spriteBall.name = "ballNode"
        spriteBall.alpha = 1
        spriteBall.blendMode = .alpha
        
        spriteBall.physicsBody = SKPhysicsBody(texture: spriteBall.texture! , size: spriteBall.size)
        spriteBall.physicsBody?.affectedByGravity = false
        addChild(spriteBall)
        
        leg.size = CGSize(width: 216, height: 216)
        leg.position = CGPoint(x: 100, y: 200)
        
        leg.size = CGSize(width: 105.6, height: 456)
        leg.position = CGPoint(x: 0, y: 200)
        
        leg.physicsBody = SKPhysicsBody(texture: leg.texture! , size: leg.size)
        leg.physicsBody?.affectedByGravity = false
        leg.physicsBody?.pinned = true
        leg.physicsBody?.allowsRotation = true
        leg.physicsBody?.isDynamic = true
        leg.zRotation = rotation
        leg.physicsBody?.mass = 5
        leg.physicsBody?.friction = 0.2
        leg.physicsBody?.restitution = 0.2
        leg.physicsBody?.linearDamping = 0.1
        leg.physicsBody?.angularDamping = 0.1
        leg.physicsBody?.angularVelocity = 0
        leg.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        addChild(leg)

        
        showScoreAnimation()
        
        highscore = UserDefaults.standard.integer(forKey: "highscore")
        
        self.physicsWorld.contactDelegate = self
        setupCollision()
    }
    func showStartGame() {
        highscore = UserDefaults.standard.integer(forKey: "highscore")

        juggleLabel.text = "JUGGLE"
        juggleLabel.fontSize = 20
        juggleLabel.fontColor = UIColor(named: "ColorScore")
        juggleLabel.horizontalAlignmentMode = .center
        juggleLabel.position = CGPoint(x: (UIScreen.main.bounds.width / 2) - 55, y:  270)
        addChild(juggleLabel)
        
        highscoreLabelTextStart.text = "BEST"
        highscoreLabelTextStart.fontSize = 20
        highscoreLabelTextStart.fontColor = UIColor(.white)
        highscoreLabelTextStart.horizontalAlignmentMode = .left
        highscoreLabelTextStart.position = CGPoint(x: 35, y:  440)
        addChild(highscoreLabelTextStart)
        
        playLabel.text = "PLAY"
        playLabel.fontSize = 40
        playLabel.fontColor = UIColor(named: "ColorScore")
        playLabel.horizontalAlignmentMode = .center
        playLabel.position = CGPoint(x: (UIScreen.main.bounds.width / 2) - 55, y:  80)
        addChild(playLabel)
        
        highscoreLabelStart.text = String(format: "%02d", highscore)
        highscoreLabelStart.fontSize = 180
        highscoreLabelStart.fontColor = UIColor(named: "ColorScore")
        highscoreLabelStart.horizontalAlignmentMode = .center
        highscoreLabelStart.position = CGPoint(x: (UIScreen.main.bounds.width / 2) - 55, y: 300)
        addChild(highscoreLabelStart)
    }
    
    func showScoreAnimation() {
        let scaleUpAction = SKAction.scale(to: 1.2, duration: 0.5)
        scaleUpAction.timingMode = .easeInEaseOut

        let scaleDownAction = SKAction.scale(to: 1.0, duration: 0.2)
        scaleDownAction.timingMode = .easeInEaseOut

        let sequence = SKAction.sequence([scaleUpAction, scaleDownAction])

        scoreNumberLabel.run(sequence)
    }
    
    func animateGround() {
        ground.position = CGPoint(x: size.width / 2, y: -ground.size.height)

        let moveUpAction = SKAction.moveTo(y: ground.size.height / 2, duration: 1.0)
        moveUpAction.timingMode = .easeInEaseOut

        let bounceAction = SKAction.sequence([
            SKAction.scale(to: 1.2, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ])

        let sequence = SKAction.sequence([moveUpAction, bounceAction])

        ground.run(sequence)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact!!!")
        spriteBall.physicsBody?.velocity.dy = 400
        print(score)
        touch = true
        heightInTouch = spriteBall.position.y
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func setupCollision() {
        let contactCategoryBall: UInt32 = 0x1 << 0
        let contactCategoryLeg: UInt32 = 0x1 << 1
        
        spriteBall.physicsBody?.categoryBitMask = contactCategoryBall
        leg.physicsBody?.categoryBitMask = contactCategoryLeg
        
        spriteBall.physicsBody?.collisionBitMask = contactCategoryLeg
        
        spriteBall.physicsBody?.contactTestBitMask = contactCategoryLeg
    }

    func touchDown(atPoint pos : CGPoint) {
        if showGameOver == false {
            if started == false {
                juggleLabel.removeFromParent()
                highscoreLabelTextStart.removeFromParent()
                scoreLabelTextStart.removeFromParent()
                playLabel.removeFromParent()
                highscoreLabelStart.removeFromParent()
                self.backgroundColor = UIColor(.white)
                if startGameScene == false {
                    playGame()
                }
                started = true
                startGameScene = true
            } else {
                leg.physicsBody?.angularVelocity = 5
                print(leg.zRotation)
                spriteBall.physicsBody?.affectedByGravity = true
                
            }
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {
        leg.physicsBody?.angularVelocity = 0
        leg.zRotation = rotation
        leg.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if showGameOver == false {
            if spriteBall.position.y < -scene!.size.height * 1.3 {
                if score > highscore {
                    highscore = score
                    UserDefaults.standard.setValue(highscore, forKey: "highscore")
                    UserDefaults.standard.synchronize()
                    if GKLocalPlayer.local.isAuthenticated {
                        let score = GKScore(leaderboardIdentifier: "leaderboard")
                        score.value =  Int64(highscore)
                        GKScore.report([score]) { error in
                            if let error = error {
                                print("Error reporting score: \(error.localizedDescription)")
                            } else {
                                print("Score reported successfully!")
                            }
                        }
                    }
                }
                
                started = false
                playGameNoAdd()
                currentFruit = 0
                spriteBall.texture = SKTexture(imageNamed: fruits[currentFruit])
                showGameOver = true
            }
            
            if spriteBall.position.y > heightInTouch * 1.2 && touch == true {
                score += 1
                showScoreAnimation()
                touch = false
                
                if score % 10 == 0 && score != 0{
                    if currentFruit < 2 {
                        currentFruit += 1
                    } else {
                        currentFruit = 0
                    }
                    spriteBall.texture = SKTexture(imageNamed: fruits[currentFruit])
                    
                }
            }
            
            if leg.zRotation >= 2 {
                leg.zRotation = leg.zRotation
                leg.physicsBody?.angularVelocity = 0
                leg.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                
            }
            if leg.zRotation <= 0.5 {
                leg.zRotation = leg.zRotation
                leg.physicsBody?.angularVelocity = 0
                leg.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            }
            scoreNumberLabel.text =  String(format: "%02d", 444)
        }
    }

    func resetBallPosition() {
        if let view = self.view {
            spriteBall.position.y = initialPositionY
            spriteBall.position.x = initialPositionX

            spriteBall.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            spriteBall.physicsBody?.angularVelocity = 0
            leg.zRotation = rotation
            leg.physicsBody?.angularVelocity = 0
            touch = false
            started = false

        }
    }
}
