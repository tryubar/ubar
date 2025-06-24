//
//  Drink.swift
//  ubar
//
//  Created by Ranjan Biswas on 6/24/25.
//

import Foundation

// MARK: - Drink Model
struct Drink: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let imageURL: String?
    let ingredients: [Ingredient]
    let instructions: String
    let category: DrinkCategory
    let alcoholic: Bool
    let price: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case description = "strDrinkDescription"
        case imageURL = "strDrinkThumb"
        case ingredients
        case instructions = "strInstructions"
        case category = "strCategory"
        case alcoholic = "strAlcoholic"
        case price
    }
}

// MARK: - Ingredient Model
struct Ingredient: Codable, Identifiable {
    let id = UUID()
    let name: String
    let measurement: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "strIngredient"
        case measurement = "strMeasure"
    }
}

// MARK: - Drink Category
enum DrinkCategory: String, Codable, CaseIterable {
    case cocktail = "Cocktail"
    case beer = "Beer"
    case wine = "Wine"
    case shot = "Shot"
    case mocktail = "Non-Alcoholic"
    case coffee = "Coffee"
    
    var displayName: String {
        return self.rawValue
    }
}

// MARK: - API Response Models
struct DrinkResponse: Codable {
    let drinks: [Drink]?
}

struct DrinkSearchResponse: Codable {
    let drinks: [Drink]?
}
