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
     
    @State var showGameOver = false
    @State var path = NavigationPath()
    @State var score = 0
    @State private var isScaled = false
    var scene: SKScene {
        let scene = GameScene(size: CGSize(width: 288, height: 512), showGameOver: $showGameOver, score: $score)
        
        scene.scaleMode = .fill
        scene.backgroundColor = .white
        
        return scene
    }
    
    var body: some View {
            ZStack {
                                
                SpriteView(scene: scene)
                    .frame(width: screenWidth, height: screenHeight, alignment: .center)
                    .edgesIgnoringSafeArea(.all)
                NavigationLink(
                    destination: GameOverView(score: score)
                        .navigationBarBackButtonHidden(true),
                    isActive: $showGameOver,
                    label: { Text("") }
                )
                VStack{
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
            }
            .navigationBarBackButtonHidden(true)
            .background(.red)
        }
    
    func showScoreAnimation() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isScaled = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation() {
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
