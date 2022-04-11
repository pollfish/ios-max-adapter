//
//  PollfishMaxAdapter.swift
//  PollfishMaxAdapter
//
//  Created by Fotis Mitropoulos on 16/2/22.
//

import Pollfish
import AppLovinSDK

@objc(PollfishMediationAdapter)
public class PollfishMediationAdapter: ALMediationAdapter, MARewardedAdapter {
    
    private weak var delegate: MARewardedAdapterDelegate?
    
    public override var adapterVersion: String {
        get {
            return Constants.version
        }
    }
    
    public override var sdkVersion: String {
        get {
            return Constants.pollfishVersion
        }
    }
    
    public override func destroy() {
        
    }
    
    public override init(sdk: ALSdk) {
        super.init(sdk: sdk)
    }
    
    public func loadRewardedAd(for parameters: MAAdapterResponseParameters, andNotify delegate: MARewardedAdapterDelegate) {
        self.delegate = delegate
        
        if (Pollfish.isPollfishPanelOpen()) {
            
            self.delegate?.didFailToLoadRewardedAdWithError(MAAdapterError.unspecified)
            return
        }
        
        if (parameters.ageRestrictedUser?.boolValue == true) {
            self.delegate?.didFailToLoadRewardedAdWithError(MAAdapterError.unspecified)
            return
        }
        
        guard let adapterInfo = PollfishMaxAdapterInfo(parameters) else {
            self.delegate?.didFailToLoadRewardedAdWithError(MAAdapterError.unspecified)
            return
        }
        
        let params = PollfishParams(adapterInfo.apiKey).rewardMode(true)
            
        if let releaseMode = adapterInfo.releaseMode {
            params.releaseMode(releaseMode)
        }

        if let offerwallMode = adapterInfo.offerwallMode {
            params.offerwallMode(offerwallMode)
        }
        
        if let requestUUID = adapterInfo.requestUUID {
            params.requestUUID(requestUUID)
        }
        
        params.platform(Platform.max)
        
        Pollfish.initWith(params, delegate: self)
    }
    
    public func showRewardedAd(for parameters: MAAdapterResponseParameters, andNotify delegate: MARewardedAdapterDelegate) {
        Pollfish.show()
    }
    
    public override func initialize(with parameters: MAAdapterInitializationParameters, completionHandler: @escaping (MAAdapterInitializationStatus, String?) -> Void) {
        completionHandler(MAAdapterInitializationStatus.doesNotApply, nil)
    }
    
}

extension PollfishMediationAdapter: PollfishDelegate {
    
    public func pollfishClosed() {
        self.delegate?.didHideRewardedAd()
    }
    
    public func pollfishOpened() {
        self.delegate?.didDisplayRewardedAd()
    }
    
    public func pollfishUserNotEligible() {
        self.delegate?.didFailToLoadRewardedAdWithError(MAAdapterError.noFill)
    }
    
    public func pollfishSurveyNotAvailable() {
        self.delegate?.didFailToLoadRewardedAdWithError(MAAdapterError.noFill)
    }
    
    public func pollfishUserRejectedSurvey() {
        self.delegate?.didHideRewardedAd()
    }
    
    public func pollfishSurveyCompleted(surveyInfo: SurveyInfo) {
        guard let rewardValue = surveyInfo.rewardValue, let rewardName = surveyInfo.rewardName else {
            self.delegate?.didRewardUser(with: MAReward(amount: MAReward.defaultAmount, label: MAReward.defaultLabel))
            return
        }
        
        self.delegate?.didRewardUser(with: MAReward(amount: rewardValue.intValue, label: rewardName))
    }
    
    public func pollfishSurveyReceived(surveyInfo: SurveyInfo?) {
        self.delegate?.didLoadRewardedAd()
    }
    
}
