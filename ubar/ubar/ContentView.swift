//
//  ContentView.swift
//  ubar
//
//  Created by Ranjan Biswas on 6/3/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var drinkViewModel = DrinkViewModel()
    @State private var showDrinkList = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(.black).ignoresSafeArea(edges: .all)

                VStack(spacing: 30) {
                    Spacer()

                    // Logo/Image Section
                    VStack(spacing: 20) {
                        Image("margarita")
                            .resizable()
                            .cornerRadius(15)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipped()

                        Text("UBar - Drink away")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }

                    // Featured Drink Section
                    if let featuredDrink = drinkViewModel.featuredDrink {
                        VStack(spacing: 12) {
                            Text("Featured Drink")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.8))

                            Text(featuredDrink.name)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)

                            Text(featuredDrink.category.displayName)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.1))
                        )
                        .padding(.horizontal)
                    }

                    Spacer()

                    // Action Buttons
                    VStack(spacing: 16) {
                        Button(action: {
                            showDrinkList = true
                        }) {
                            Text("Explore Drinks")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }

                        Button(action: {
                            drinkViewModel.loadFeaturedDrink()
                        }) {
                            Text("Get Random Drink")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
            }
        }
        .sheet(isPresented: $showDrinkList) {
            DrinkListView()
        }
        .onAppear {
            drinkViewModel.loadFeaturedDrink()
        }
    }
}

#Preview {
    ContentView()
}
