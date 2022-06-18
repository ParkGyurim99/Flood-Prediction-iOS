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
    
    func getDate() -> String{
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "YYYY.MM.dd. hh:mm a"
        let stringDate = timeFormatter.string(from: time)
        return stringDate
    }
    
    var Location : some View {
        VStack {
            Button {
                withAnimation {
                    viewModel.showLogInModal = false
                    viewModel.showDistrictSelector.toggle()
                }
            } label : {
                HStack {
                    Text(selectedDistrict.rawValue)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    Image(systemName: "chevron.down").foregroundColor(.gray)
                    Spacer()
                }.padding(.horizontal)
                    .foregroundColor(.black)
            }
            
            Divider()
        }
    }
    
    var PredictionInformation : some View {
        VStack(alignment : .trailing) {
            Text(getDate() + " 기준")
                .foregroundColor(.gray)
                .padding(.horizontal)
                .font(.subheadline)
            Text(viewModel.predictionTitle)
                .padding()
                .frame(maxWidth : .infinity)
                .background(viewModel.predictionColor)
                .cornerRadius(10)
                .padding()
                .overlay(Color.gray.opacity(viewModel.fetchPredictionDone ? 0 : 1))

            HStack {
                NavigationLink(destination : Text("")) {
                    Text("인근 지역 정보")
                        .foregroundColor(.gray)
                    Image(systemName : "chevron.right")
                }.font(.subheadline)
                .padding(.horizontal)
                
                Spacer()
                
                Button {
                    
                } label : {
                    HStack {
                        Text("새로고침")
                        Image(systemName: "arrow.clockwise.circle.fill")
                    }.foregroundColor(.gray)
                    .padding(.horizontal)
                }
            }
            
            Divider()
        }.onChange(of: selectedDistrict) { viewModel.getPredictionStatus(district: $0) }
    }
    
    var RelatedInformation : some View {
        VStack {
            Text("View More")
            
            Divider()
        }.padding()
    }
    
    var ContactInformation : some View {
        VStack {
            Text("Number #1")
            Text("Number #2")
            Text("Number #3")
        }.padding()
    }
    
    var body: some View {
        ZStack(alignment : .bottom) {
            VStack {
                Location
                PredictionInformation
                RelatedInformation
                ContactInformation
                
                Spacer()
            }.toolbar {
                Button {
                    withAnimation {
                        viewModel.showDistrictSelector = false
                        viewModel.showLogInModal.toggle()
                    }
                } label : {
                    HStack(spacing : 5) {
                        Image(systemName: "bell.circle.fill")
                        Text("알림 등록").font(.callout)
                    }.foregroundColor(.gray)
                }
            }
            
            if viewModel.showLogInModal {
                VStack {
                    Button {
                        withAnimation { viewModel.showLogInModal = false }
                    } label : {
                        HStack {
                            Text("현재 위치 위험 알림 등록").font(.headline).foregroundColor(.black)
                            Image(systemName: "chevron.down").foregroundColor(.gray)
                        }
                    }
                    Divider()
                    Button {
                        UserService.shared.kakaoLogin()
                    } label : {
                        Image("kakao_login")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(20)
                    }.frame(maxWidth : .infinity)
                    .padding()
                }
                .frame(width : UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.2)
                .background(Color.systemDefaultGray)
                .cornerRadius(15)
                .shadow(radius: 2)
                .zIndex(5)
                .transition(.move(edge: .bottom))
            }
            
            if viewModel.showDistrictSelector {
                VStack {
                    Button {
                        withAnimation { viewModel.showDistrictSelector = false }
                    } label : {
                        HStack {
                            Text("현재 위치 설정").font(.headline).foregroundColor(.black)
                            Image(systemName: "chevron.down").foregroundColor(.gray)
                        }
                    }
                    Divider()
                    Picker(selection: $selectedDistrict) {
                        ForEach(District.allCases, id : \.self) {
                            Text($0.rawValue)
                        }
                    } label: { }.pickerStyle(.wheel)
                }.padding(.vertical)
                .background(Color.systemDefaultGray)
                .cornerRadius(15)
                .shadow(radius: 2)
                .zIndex(5)
                .transition(.move(edge: .bottom))
            }
        }.edgesIgnoringSafeArea(.bottom)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.getPredictionData() }
        .onChange(of: viewModel.fetchPredictionDone) { _ in
            viewModel.getPredictionStatus(district: selectedDistrict)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
