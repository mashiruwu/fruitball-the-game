//
//  GameScene.swift
//
//  Created by Diego Henrick on 19/03/24.
//

import SpriteKit
import SwiftUI
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    private enum FruitBodyShape {
        case circle(radiusScale: CGFloat)
        case ellipse(widthScale: CGFloat, heightScale: CGFloat)
    }

    private struct FruitPhysicsProfile {
        let assetName: String
        let displaySize: CGSize
        let bodyShape: FruitBodyShape
    }

    private static let contactCategoryBall: UInt32 = 0x1 << 0
    private static let contactCategoryLeg: UInt32 = 0x1 << 1

    private static let fruitProfiles: [FruitPhysicsProfile] = [
        tallFruit("Group-0", width: 49, height: 74),
        wideFruit("Group-1", width: 78, height: 53),
        tallFruit("Group-2", width: 55, height: 67),
        tallFruit("Group-3", width: 57, height: 67),
        wideFruit("Group-4", width: 70, height: 35),
        roundFruit("Group-5", width: 46, height: 45),
        roundFruit("Group-6", width: 39, height: 39),
        tallFruit("Group-7", width: 44, height: 51),
        tallFruit("Group-8", width: 46, height: 74),
        tallFruit("Group-9", width: 42, height: 64),
        roundFruit("Group-10", width: 49, height: 54),
        roundFruit("Group-11", width: 49, height: 54),
        wideFruit("Group-12", width: 81, height: 46),
        wideFruit("Group-13", width: 70, height: 35),
        wideFruit("Group-14", width: 67, height: 24),
        tallFruit("Group-15", width: 44, height: 52),
        tallFruit("Group-16", width: 26, height: 40),
        wideFruit("Group-17", width: 78, height: 47),
        roundFruit("Group-18", width: 44, height: 44),
        tallFruit("Group-19", width: 44, height: 89),
        tallFruit("Group-20", width: 42, height: 64),
        wideFruit("Group-21", width: 82, height: 54),
        tallFruit("Group-22", width: 49, height: 74),
        tallFruit("Group-23", width: 44, height: 52),
        roundFruit("Group-24", width: 32, height: 34),
        wideFruit("Group-25", width: 81, height: 53),
        tallFruit("Group-26", width: 56, height: 68),
        roundFruit("Group-27", width: 53, height: 44),
        wideFruit("Group-28", width: 70, height: 35),
        tallFruit("Group-29", width: 59, height: 65),
        tallFruit("Group-30", width: 41, height: 62),
        roundFruit("Group-31", width: 54, height: 47)
    ]

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
    let backgroundImage = SKSpriteNode(imageNamed: "backgroundPark")
    let ground = SKSpriteNode(imageNamed: "chaoCampo")
    
    var started = false
    
    let playLabel = SKLabelNode(fontNamed: "SigmarOne-Regular")
    let highscoreLabelTextStart = SKLabelNode(fontNamed: "SigmarOne-Regular")
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
        configureFruitList()
        
        self.view?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
                    
        if startGameScene == false {
            backgroundImage.removeFromParent()
            ground.removeFromParent()
            spriteBall.removeFromParent()
            leg.removeFromParent()
            spriteBall.physicsBody?.affectedByGravity = false
            showStartGame()
            self.backgroundColor = UIColor(named: "ColorYellow") ?? SKColor.yellow

        } else {
            juggleLabel.removeFromParent()
            highscoreLabelTextStart.removeFromParent()
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
        spriteBall.zPosition = 1
        spriteBall.name = "ballNode"
        spriteBall.alpha = 1
        spriteBall.blendMode = .alpha
        applyFruitProfile(at: currentFruit, preservingMotion: false, affectedByGravity: false)
        
        configureLeg()

        
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
        spriteBall.zPosition = 1
        spriteBall.name = "ballNode"
        spriteBall.alpha = 1
        spriteBall.blendMode = .alpha
        applyFruitProfile(at: currentFruit, preservingMotion: false, affectedByGravity: false)
        addChild(spriteBall)
        
        configureLeg()
        addChild(leg)

        
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
        spriteBall.physicsBody?.velocity.dy = 400
        touch = true
        heightInTouch = spriteBall.position.y
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func setupCollision() {
        spriteBall.physicsBody?.categoryBitMask = Self.contactCategoryBall
        leg.physicsBody?.categoryBitMask = Self.contactCategoryLeg
        
        spriteBall.physicsBody?.collisionBitMask = Self.contactCategoryLeg
        
        spriteBall.physicsBody?.contactTestBitMask = Self.contactCategoryLeg
    }

    func touchDown(atPoint pos : CGPoint) {
        if showGameOver == false {
            if started == false {
                juggleLabel.removeFromParent()
                highscoreLabelTextStart.removeFromParent()
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
                spriteBall.physicsBody?.affectedByGravity = true
            }
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        leg.physicsBody?.angularVelocity = 0
        leg.zRotation = rotation
        leg.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
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
                currentFruit = 0
                playGameNoAdd()
                showGameOver = true
            }
            
            if spriteBall.position.y > heightInTouch * 1.2 && touch == true {
                score += 1
                touch = false
                
                if score % 10 == 0 && score != 0 {
                    currentFruit = (currentFruit + 1) % fruits.count
                    applyFruitProfile(at: currentFruit, preservingMotion: true)
                }
            }
            
            if leg.zRotation >= 2 {
                leg.physicsBody?.angularVelocity = 0
                leg.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            }
            if leg.zRotation <= 0.5 {
                leg.physicsBody?.angularVelocity = 0
                leg.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            }
        }
    }

    func restartGame() {
        showGameOver = false
        score = 0
        touch = false
        heightInTouch = 0
        started = true
        startGameScene = true
        currentFruit = 0

        configureFruitList()

        spriteBall.position.y = initialPositionY
        spriteBall.position.x = initialPositionX
        applyFruitProfile(at: currentFruit, preservingMotion: false, affectedByGravity: false)

        leg.zRotation = rotation
        leg.physicsBody?.angularVelocity = 0
        leg.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }

    func continueAfterRewardedAd() {
        showGameOver = false
        touch = false
        heightInTouch = 0
        started = true
        startGameScene = true

        spriteBall.position.y = initialPositionY
        spriteBall.position.x = initialPositionX
        applyFruitProfile(at: currentFruit, preservingMotion: false, affectedByGravity: false)

        leg.zRotation = rotation
        leg.physicsBody?.angularVelocity = 0
        leg.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }

    private func configureFruitList() {
        fruits = Self.fruitProfiles.map { $0.assetName }
    }


    private func configureLeg() {
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
    }

    private func applyFruitProfile(
        at index: Int,
        preservingMotion: Bool,
        affectedByGravity: Bool? = nil
    ) {
        guard Self.fruitProfiles.indices.contains(index) else { return }

        let profile = Self.fruitProfiles[index]
        let previousVelocity = spriteBall.physicsBody?.velocity ?? .zero
        let previousAngularVelocity = spriteBall.physicsBody?.angularVelocity ?? 0
        let previousAffectedByGravity = spriteBall.physicsBody?.affectedByGravity ?? false

        spriteBall.texture = SKTexture(imageNamed: profile.assetName)
        spriteBall.size = profile.displaySize
        spriteBall.physicsBody = makeFruitPhysicsBody(for: profile)
        spriteBall.physicsBody?.allowsRotation = true
        spriteBall.physicsBody?.affectedByGravity = affectedByGravity ?? previousAffectedByGravity
        spriteBall.physicsBody?.categoryBitMask = Self.contactCategoryBall
        spriteBall.physicsBody?.collisionBitMask = Self.contactCategoryLeg
        spriteBall.physicsBody?.contactTestBitMask = Self.contactCategoryLeg

        if preservingMotion {
            spriteBall.physicsBody?.velocity = previousVelocity
            spriteBall.physicsBody?.angularVelocity = previousAngularVelocity
        } else {
            spriteBall.physicsBody?.velocity = .zero
            spriteBall.physicsBody?.angularVelocity = 0
        }
    }

    private func makeFruitPhysicsBody(for profile: FruitPhysicsProfile) -> SKPhysicsBody {
        switch profile.bodyShape {
        case .circle(let radiusScale):
            let radius = min(profile.displaySize.width, profile.displaySize.height) * radiusScale / 2
            return SKPhysicsBody(circleOfRadius: radius)
        case .ellipse(let widthScale, let heightScale):
            return SKPhysicsBody(polygonFrom: ellipsePath(
                width: profile.displaySize.width * widthScale,
                height: profile.displaySize.height * heightScale
            ))
        }
    }

    private func ellipsePath(width: CGFloat, height: CGFloat) -> CGPath {
        let path = CGMutablePath()
        let pointCount = 12
        let radiusX = width / 2
        let radiusY = height / 2

        for index in 0..<pointCount {
            let angle = CGFloat(index) / CGFloat(pointCount) * CGFloat.pi * 2
            let point = CGPoint(x: cos(angle) * radiusX, y: sin(angle) * radiusY)
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        path.closeSubpath()
        return path
    }

    private static func roundFruit(_ assetName: String, width: CGFloat, height: CGFloat) -> FruitPhysicsProfile {
        FruitPhysicsProfile(
            assetName: assetName,
            displaySize: normalizedSize(width: width, height: height),
            bodyShape: .circle(radiusScale: 0.9)
        )
    }

    private static func tallFruit(_ assetName: String, width: CGFloat, height: CGFloat) -> FruitPhysicsProfile {
        FruitPhysicsProfile(
            assetName: assetName,
            displaySize: normalizedSize(width: width, height: height),
            bodyShape: .ellipse(widthScale: 0.82, heightScale: 0.94)
        )
    }

    private static func wideFruit(_ assetName: String, width: CGFloat, height: CGFloat) -> FruitPhysicsProfile {
        FruitPhysicsProfile(
            assetName: assetName,
            displaySize: normalizedSize(width: width, height: height),
            bodyShape: .ellipse(widthScale: 0.95, heightScale: 0.76)
        )
    }

    private static func normalizedSize(width: CGFloat, height: CGFloat) -> CGSize {
        let maxDimension: CGFloat = 56
        let scale = maxDimension / max(width, height)
        return CGSize(width: width * scale, height: height * scale)
    }
}
