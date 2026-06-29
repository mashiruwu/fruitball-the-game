//
//  AdMobConfig.swift
//  jugglingfruits
//

import Foundation

enum AdMobConfig {
    static let bannerAdUnitID = "ca-app-pub-2782621432038890/4981476662"
    static let interstitialAdUnitID = "ca-app-pub-2782621432038890/6114953720"
    static let rewardedAdUnitID = "ca-app-pub-2782621432038890/5775725146"

    static var isConfigured: Bool {
        guard let appID = Bundle.main.object(forInfoDictionaryKey: "GADApplicationIdentifier") as? String else {
            return false
        }

        return appID.contains("~") && !appID.contains("REPLACE")
    }
}
