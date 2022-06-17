//
//  ContentView.swift
//  Flood Prediction
//
//  Created by Park Gyurim on 2022/06/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Circle()
                    .frame(width : UIScreen.main.bounds.width * 0.7)
                    .foregroundColor(.green)
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
        ContentView()
    }
}
