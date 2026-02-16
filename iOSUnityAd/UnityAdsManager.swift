//
//  UnityAdsManager.swift
//  iOSUnityAd
//
//  Created by Rick Cheng on 2/15/26.
//

import Foundation
import Combine
import UnityAds
import UIKit

class UnityAdsManager: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    // Replace with your Unity Ads Game ID from unity.com/ads
    // For testing, you can use: "1487511" (Unity's test game ID)
    private let gameID = "3003911"
    
    // Your placement ID (created in Unity Ads dashboard)
    private let placementID = "video"
    
    @Published var adState: String = "Not Loaded"
    @Published var isAdReady: Bool = false
    
    // Store view controller reference
    private weak var viewController: UIViewController?
    
    // MARK: - Initialization
    
    override init() {
        super.init()
    }
    
    /// Set the view controller to use for showing ads
    func setViewController(_ vc: UIViewController) {
        self.viewController = vc
    }
    
    // MARK: - Public Methods
    
    /// Initialize Unity Ads SDK
    func initialize() {
        UnityAds.initialize(gameID, testMode: true, initializationDelegate: self)
        adState = "Initializing..."
    }
    
    /// Load an interstitial ad
    func loadAd() {
        guard UnityAds.isInitialized() else {
            adState = "SDK not initialized"
            return
        }
        
        adState = "Loading ad..."
        UnityAds.load(placementID, loadDelegate: self)
    }
    
    /// Show the loaded ad
    func showAd() {
        guard isAdReady else {
            adState = "Ad not ready"
            return
        }
        
        guard let vc = viewController else {
            adState = "View controller not set"
            return
        }
        
        adState = "Showing ad..."
        UnityAds.show(vc, placementId: placementID, showDelegate: self)
    }
}

// MARK: - UnityAdsInitializationDelegate

extension UnityAdsManager: UnityAdsInitializationDelegate {
    func initializationComplete() {
        DispatchQueue.main.async {
            self.adState = "Initialized"
        }
    }
    
    func initializationFailed(_ error: UnityAdsInitializationError, withMessage message: String) {
        DispatchQueue.main.async {
            self.adState = "Init Failed: \(message)"
        }
    }
}

// MARK: - UnityAdsLoadDelegate

extension UnityAdsManager: UnityAdsLoadDelegate {
    func unityAdsAdLoaded(_ placementId: String) {
        DispatchQueue.main.async {
            self.isAdReady = true
            self.adState = "Ad Ready"
        }
    }
    
    func unityAdsAdFailed(toLoad placementId: String, withError error: UnityAdsLoadError, withMessage message: String) {
        DispatchQueue.main.async {
            self.isAdReady = false
            self.adState = "Load Failed: \(message)"
        }
    }
}

// MARK: - UnityAdsShowDelegate

extension UnityAdsManager: UnityAdsShowDelegate {
    func unityAdsShowStart(_ placementId: String) {
        DispatchQueue.main.async {
            self.adState = "Ad showing..."
        }
    }
    
    func unityAdsShowClick(_ placementId: String) {
        DispatchQueue.main.async {
            self.adState = "Ad clicked"
        }
    }
    
    func unityAdsShowComplete(_ placementId: String, withFinish state: UnityAdsShowCompletionState) {
        DispatchQueue.main.async {
            self.isAdReady = false
            switch state {
            case .showCompletionStateCompleted:
                self.adState = "Ad completed"
            case .showCompletionStateSkipped:
                self.adState = "Ad skipped"
            @unknown default:
                self.adState = "Ad finished"
            }
        }
    }
    
    func unityAdsShowFailed(_ placementId: String, withError error: UnityAdsShowError, withMessage message: String) {
        DispatchQueue.main.async {
            self.adState = "Show Failed: \(message)"
        }
    }
}

