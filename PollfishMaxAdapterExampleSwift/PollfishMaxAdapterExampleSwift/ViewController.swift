//
//  ViewController.swift
//  PollfishMaxAdapterExampleSwift
//
//  Created by Fotis Mitropoulos on 16/2/22.
//

import UIKit
import AdSupport
import AppLovinSDK
#if canImport(AppTrackingTransparency)
import AppTrackingTransparency
#endif

class ViewController: UIViewController, MARewardedAdDelegate {
    let adUnitId = "YOUR_AD_UNIT"
    
    var rewardedAd: MARewardedAd!
    var retryAttempt = 0.0
    
    @IBOutlet weak var showRewardedAdButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 14, *) {
            requestIDFAPermission()
        } else {
            createRewardedAd()
        }
    }
    
    @available(iOS 14, *)
    func requestIDFAPermission() {
        #if canImport(AppTrackingTransparency)
        ATTrackingManager.requestTrackingAuthorization { status in
            DispatchQueue.main.async {
                self.createRewardedAd()
            }
        }
        #endif
    }
    
    func createRewardedAd() {
        rewardedAd = MARewardedAd.shared(withAdUnitIdentifier: adUnitId)
        
        // Optional parameters, if have already been set in the AppLovin dashboard
        // In case you've already set them in the Dashboard, params in code will override the ones you've already set
        rewardedAd.setLocalExtraParameterForKey("release_mode", value: false)
        rewardedAd.setLocalExtraParameterForKey("offerwall_mode", value: true)
        rewardedAd.setLocalExtraParameterForKey("request_uuid", value: "REQUEST_UUID")
        rewardedAd.setLocalExtraParameterForKey("api_key", value: "YOUR_API_KEY")
        
        rewardedAd.delegate = self
        rewardedAd.load()
        showRewardedAdButton.isEnabled = false
        print(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
    }

    @IBAction func onRewardedAdClick(_ sender: Any) {
        if (rewardedAd.isReady) {
            rewardedAd.show()
        }
    }
    
    func didLoad(_ ad: MAAd) {
        retryAttempt = 0
        showRewardedAdButton.isEnabled = true
    }

    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        retryAttempt += 1
        
        let delaySec = pow(2.0, min(6.0, retryAttempt))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delaySec) {
            self.rewardedAd.load()
        }
    }

    func didDisplay(_ ad: MAAd) {}

    func didClick(_ ad: MAAd) {}

    func didHide(_ ad: MAAd) {
        rewardedAd.load()
    }

    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        rewardedAd.load()
    }

    func didStartRewardedVideo(for ad: MAAd) {}

    func didCompleteRewardedVideo(for ad: MAAd) {}

    func didRewardUser(for ad: MAAd, with reward: MAReward) {
        print("Reward received: \(reward.amount) \(reward.label)")
    }

}

