//
//  PollfishMaxAdapterInfo.swift
//  PollfishMaxAdapter
//
//  Created by Fotis Mitropoulos on 17/2/22.
//

import Foundation
import AppLovinSDK

struct PollfishMaxAdapterInfo : CustomStringConvertible {
    let apiKey: String
    let releaseMode: Bool?
    let offerwallMode: Bool?
    let requestUUID: String?
    
    var description: String {
        get {
            "{api_key: \(apiKey), release_mode: \(releaseMode ?? false), offerwall_mode: \(offerwallMode ?? false), request_uuid: \(requestUUID ?? "null")}"
        }
    }
    
    init?(_ parameters: MAAdapterResponseParameters) {
        let remoteParams = parameters.serverParameters[Constants.ExtraKey.remoteParams] as? [String : Any]
        
        if let localApiKey = parameters.localExtraParameters[Constants.ExtraKey.apiKey] as? String {
            apiKey = localApiKey
        } else if let remoteApiKey = remoteParams?[Constants.ExtraKey.apiKey] as? String {
            apiKey = remoteApiKey
        } else {
            return nil
        }
        
        if let localReleaseMode = parameters.localExtraParameters[Constants.ExtraKey.releaseMode] as? Bool {
            releaseMode = localReleaseMode && !parameters.isTesting
        } else {
            releaseMode = (remoteParams?[Constants.ExtraKey.releaseMode] as? Bool ?? false) && !parameters.isTesting
        }
        
        if let localOfferwallMode = parameters.localExtraParameters[Constants.ExtraKey.offerwallMode] as? Bool {
            offerwallMode = localOfferwallMode
        } else {
            offerwallMode = remoteParams?[Constants.ExtraKey.offerwallMode] as? Bool
        }
        
        if let localRequestUUID = parameters.localExtraParameters[Constants.ExtraKey.requestUUID] as? String {
            requestUUID = localRequestUUID
        } else {
            requestUUID = remoteParams?[Constants.ExtraKey.requestUUID] as? String
        }
        
    }
}
