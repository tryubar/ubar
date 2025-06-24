//
//  APIService.swift
//  ubar
//
//  Created by Ranjan Biswas on 6/24/25.
//

import Foundation
import Combine

// MARK: - API Endpoints
enum APIEndpoint {
    case searchDrinkByName(String)
    case getDrinkById(String)
    case getRandomDrink
    case getDrinksByCategory(DrinkCategory)
    case getAllCategories
    
    var url: URL? {
        let baseURL = "https://www.thecocktaildb.com/api/json/v1/1"
        
        switch self {
        case .searchDrinkByName(let name):
            return URL(string: "\(baseURL)/search.php?s=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
        case .getDrinkById(let id):
            return URL(string: "\(baseURL)/lookup.php?i=\(id)")
        case .getRandomDrink:
            return URL(string: "\(baseURL)/random.php")
        case .getDrinksByCategory(let category):
            return URL(string: "\(baseURL)/filter.php?c=\(category.rawValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
        case .getAllCategories:
            return URL(string: "\(baseURL)/list.php?c=list")
        }
    }
}

// MARK: - API Error Types
enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error with code: \(code)"
        }
    }
}

// MARK: - API Service Protocol
protocol APIServiceProtocol {
    func searchDrinks(by name: String) -> AnyPublisher<[Drink], APIError>
    func getDrink(by id: String) -> AnyPublisher<Drink?, APIError>
    func getRandomDrink() -> AnyPublisher<Drink?, APIError>
    func getDrinks(by category: DrinkCategory) -> AnyPublisher<[Drink], APIError>
}

// MARK: - API Service Implementation
class APIService: APIServiceProtocol {
    static let shared = APIService()
    private let session: URLSession
    
    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Generic API Request Method
    private func request<T: Codable>(
        endpoint: APIEndpoint,
        responseType: T.Type
    ) -> AnyPublisher<T, APIError> {
        guard let url = endpoint.url else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: responseType, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return APIError.decodingError(error)
                } else {
                    return APIError.networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - API Methods
    func searchDrinks(by name: String) -> AnyPublisher<[Drink], APIError> {
        request(endpoint: .searchDrinkByName(name), responseType: DrinkResponse.self)
            .map { $0.drinks ?? [] }
            .eraseToAnyPublisher()
    }
    
    func getDrink(by id: String) -> AnyPublisher<Drink?, APIError> {
        request(endpoint: .getDrinkById(id), responseType: DrinkResponse.self)
            .map { $0.drinks?.first }
            .eraseToAnyPublisher()
    }
    
    func getRandomDrink() -> AnyPublisher<Drink?, APIError> {
        request(endpoint: .getRandomDrink, responseType: DrinkResponse.self)
            .map { $0.drinks?.first }
            .eraseToAnyPublisher()
    }
    
    func getDrinks(by category: DrinkCategory) -> AnyPublisher<[Drink], APIError> {
        request(endpoint: .getDrinksByCategory(category), responseType: DrinkResponse.self)
            .map { $0.drinks ?? [] }
            .eraseToAnyPublisher()
    }
}
