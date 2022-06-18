//
//  MainViewModel.swift
//  Flood Prediction
//
//  Created by Park Gyurim on 2022/06/18.
//

import SwiftUI
import Moya
import CombineMoya
import Combine

final class MainViewModel : ObservableObject {
    @Published var prediction : PredictionInfo?
    @Published var predictionStatus : PredictionStatus = .none
    
    @Published var showLogInModal : Bool = false
    @Published var showDistrictSelector : Bool = false
    
    @Published var fetchPredictionDone : Bool = false
    
    var predictionTitle : String {
        switch predictionStatus {
            case .none : return "지역 선택 필요"
            case .danger : return "주의"
            case .safe : return "안전"
        }
    }
    
    var predictionColor : Color {
        switch predictionStatus {
            case .none : return .gray.opacity(0.7)
            case .danger : return .red.opacity(0.7)
            case .safe : return .green.opacity(0.7)
        }
    }
    
    private let provider = MoyaProvider<DataAPI>()
    private var subscription = Set<AnyCancellable>()
    
    func getPredictionData() {
        provider.requestPublisher(.getPrediction)
            .sink { [weak self] completion in
                switch completion {
                    case let .failure(error) :
                        print("Get FloodPrediction Fail : " + error.localizedDescription)
                    case .finished :
                        print("Get FloodPrediction Finished")
                        self?.fetchPredictionDone = true
                }
            } receiveValue: { [weak self] recievedValue in
                guard let responseData = try? recievedValue.map(DataResponse<PredictionInfo>.self) else { return }
                print(responseData)
                self?.prediction = responseData.body
            }.store(in : &subscription)
    }
    
    func getPredictionStatus(district : District) {
        if let prediction = prediction { predictionStatus = district.getPrediction(prediction) }
        else { predictionStatus = .none }
    }
}
