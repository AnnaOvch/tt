//
//  ContentView.swift
//  TestTask
//
//  Created by Anna Ovchynnykova on 17.10.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.green.ignoresSafeArea()
                ZStack {
                    Color.white
                    NavigationLink(destination: MapView(locationViewModel: LocationViewModel())) {
                        Text("Show map with doctos and labs near me")
                    }
                }
            }
            .navigationTitle("Test Task")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
