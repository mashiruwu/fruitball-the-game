//
//  BannerAdView.swift
//  jugglingfruits
//

import GoogleMobileAds
import SwiftUI

struct BannerAdView: UIViewControllerRepresentable {
    let width: CGFloat

    func makeUIViewController(context: Context) -> BannerAdViewController {
        BannerAdViewController(width: width)
    }

    func updateUIViewController(_ uiViewController: BannerAdViewController, context: Context) {
        uiViewController.update(width: width)
    }
}

final class BannerAdViewController: UIViewController {
    private let bannerView = BannerView()
    private var width: CGFloat

    init(width: CGFloat) {
        self.width = width
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear

        guard AdMobConfig.isConfigured else { return }

        bannerView.adUnitID = AdMobConfig.bannerAdUnitID
        bannerView.rootViewController = self
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)

        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        bannerView.adSize = currentOrientationAnchoredAdaptiveBanner(width: width)
        bannerView.load(Request())
    }

    func update(width: CGFloat) {
        guard self.width != width else { return }

        self.width = width
        guard AdMobConfig.isConfigured else { return }

        bannerView.adSize = currentOrientationAnchoredAdaptiveBanner(width: width)
        bannerView.load(Request())
    }
}
