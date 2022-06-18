//
//  UserService.swift
//  Flood Prediction
//
//  Created by Park Gyurim on 2022/06/18.
//

import SwiftUI
import Moya
import CombineMoya
import Combine

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

enum OAuthProvider : String {
    case naver
    case kakao
}

protocol UserServiceProtocol {
    func oAuthLogIn(oAuthProvider: OAuthProvider, accessToken: String)
    func refreshToken()
    func kakaoLogin()
    func logout()
    func unlink()
}

class UserService : NSObject, ObservableObject, UserServiceProtocol {
    static let shared = UserService()
    
    @Published var userInfo : OAuthLoginResponse?
    @Published var loginType : OAuthProvider?
    
    private let provider = MoyaProvider<UserAPI>()
    private var subscription = Set<AnyCancellable>()
    
    func oAuthLogIn(oAuthProvider: OAuthProvider, accessToken: String) {
        provider.requestPublisher(.LogIn(oAuthProvider: oAuthProvider, accessToken: accessToken))
            .sink { completion in
                switch completion {
                    case let .failure(error) :
                        print("OAuth Login Fail : " + error.localizedDescription)
                    case .finished :
                        print("OAuth Login Finished")
                }
            } receiveValue: { [weak self] recievedValue in
                guard let responseData = try? recievedValue.map(OAuthLoginResponse.self) else { return }
                print(responseData)
                withAnimation { self?.userInfo = responseData }
            }.store(in : &subscription)
    }
    
    func refreshToken() { }
    
    func kakaoLogin() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                if let error = error { print(error.localizedDescription) }
                else {
                    print("loginWithKakaoTalk() success.")
                    TokenManager.manager.setToken(oauthToken)
                    
                    if let accessToken = oauthToken?.accessToken {
                        self?.loginType = .kakao
                        print("kakao access token : " + accessToken)
                        self?.oAuthLogIn(oAuthProvider: .kakao, accessToken: accessToken)
                        
                    }
                }
            }
        } else {
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id362057947"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    func logout() {
        switch loginType {
            case .kakao :
                UserApi.shared.logout { (error) in
                    if let error = error { print(error) }
                    else {
                        print("Kakao account logout() success.")
                        TokenManager.manager.deleteToken()
                        withAnimation {
                            self.loginType = nil
                            self.userInfo = nil
                        }
                    }
                }
            default : print("Unknown login type")
        }
    }
    
    func unlink() {
        switch loginType {
            case .kakao :
                UserApi.shared.unlink { (error) in
                    if let error = error { print(error) }
                    else {
                        print("Kakao account unlink() success.")
                        TokenManager.manager.deleteToken()
                        withAnimation {
                            self.loginType = nil
                            self.userInfo = nil
                        }
                    }
                }
            default : print("Unknown login type")
        }
    }

}
