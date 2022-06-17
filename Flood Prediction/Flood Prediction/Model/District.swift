//
//  District.swift
//  Flood Prediction
//
//  Created by Park Gyurim on 2022/06/18.
//

import Foundation

enum PredictionStatus {
    case danger
    case safe
    case none
}

enum District : String, CaseIterable {
    case none = "지역 선택"
    
    case gongju = "공주보"
    case baekje = "백제보"
    case sejong = "세종보"
    case gangjeonggoreyong = "강정고령보"
    case gumi = "구미보"
    case nakdan = "낙단보"
    case dalseong = "달성보"
    case sangju = "상주보"
    case changneyonghaman = "창녕함안보"
    case chilgok = "칠곡보"
    
    func getPrediction(_ predictoin : PredictionInfo) -> PredictionStatus {
        var currentLocationStatus : Int = 0
        
        switch self {
            case .gongju : currentLocationStatus = predictoin.gongju
            case .baekje : currentLocationStatus = predictoin.baekje
            case .sejong : currentLocationStatus = predictoin.sejong
            case .gangjeonggoreyong : currentLocationStatus = predictoin.gangjeonggoreyong
            case .gumi : currentLocationStatus = predictoin.gumi
            case .nakdan : currentLocationStatus = predictoin.nakdan
            case .dalseong : currentLocationStatus = predictoin.dalseong
            case .sangju : currentLocationStatus = predictoin.sangju
            case .changneyonghaman : currentLocationStatus = predictoin.changneyonghaman
            case .chilgok : currentLocationStatus = predictoin.chilgok
            
            case .none: return .none
        }
        
        return currentLocationStatus == 1 ? .danger : .safe
    }
}
