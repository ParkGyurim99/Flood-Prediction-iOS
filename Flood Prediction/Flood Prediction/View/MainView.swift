//
//  ContentView.swift
//  Flood Prediction
//
//  Created by Park Gyurim on 2022/06/18.
//

import SwiftUI

struct MainView : View {
    @AppStorage("District") var selectedDistrict : District = .none
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // MARK: Temp district picker
                Picker(selection: $selectedDistrict) {
                    ForEach(District.allCases, id : \.self) { Text($0.rawValue) }
                } label: {
                    Text(selectedDistrict.rawValue)
                }.onChange(of: selectedDistrict) { viewModel.getPredictionStatus(district: $0) }

                Circle()
                    .frame(width : UIScreen.main.bounds.width * 0.7)
                    .foregroundColor(.green)
                    .overlay(Text(viewModel.predictionStatus == .safe ? "Safe" : "Danger"))
                    .onTapGesture { viewModel.getPredictionData() } // MARK: Temp function call
                    
                Text("View More")
                Text("Contents")
            }.toolbar {
                Button {
                    
                } label : {
                    HStack(spacing : 5) {
                        Image(systemName: "person.circle")
                        Text("UserName").font(.headline)
                        Image(systemName: "chevron.right")
                    }.foregroundColor(.gray)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
