//
//  PollfishMaxAdapterInfo.swift
//  PollfishMaxAdapter
//
//  Created by Fotis Mitropoulos on 17/2/22.
//

import Foundation
import AppLovinSDK

struct PollfishMaxAdapterInfo: CustomStringConvertible {
    let apiKey: String
    let releaseMode: Bool?
    let requestUUID: String?
    let userId: String?
    let surveyFormat: Int?
    
    var description: String {
        get {
            "{api_key: \(apiKey), release_mode: \(releaseMode ?? false), request_uuid: \(String(describing: requestUUID)), survey_format: \(String(describing: surveyFormat))}"
        }
    }
    
    init?(_ parameters: MAAdapterResponseParameters) {
        let remoteParams = parameters.serverParameters[Constants.ExtraKey.remoteParams] as? [String: Any]
        
        if let localApiKey = parameters.localExtraParameters[Constants.ExtraKey.apiKey] as? String, !localApiKey.trimmingCharacters(in: .whitespaces).isEmpty {
            apiKey = localApiKey
        } else if let remoteApiKey = remoteParams?[Constants.ExtraKey.apiKey] as? String, !remoteApiKey.trimmingCharacters(in: .whitespaces).isEmpty {
            apiKey = remoteApiKey
        } else if !parameters.thirdPartyAdPlacementIdentifier.trimmingCharacters(in: .whitespaces).isEmpty {
            apiKey = parameters.thirdPartyAdPlacementIdentifier
        } else {
            return nil
        }
        
        if let localReleaseMode = parameters.localExtraParameters[Constants.ExtraKey.releaseMode] as? Bool {
            releaseMode = localReleaseMode && !parameters.isTesting
        } else {
            releaseMode = (remoteParams?[Constants.ExtraKey.releaseMode] as? Bool ?? false) && !parameters.isTesting
        }
        
        if let localRequestUUID = parameters.localExtraParameters[Constants.ExtraKey.requestUUID] as? String, !localRequestUUID.trimmingCharacters(in: .whitespaces).isEmpty {
            requestUUID = localRequestUUID
        } else if let remoteRequestUUID = remoteParams?[Constants.ExtraKey.requestUUID] as? String, !remoteRequestUUID.trimmingCharacters(in: .whitespaces).isEmpty {
            requestUUID = remoteRequestUUID
        } else {
            requestUUID = nil
        }
        
        if let localUserId = parameters.localExtraParameters[Constants.ExtraKey.userId] as? String, !localUserId.trimmingCharacters(in: .whitespaces).isEmpty {
            userId = localUserId
        } else {
            userId = nil
        }
        
        if let localSurveyFormat = parameters.localExtraParameters[Constants.ExtraKey.surveyFormat] as? Int, (0...4).contains(localSurveyFormat) {
            surveyFormat = localSurveyFormat
        } else if let remoteSurveyFormat = remoteParams?[Constants.ExtraKey.surveyFormat] as? Int, (0...4).contains(remoteSurveyFormat) {
            surveyFormat = remoteSurveyFormat
        } else {
            surveyFormat = nil
        }
        
    }
}
