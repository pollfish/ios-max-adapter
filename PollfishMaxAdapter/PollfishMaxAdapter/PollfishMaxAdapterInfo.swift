//
//  PollfishMaxAdapterInfo.swift
//  PollfishMaxAdapter
//
//  Created by Fotis Mitropoulos on 17/2/22.
//

import Foundation


struct PollfishMaxAdapterInfo {
    let apiKey: String
    let releaseMode: Bool?
    let offerwallMode: Bool?
    let requestUUID: String?
    
    init?(remoteParams: [String : Any], localParams: [String : Any]) {
        
        if let localApiKey = localParams[Constants.ExtraKey.apiKey] as? String {
            apiKey = localApiKey
        } else if let remoteApiKey = remoteParams[Constants.ExtraKey.apiKey] as? String {
            apiKey = remoteApiKey
        } else {
            return nil
        }
        
        if let localReleaseMode = localParams[Constants.ExtraKey.releaseMode] as? Bool {
            releaseMode = localReleaseMode
        } else {
            releaseMode = remoteParams[Constants.ExtraKey.releaseMode] as? Bool
        }
        
        if let localOfferwallMode = localParams[Constants.ExtraKey.offerwallMode] as? Bool {
            offerwallMode = localOfferwallMode
        } else {
            offerwallMode = remoteParams[Constants.ExtraKey.offerwallMode] as? Bool
        }
        
        if let localRequestUUID = localParams[Constants.ExtraKey.requestUUID] as? String {
            requestUUID = localRequestUUID
        } else {
            requestUUID = remoteParams[Constants.ExtraKey.requestUUID] as? String
        }
        
    }
}
