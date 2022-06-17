//
//  ServiceAPI.swift
//  Flood Prediction
//
//  Created by Park Gyurim on 2022/06/18.
//

import Foundation
import Moya

struct ServiceAPI {
    static let baseURL : String = "http://49.50.161.92:8081"
}

enum UserAPI {
    case LogIn(oAuthProvider : String, accessToken : String)
    case refreshToken
}

enum DataAPI {
    case getPrediction
    case getUserInfo(userID : Int)
}

extension UserAPI : TargetType {
    var baseURL: URL { URL(string: ServiceAPI.baseURL)! }
    
    var path: String {
        switch self {
            case .LogIn(oAuthProvider: let type, accessToken: _) : return "/login/oauth/" + type
            case .refreshToken : return "/token"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .LogIn(oAuthProvider: _, accessToken: _) : return .post
            case .refreshToken : return .get
        }
    }
    
    var task: Task {
        switch self {
            case .LogIn(oAuthProvider: _, accessToken: let accessToken) :
                let params : [String: String] = [ "accessToken" : accessToken ]
                return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            case .refreshToken : return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
            case .refreshToken : return [ "Content-type": "application/json", "X-AUTH-TOKEN" : "" ]
            case .LogIn(oAuthProvider: _, accessToken: _) : return [ "Content-type": "application/json" ]
        }
    }
    
    var validationType: ValidationType { .successCodes }
}

extension DataAPI : TargetType {
    var baseURL: URL { URL(string: ServiceAPI.baseURL)! }
    
    var path: String {
        switch self {
            case .getPrediction : return "/flooding"
            case .getUserInfo(userID: let id) : return "/user/info/\(id)"
        }
    }
    
    var method: Moya.Method { return .get }

    var task: Task { return .requestPlain }
    
    var headers: [String : String]? { return [ "Content-type": "application/json" ] }
    
    var validationType: ValidationType { .successCodes }
}
