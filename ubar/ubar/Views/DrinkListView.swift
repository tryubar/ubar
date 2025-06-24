//
//  DrinkListView.swift
//  ubar
//
//  Created by Ranjan Biswas on 6/24/25.
//

import SwiftUI

struct DrinkListView: View {
    @StateObject private var viewModel = DrinkViewModel()
    @State private var selectedCategory: DrinkCategory = .cocktail
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                
                // Category Picker
                if viewModel.searchText.isEmpty {
                    CategoryPicker(selectedCategory: $selectedCategory)
                        .padding(.horizontal)
                        .onChange(of: selectedCategory) { category in
                            viewModel.loadDrinks(by: category)
                        }
                }
                
                // Content
                if viewModel.isLoading {
                    ProgressView("Loading drinks...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    ErrorView(message: errorMessage) {
                        if viewModel.searchText.isEmpty {
                            viewModel.loadDrinks(by: selectedCategory)
                        } else {
                            viewModel.searchDrinks(query: viewModel.searchText)
                        }
                    }
                } else if viewModel.drinks.isEmpty && !viewModel.searchText.isEmpty {
                    EmptyStateView(message: "No drinks found for '\(viewModel.searchText)'")
                } else {
                    DrinkGrid(drinks: viewModel.drinks)
                }
                
                Spacer()
            }
            .navigationTitle("UBar")
            .onAppear {
                if viewModel.drinks.isEmpty && viewModel.searchText.isEmpty {
                    viewModel.loadDrinks(by: selectedCategory)
                }
            }
        }
    }
}

// MARK: - Search Bar
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search drinks...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

// MARK: - Category Picker
struct CategoryPicker: View {
    @Binding var selectedCategory: DrinkCategory
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(DrinkCategory.allCases, id: \.self) { category in
                    CategoryChip(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Category Chip
struct CategoryChip: View {
    let category: DrinkCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category.displayName)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.2))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

// MARK: - Drink Grid
struct DrinkGrid: View {
    let drinks: [Drink]
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(drinks) { drink in
                    DrinkCard(drink: drink)
                }
            }
            .padding()
        }
    }
}

// MARK: - Drink Card
struct DrinkCard: View {
    let drink: Drink
    @State private var showingDetail = false

    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            VStack(alignment: .leading, spacing: 8) {
                // Drink Image
                AsyncImageView(url: drink.imageURL, placeholder: "wineglass")
                    .frame(height: 120)
                    .clipped()

                VStack(alignment: .leading, spacing: 4) {
                    Text(drink.name)
                        .font(.headline)
                        .lineLimit(2)
                        .foregroundColor(.primary)

                    Text(drink.category.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    if let price = drink.price {
                        Text("$\(price, specifier: "%.2f")")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            DrinkDetailView(drink: drink)
        }
    }
}

// MARK: - Error View
struct ErrorView: View {
    let message: String
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            Text("Oops!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button("Try Again", action: retry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .foregroundColor(.gray)
            
            Text("No Results")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    DrinkListView()
}
