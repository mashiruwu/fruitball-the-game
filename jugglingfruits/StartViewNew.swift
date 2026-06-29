//
//  StartViewNew.swift
//  fruitball
//
//  Created by Diego Henrick on 16/04/24.
//

import SwiftUI


struct StartViewNew: View {
    let gameService = GameService()
    
    var body: some View {
        NavigationStack {
            
            VStack{
                Spacer()
                Image("LogoJuggleFruits")
                Spacer()
                HStack{
                    Button(action: {
                        gameService.showLeaderboard()
                        
                    }, label: {
                        Image("BottunBrownLeaderboard")
                    })
                    .padding(.trailing, 24)
                    
                    NavigationLink(destination: GameSceneView().navigationBarBackButtonHidden(true)) {
                        Image("ButtonBrownPlay")
                    }
                    .padding(.leading, 24)
                    .navigationBarBackButtonHidden(true)
                }
                .padding(.bottom, 24)
                BannerAdView(width: 320)
                    .frame(width: 320, height: 50)
                Spacer()
            }.background(Color("Yellow"))
                .onAppear() {
                    gameService.authenticate { error in
                        if let error = error {
                            print("Erro ao autenticar: \(error)")
                        } else {
                            print("Autenticação bem-sucedida!")
                        }
                    }
                }
        }

    }
}

#Preview {
    StartViewNew()
}
