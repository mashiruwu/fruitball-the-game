//
//  AdMobManager.swift
//  jugglingfruits
//

import GoogleMobileAds
import SwiftUI

@MainActor
final class AdMobManager: NSObject, ObservableObject {
    static let shared = AdMobManager()

    @Published private(set) var rewardedAdIsReady = false

    private var interstitialAd: InterstitialAd?
    private var rewardedAd: RewardedAd?
    private var gameOverCount = 0

    private override init() {
        super.init()
    }

    func start() {
        guard AdMobConfig.isConfigured else {
            print("AdMob App ID is missing. Replace GADApplicationIdentifier in Info.plist before loading ads.")
            return
        }

        MobileAds.shared.start { [weak self] _ in
            Task { @MainActor in
                self?.loadInterstitial()
                self?.loadRewarded()
            }
        }
    }

    func showInterstitialAfterGameOverIfNeeded() {
        guard AdMobConfig.isConfigured else { return }

        gameOverCount += 1
        guard gameOverCount % 3 == 0 else { return }
        guard let rootViewController, let interstitialAd else {
            loadInterstitial()
            return
        }

        interstitialAd.present(from: rootViewController)
        self.interstitialAd = nil
        loadInterstitial()
    }

    func showRewardedContinue(onReward: @escaping () -> Void) {
        guard AdMobConfig.isConfigured else { return }
        guard let rootViewController, let rewardedAd else {
            loadRewarded()
            return
        }

        rewardedAd.present(from: rootViewController) { [weak self] in
            onReward()
            self?.rewardedAd = nil
            self?.rewardedAdIsReady = false
            self?.loadRewarded()
        }
    }

    func loadInterstitial() {
        guard AdMobConfig.isConfigured else { return }

        InterstitialAd.load(
            with: AdMobConfig.interstitialAdUnitID,
            request: Request()
        ) { [weak self] ad, error in
            Task { @MainActor in
                if let error {
                    print("Failed to load interstitial ad: \(error.localizedDescription)")
                    return
                }

                self?.interstitialAd = ad
            }
        }
    }

    func loadRewarded() {
        guard AdMobConfig.isConfigured else { return }

        RewardedAd.load(
            with: AdMobConfig.rewardedAdUnitID,
            request: Request()
        ) { [weak self] ad, error in
            Task { @MainActor in
                if let error {
                    print("Failed to load rewarded ad: \(error.localizedDescription)")
                    self?.rewardedAdIsReady = false
                    return
                }

                self?.rewardedAd = ad
                self?.rewardedAdIsReady = true
            }
        }
    }

    private var rootViewController: UIViewController? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }?
            .rootViewController
    }
}
