//
//  GameOverView.swift
//  fruitball
//
//  Created by Diego Henrick on 06/04/24.
//

import SwiftUI
import GameKit

struct GameOverView: View {

    @State var highscore = UserDefaults.standard.integer(forKey: "highscore")
        
    @State var showGameSceneView = false
    
    @State var score: Int
    
    @Environment(\.dismiss) var dismiss

    let gameService = GameService()
    var body: some View {
            ZStack {
                Spacer()

                ZStack {
                    VStack{
                        Spacer()
                        Image("chaoCampo")
                            .onTapGesture {
                                dismiss()
                            }
                    }
                    HStack{
                        Image("legTorto")
                            .rotationEffect(.degrees(-45))
                            .frame(width: 0, height: 100)
                            .padding(.trailing, 300)
                            .padding(.top, 140)
                        Spacer()
                        VStack{
                            Spacer()
                            Image("Group-0")
                                .resizable()
                                .frame(width: 80, height: 90)
                                .padding(.trailing, 100)
                                .padding(.bottom, 100)
                        }
                    }

                }
                VStack {
                    Image("GameOver")
                    VStack(alignment: .center, spacing: -50) {
                        
                        VStack(alignment: .center, spacing: -25) {
                            Text(String(score))
                                .font(.custom("SigmarOne-Regular", size: 140))
                                .foregroundStyle(Color.white)
                                .frame(height: 150)
                                .shadow(radius: 4)
                            Text("SCORE")
                                .font(.custom("SigmarOne-Regular", size: 40))
                                .foregroundStyle(Color("Brown"))
                                .shadow(radius: 4)
                        }
                        VStack(alignment: .center, spacing: -40) {
                            Text(String(highscore))
                                .font(.custom("SigmarOne-Regular", size: 80))
                                .foregroundStyle(Color.white)
                                .frame(height: 150)
                                .shadow(radius: 4)
                            Text("HIGHSCORE")
                                .font(.custom("SigmarOne-Regular", size: 20))
                                .foregroundStyle(Color("Brown"))
                                .shadow(radius: 4)
                        }
                    }
                        HStack() {
                            Button(action: {
                                gameService.showLeaderboard()
                            }, label: {
                                Image("BottunBrownLeaderboard")
                                    .padding(.trailing, 24)
                            })
                            NavigationLink(
                                destination: GameSceneView()
                                    .navigationBarBackButtonHidden(true),
                                label: {
                                    Image("ButtonBrownPlay")
                                        .padding(.leading, 24)
                                }
                            )
                        }

                        Spacer()

                }
                .padding(.top, 80)
            }.background(){
                Color("Yellow")
            }
            .ignoresSafeArea(.all)
            .onAppear(){
                UserDefaults.standard.synchronize()
                highscore = UserDefaults.standard.integer(forKey: "highscore")
        }
    }
}
