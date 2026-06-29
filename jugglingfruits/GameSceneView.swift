//
//  GameSceneView.swift
//
//  Created by Diego Henrick on 19/03/24.
//

import SwiftUI
import SpriteKit

struct GameSceneView: View {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    private let gameplayBannerHorizontalPadding: CGFloat = 24
     
    @State var showGameOver = false
    @State var score = 0
    @State private var isScaled = false
    @State private var scene: GameScene?
    @State private var usedRewardedContinue = false
    
    var body: some View {
        ZStack {
            if let scene {
                SpriteView(scene: scene)
                    .frame(width: screenWidth, height: screenHeight, alignment: .center)
                    .edgesIgnoringSafeArea(.all)
            }

            VStack {
                Spacer()
                Text(String(score))
                    .font(.custom("SigmarOne-Regular", size: isScaled ? 165 * 1.5 : 165))
                    .padding(.bottom, 420)
                    .foregroundStyle(Color.white)
                    .shadow(radius: 8)
                    .onChange(of: score) { _ in
                        showScoreAnimation()
                    }
                Spacer()
            }

            if !showGameOver {
                VStack {
                    BannerAdView(width: screenWidth - (gameplayBannerHorizontalPadding * 2))
                        .frame(
                            width: screenWidth - (gameplayBannerHorizontalPadding * 2),
                            height: 64
                        )
                        .padding(.top, 28)
                    Spacer()
                }
            }

            if showGameOver {
                GameOverView(score: score, canUseRewardedContinue: !usedRewardedContinue) {
                    usedRewardedContinue = false
                    scene?.restartGame()
                } onRewardedContinue: {
                    usedRewardedContinue = true
                    scene?.continueAfterRewardedAd()
                }
                .navigationBarBackButtonHidden(true)
            }
        }
        .onAppear {
            guard scene == nil else { return }

            let newScene = GameScene(
                size: CGSize(width: 288, height: 512),
                showGameOver: $showGameOver,
                score: $score
            )
            newScene.scaleMode = .fill
            newScene.backgroundColor = .white
            scene = newScene
        }
        .navigationBarBackButtonHidden(true)
        .background(.red)
    }
    
    func showScoreAnimation() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isScaled = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                isScaled = false
            }
        }
    }
    
}

struct GameSceneView_Previews: PreviewProvider {
    static var previews: some View {
        GameSceneView()
    }
}
