//
//  GameService.swift
//  fruitball
//
//  Created by Diego Henrick on 09/04/24.
//

import Foundation
import GameKit


class GameService {
    static let shared = GameService()
    
    let player = GKLocalPlayer.local
    
    func authenticate(_ completion: @escaping (_ error: String?) -> Void?) {
        player.authenticateHandler = { vc, error in
            if (vc != nil) {
                return;
            }
            
            guard error == nil else {
                completion(error?.localizedDescription)
                return
            }
            
            completion(nil)
        }
    }
    
    func showLeaderboard() {
        if player.isAuthenticated {
            GKAccessPoint.shared.trigger(state: .leaderboards) {
                print("Acessou os leaderboard")
            }
        }
    }
    
    func submitScore(_ score: Int, ids: [String], completion: @escaping () -> Void?) {
        if player.isAuthenticated {
            GKLeaderboard.submitScore(score, context: 0, player: player, leaderboardIDs: ids) { error in
                completion()
            }
        }
    }
}

