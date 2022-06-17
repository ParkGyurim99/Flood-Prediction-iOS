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
import NaverThirdPartyLogin

@main
struct Flood_PredictionApp: App {
    init() {
        // --------------------- //
        // ----- INIT SDKs ----- //
        // --------------------- //
        
        // Kakao SDK
        KakaoSDK.initSDK(appKey: "5999200bd2791859bfa2ab7f781dcf89")
        
        // Naver SDK
        NaverThirdPartyLoginConnection.getSharedInstance()?.isNaverAppOauthEnable = true // 네이버 앱으로 로그인 허용
        NaverThirdPartyLoginConnection.getSharedInstance()?.isInAppOauthEnable = true // 브라우저 로그인 허용
        
        NaverThirdPartyLoginConnection.getSharedInstance().setOnlyPortraitSupportInIphone(true)
        
        NaverThirdPartyLoginConnection.getSharedInstance().serviceUrlScheme = kServiceAppUrlScheme
        NaverThirdPartyLoginConnection.getSharedInstance().consumerKey = kConsumerKey
        NaverThirdPartyLoginConnection.getSharedInstance().consumerSecret = kConsumerSecret
        NaverThirdPartyLoginConnection.getSharedInstance().appName = kServiceAppName
        
        // --------------------- //
        // ----- AutoLogin ----- //
        // --------------------- //
        
        // Check Kakao accessToken
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
        
        // Check Naver accessToken
        if NaverThirdPartyLoginConnection.getSharedInstance().isValidAccessTokenExpireTimeNow() {
            //print("NAVER TOKEN EXPIRED IN")
            //print(NaverThirdPartyLoginConnection.getSharedInstance().accessTokenExpireDate)
            
            print("Login with Naver")
            
            UserService.shared.loginType = .naver
            UserService.shared.oAuthLogIn(oAuthProvider: .naver, accessToken: NaverThirdPartyLoginConnection.getSharedInstance().accessToken)
        }
//        else {
//            NaverThirdPartyLoginConnection.getSharedInstance().requestAccessTokenWithRefreshToken()
//        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    } else if NaverThirdPartyLoginConnection.getSharedInstance().isNaverThirdPartyLoginAppschemeURL(url) {
                        print("Received URL :", url)
                        NaverThirdPartyLoginConnection.getSharedInstance().receiveAccessToken(url)
                    }
                }
        }
    }
}
