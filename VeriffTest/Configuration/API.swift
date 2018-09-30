//
//  API.swift
//  VeriffTest
//
//  Created by Vahe on 9/28/18.
//  Copyright © 2018 Vahe. All rights reserved.
//

import Foundation

struct API {
    static let scheme = "https"
    static let endpoint = "/v1/"
    
    enum Host {
        case sandbox
        case staging
        case magic
        
        var host: String {
            switch self {
            case .sandbox:
                return "sandbox.veriff.me"
            case .staging:
                return "staging.veriff.me"
            case .magic:
                return "magic.veriff.me"
            }
        }
    }
    
    static func createUrl(hosting: Host) -> String {
        var urlComponent = URLComponents()
        urlComponent.scheme = scheme
        urlComponent.host = hosting.host
        urlComponent.path = endpoint
        guard let url = urlComponent.url else {
            fatalError("Error with creation of url.")
        }
        return url.absoluteString
    }
}
