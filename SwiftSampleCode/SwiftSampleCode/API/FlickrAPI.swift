//
//  FlickrAPI.swift
//  SwiftSampleCode
//
//  Created by Madhavi Solanki on 14/06/17.
//  Copyright © 2017 Madhavi Solanki. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

public enum FlickrAPI {
    case getFlickrPhoto()
}

//key  : 122740ff27bdb091bbd2f5bfb7a1123f
//secret : 1a2d20392fbdf6fb

extension FlickrAPI: TargetType {
    
    public var baseURL: URL { return URL(string: "https://api.flickr.com/services/rest/")! }
    
    public var path: String {
        switch self {
        case .getFlickrPhoto():
            return ""
        }
        
    }
    public var method: Moya.Method {
        switch self {
        case .getFlickrPhoto:
            return .get
        }
        
    }
    public var parameters: [String: Any]? {
        switch self {
        case .getFlickrPhoto():
            return ["method":"flickr.photos.search","api_key": "122740ff27bdb091bbd2f5bfb7a1123f", "text": "flower", "per_page": "20", "format":"json","nojsoncallback":"1"]
            
            //https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=122740ff27bdb091bbd2f5bfb7a1123f&text=flower&per_page=20&format=json&nojsoncallback=1
        }
    }
    public var sampleData: Data {
        switch self {
        case .getFlickrPhoto():
            return "{\"api_key\": \"122740ff27bdb091bbd2f5bfb7a1123f\",\"text\": \"flower\", \"format\": \"json\"\"nojsoncallback\": \"1\"}".utf8Encoded
        }
    }
    public var task: Task {
        switch self {
        case .getFlickrPhoto:
            return .request
        }
    }
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    public var validate: Bool {
        return false
    }
    
    var shouldAuthorize: Bool {
        switch self {
        case .getFlickrPhoto():
            return true
        }
    }
}

public extension FlickrAPI {
    public func headers() -> [String: String] {
        let assigned: [String: String] = [
            "accept": "application/json"
        ]
        return assigned
    }
}
public func stubbedData(_ filename: String) -> NSData! {
    let bundle = Bundle.main
    let path = bundle.path(forResource: filename, ofType: "json")
    return NSData(contentsOfFile: path!)
}


// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}
extension MoyaError {
    
    func readErrorForToken()-> String {
        if let urlContent = self.response?.data {
            do {
                let jsonError = try JSONSerialization.jsonObject(with: urlContent, options:
                    JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                if let errorString = jsonError["non_field_errors"] as? NSArray {
                    print(errorString.object(at: 0))
                    return (errorString.object(at: 0) as? String)!
                }
            } catch {
                print("JSON Processing Failed")
            }
        }
        return "No error string found"
    }
    func readErrorDescription() -> String {
        if let urlContent = self.response?.data {
            do {
                let jsonError = try JSONSerialization.jsonObject(with: urlContent, options:
                    JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                if let errorString = jsonError["non_field_errors"] as? NSArray {
                    print(errorString.object(at: 0))
                    return (errorString.object(at: 0) as? String)!
                }else{
                    return self.readErrorForToken()
                }
            } catch {
                print("JSON Processing Failed")
            }
        }
        return "No error string found"
    }
    
    func nsdataToJSON(data: NSData) -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as AnyObject
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}
