//
//  RequestInterceptor.swift
//  Flood Prediction
//
//  Created by Park Gyurim on 2022/06/18.
//

import Foundation
import Alamofire

class authorizationInterceptor : RequestInterceptor {
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
//        var urlRequest = urlRequest
//        guard let userInfo = UserService.shared.userInfo else { return }
//
//        //print("-- Attaching authentication header")
//        urlRequest.headers.add(
//            name: "X-AUTH-TOKEN",
//            value: userInfo.token.tokenType + " " + userInfo.token.accessToken
//        )
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void
    ) {
        guard let statusCode = request.response?.statusCode else { return }
        print("status code catched by retrier : \(statusCode)")
        
        //MARK: 403 - Authentication Error (Expired AccessToken)
        if statusCode == 403 {
            UserService.shared.refreshToken { result in
                switch result {
                    case .success(true) :
                        completion(.retryWithDelay(TimeInterval(1.0)))
                    case .success(false) :
                        print("Token refresh error - Expired refresh token error")
                        UserService.shared.userInfo = nil
                        UserService.shared.loginType = nil
                    case let .failure(error) :
                        print("Retry error : " + error.localizedDescription)
                }
            }
        } else { completion(.doNotRetry) }
    }
}

