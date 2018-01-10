//
//  BNBServiceProvider.swift
//  blushandbow
//
//  Created by Madhavi Solanki on 19/01/17.
//  Copyright © 2017 Cyphertree Technologies Pvt LTD. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import RxSwift
import RxCocoa

public typealias BNBRequestClosure = (target: FlickrAPI, success: BNBSuccessCompletion, failure: BNBFailureCompletion)
public typealias BNBRequestUserClosure = (target: FlickrAPI, success: BNBSuccessCompletion, failure: BNBFailureCompletion)

public typealias BNBSuccessCompletion = (_ data: AnyObject) -> Void
public typealias BNBFailureCompletion = (_ error: NSError?, _ statusCode: Int?) -> Void
public typealias BNBEmptyCompletion = () -> Void

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data
    }
}


private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}


open class BNBServiceProvider {
    open static var shared: BNBServiceProvider = BNBServiceProvider()
    
    open static func endpointClosure(_ target: FlickrAPI) -> Endpoint<FlickrAPI> {
        let defaultEndpoint = RxMoyaProvider.defaultEndpointMapping(for: target)
        return defaultEndpoint.adding(newHTTPHeaderFields:  target.headers())
    }
    
    open static func endpointUserClosure(_ target: FlickrAPI) -> Endpoint<FlickrAPI> {
        let defaultEndpoint = RxMoyaProvider.defaultEndpointMapping(for: target)
        return defaultEndpoint.adding(newHTTPHeaderFields:  target.headers())
    }
    
    open static func DefaultProvider() -> RxMoyaProvider<FlickrAPI> {
        return RxMoyaProvider<FlickrAPI>(endpointClosure: BNBServiceProvider.endpointClosure, plugins: [NetworkLoggerPlugin(verbose: false, responseDataFormatter: JSONResponseDataFormatter)])
    }
    
    open static func ShareExtensionProvider() -> RxMoyaProvider<FlickrAPI> {
        return RxMoyaProvider<FlickrAPI>(endpointClosure: BNBServiceProvider.endpointClosure, plugins: [NetworkLoggerPlugin(verbose: false, responseDataFormatter: JSONResponseDataFormatter)])
    }
    open static func ShareExtensionUserProvider() -> RxMoyaProvider<FlickrAPI> {
        return RxMoyaProvider<FlickrAPI>(endpointClosure: BNBServiceProvider.endpointUserClosure, plugins: [NetworkLoggerPlugin(verbose: false, responseDataFormatter: JSONResponseDataFormatter)])
    }

    
    fileprivate struct SharedProvider {
        static var instance = BNBServiceProvider.DefaultProvider()
    }
    
    open static var oneTimeProvider: RxMoyaProvider<FlickrAPI>?
    open static var sharedProvider: RxMoyaProvider<FlickrAPI> {
        get {
            if let provider = oneTimeProvider {
                oneTimeProvider = nil
                return provider
            }
            return SharedProvider.instance
        }
        
        set (newSharedProvider) {
            SharedProvider.instance = newSharedProvider
        }
    }
}
