//
//  Flood_PredictionApp.swift
//  Flood Prediction
//
//  Created by Park Gyurim on 2022/06/18.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

@main
struct Flood_PredictionApp: App {
    init() {
        // INIT Kakao SDK
        KakaoSDK.initSDK(appKey: "5999200bd2791859bfa2ab7f781dcf89")

        // Check Kakao accessToken is available and then login with access token
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true { } //로그인 필요
                    else { print(error.localizedDescription) }
                } else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    print("Login with Kakao")
                    
                    guard let token = TokenManager.manager.getToken() else { return }
                    UserService.shared.loginType = .kakao
                    UserService.shared.oAuthLogIn(oAuthProvider : .kakao , accessToken : token.accessToken)
                }
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}
