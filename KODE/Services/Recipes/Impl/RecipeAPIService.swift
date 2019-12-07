
//
//  RecipeAPI.swift
//  KODE
//
//  Created by Victor on 07.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import Alamofire

class RecipeAPIService: RecipeService {
    private let recipeListPath = "https://test.kode-t.ru/recipes.json"
    
    func getRecipes(completion: @escaping (Result<[Recipe], RecipeError>) -> ()) {
        guard let url = URL(string: recipeListPath) else {
            completion(.failure(.invalidURL))
            return
        }
        AF.request(url, method: .get).response {[weak self] (response) in
            self?.proposeResponse(response: response,
                                  completion: completion)
        }
    }
    
    private func proposeResponse(response: AFDataResponse<Data?>,
                                 completion: @escaping (Result<[Recipe], RecipeError>) -> ()) {
        print(response.debugDescription)
        if let error = response.error {
            completion(.failure(.afError(error)))
            return
        }
        if let data = response.data {
            do {
                let recipes = try JSONDecoder().decode(Recipes.self, from: data)
                completion(.success(recipes.recipes))
                
            } catch {
                if let err = error as? DecodingError {
                    completion(.failure(.decodeError(err)))
                } else {
                    completion(.failure(.unexpectedError(error)))
                }
            }
        }
    }
}
