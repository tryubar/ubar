//
//  DrinkViewModel.swift
//  ubar
//
//  Created by Ranjan Biswas on 6/24/25.
//

import Foundation
import Combine

// MARK: - Drink View Model
@MainActor
class DrinkViewModel: ObservableObject {
    @Published var drinks: [Drink] = []
    @Published var featuredDrink: Drink?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    
    private let apiService: APIServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
        setupSearchBinding()
        loadFeaturedDrink()
    }
    
    // MARK: - Setup Search Binding
    private func setupSearchBinding() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                if !searchText.isEmpty {
                    self?.searchDrinks(query: searchText)
                } else {
                    self?.drinks = []
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Load Featured Drink
    func loadFeaturedDrink() {
        isLoading = true
        errorMessage = nil
        
        apiService.getRandomDrink()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] drink in
                    self?.featuredDrink = drink
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Search Drinks
    func searchDrinks(query: String) {
        guard !query.isEmpty else {
            drinks = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        apiService.searchDrinks(by: query)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] drinks in
                    self?.drinks = drinks
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Load Drinks by Category
    func loadDrinks(by category: DrinkCategory) {
        isLoading = true
        errorMessage = nil
        
        apiService.getDrinks(by: category)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] drinks in
                    self?.drinks = drinks
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Get Drink Details
    func getDrinkDetails(id: String, completion: @escaping (Drink?) -> Void) {
        apiService.getDrink(by: id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error fetching drink details: \(error)")
                    }
                },
                receiveValue: { drink in
                    completion(drink)
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Clear Results
    func clearResults() {
        drinks = []
        searchText = ""
        errorMessage = nil
    }
}
