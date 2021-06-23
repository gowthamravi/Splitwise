//
//  MainView.swift
//  SplitWise
//
//  Created by Ravikumar, Gowtham on 23/06/21.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView{
            TabView {
                ContentView()
                    .tabItem {
                        Label("ALl", systemImage: "list.dash")
                    }
                
                BookMarkView()
                    .tabItem {
                        Label("Bookmark", systemImage: "bookmark")
                    }
            }
        }.navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
