//
//  ContentView.swift
//  ubar
//
//  Created by Ranjan Biswas on 6/3/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      
        VStack {
            
            Color(.black).ignoresSafeArea(edges: .all)
            Image("margarita").resizable().cornerRadius(40).aspectRatio(contentMode: .fit).padding(.all)
            Text("UBar - Drink away").font(.title).fontWeight(.bold).fontWeight(.semibold)
        }
       
        
    }
}

#Preview {
    ContentView()
}
