//
//  MainViewModel.swift
//  Flood Prediction
//
//  Created by Park Gyurim on 2022/06/18.
//

import Foundation
import Moya
import CombineMoya
import Combine

final class MainViewModel : ObservableObject {
    @Published var prediction : PredictionInfo?
    @Published var predictionStatus : PredictionStatus = .none
    
    @Published var showLogInModal : Bool = false
    
    private let provider = MoyaProvider<DataAPI>()
    private var subscription = Set<AnyCancellable>()
    
    func getPredictionData() {
        provider.requestPublisher(.getPrediction)
            .sink { completion in
                switch completion {
                    case let .failure(error) :
                        print("Get FloodPrediction Fail : " + error.localizedDescription)
                    case .finished :
                        print("Get FloodPrediction Finished")
                }
            } receiveValue: { [weak self] recievedValue in
                guard let responseData = try? recievedValue.map(DataResponse<PredictionInfo>.self) else { return }
                //print(responseData)
                self?.prediction = responseData.body
            }.store(in : &subscription)
    }
    
    func getPredictionStatus(district : District) {
        if let prediction = prediction { predictionStatus = district.getPrediction(prediction) }
        else { predictionStatus = .none }
    }
}
