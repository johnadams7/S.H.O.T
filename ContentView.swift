//
//  ContentView.swift
//  S.H.O.T.
//
//  Created by John Adams on 2/4/20.
//  Copyright © 2020 John Adams. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            Text("My Shot")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("first")
                        Text("My Shot")
                    }
                }
                .tag(0)
            Text("Locker Room")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("Locker")
                    }
                    
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
