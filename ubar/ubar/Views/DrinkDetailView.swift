//
//  DrinkDetailView.swift
//  ubar
//
//  Created by Ranjan Biswas on 6/24/25.
//

import SwiftUI

struct DrinkDetailView: View {
    let drink: Drink
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header Image
                    AsyncImageView(url: drink.imageURL, placeholder: "wineglass")
                        .frame(height: 250)
                        .clipped()
                        .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Title and Category
                        VStack(alignment: .leading, spacing: 8) {
                            Text(drink.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            HStack {
                                Text(drink.category.displayName)
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(8)
                                
                                Text(drink.alcoholic ? "Alcoholic" : "Non-Alcoholic")
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(drink.alcoholic ? Color.red.opacity(0.1) : Color.green.opacity(0.1))
                                    .foregroundColor(drink.alcoholic ? .red : .green)
                                    .cornerRadius(8)
                                
                                Spacer()
                                
                                if let price = drink.price {
                                    Text("$\(price, specifier: "%.2f")")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                }
                            }
                        }
                        
                        // Description
                        if !drink.description.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.headline)
                                
                                Text(drink.description)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Ingredients
                        if !drink.ingredients.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Ingredients")
                                    .font(.headline)
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                                    ForEach(drink.ingredients) { ingredient in
                                        IngredientCard(ingredient: ingredient)
                                    }
                                }
                            }
                        }
                        
                        // Instructions
                        if !drink.instructions.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Instructions")
                                    .font(.headline)
                                
                                Text(drink.instructions)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Drink Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Ingredient Card
struct IngredientCard: View {
    let ingredient: Ingredient
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(ingredient.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(2)
            
            if let measurement = ingredient.measurement, !measurement.isEmpty {
                Text(measurement)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    DrinkDetailView(
        drink: Drink(
            id: "1",
            name: "Margarita",
            description: "A classic cocktail made with tequila, lime juice, and orange liqueur.",
            imageURL: nil,
            ingredients: [
                Ingredient(name: "Tequila", measurement: "2 oz"),
                Ingredient(name: "Lime juice", measurement: "1 oz"),
                Ingredient(name: "Triple sec", measurement: "1 oz")
            ],
            instructions: "Shake all ingredients with ice and strain into a salt-rimmed glass.",
            category: .cocktail,
            alcoholic: true,
            price: 12.99
        )
    )
}
