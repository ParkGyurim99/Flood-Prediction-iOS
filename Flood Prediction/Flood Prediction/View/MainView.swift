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
            NavigationLink(destination : Text("")) {
                Text("인근 지역 정보")
                Image(systemName : "chevron.right")
            }.font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            Text(viewModel.predictionTitle)
                .font(.headline)
                .padding()
                .frame(width : 150, height : 150)
                .background(viewModel.predictionColor)
                .cornerRadius(150)
                .overlay(
                    Color.gray.opacity(viewModel.fetchPredictionDone ? 0 : 1)
                        .cornerRadius(150)
                )
                .shadow(radius: 2)
                .frame(maxWidth : .infinity, alignment: .center)
                .padding()

            Button {
                
            } label : {
                HStack(spacing : 5) {
                    Text(viewModel.getDate() + "시 기준")
                        .font(.subheadline)
                    Image(systemName: "arrow.clockwise.circle.fill")
                }.foregroundColor(.gray)
                    .padding(.horizontal)
            }
        }.onChange(of: selectedDistrict) { viewModel.getPredictionStatus(district: $0) }
    }
    
    var RelatedInformation : some View {
        VStack {
            List {
                Section(header: HStack {
                                    Text("관련 기사 및 교육 정보")
                                    Spacer()
                                    Button("더보기") { }.foregroundColor(.gray)
                                }
                ) {
                    ForEach(RelatedData.dummies, id : \.self) { data in
                        HStack {
                            Text(data.title)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .font(.callout)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                
                Section(header: Text("관련 기사 및 교육 정보")) {
                    Button {
                        guard let url = URL(string: "tel://044-205-5233") else { return }
                        UIApplication.shared.open(url)
                    } label : {
                        HStack {
                            Text("행정안전부 자연재난대응과")
                                .font(.callout)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            Image(systemName: "phone.fill")
                        }
                    }
                    
                    Button {
                        guard let url = URL(string: "tel://053-230-6402") else { return }
                        UIApplication.shared.open(url)
                    } label : {
                        HStack {
                            Text("환경부 대구지방환경청")
                                .font(.callout)
                                .fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "phone.fill")
                        }
                    }
                    
                    Button {
                        guard let url = URL(string: "tel://119") else { return }
                        UIApplication.shared.open(url)
                    } label : {
                        HStack {
                            Text("119 안전신고센터")
                                .font(.callout)
                                .fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "phone.fill")
                        }
                    }
                }
            }.listStyle(.plain)
        }//.padding(.top)
    }
    
    var body: some View {
        ZStack(alignment : .bottom) {
            VStack {
                Location
                PredictionInformation
                //Spacer().frame(height: UIScreen.main.bounds.height * 0.2)
                RelatedInformation
                
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
        .background(Color.systemDefaultGray)
        .onTapGesture {
            withAnimation {
                viewModel.showLogInModal = false
                viewModel.showDistrictSelector = false
            }
        }
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
