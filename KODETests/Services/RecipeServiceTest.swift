//
//  RecipeServiceTest.swift
//  KODETests
//
//  Created by Victor on 08.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import XCTest
@testable import KODE

class MockRecipeService: KODE.RecipeService {
    func getRecipes(completion: @escaping (Result<[Recipe], RecipeError>) -> ()) {
        do {
            let bundle = Bundle(for: type(of: self))
            guard let resourceURL = bundle.url(forResource: "Recipes", withExtension: nil) else {
                return
            }
            let data = try Data(contentsOf: resourceURL)
            let recipes = try JSONDecoder().decode(Recipes.self, from: data)
            completion(.success(recipes.recipes))
        } catch {
            if let err = error as? DecodingError {
                completion(.failure(.decodeError(err)))
            } else if let err = error as? RecipeError {
                completion(.failure(err))
            } else if let err = error as? InvalidPath {
                completion(.failure(.invalidPath(err)))
            } else {
                completion(.failure(.unexpectedError(error)))
            }
        }
    }
}

class RecipeServiceTest: XCTestCase {

    var recipeService: KODE.RecipeService!
    
    override func setUp() {
        recipeService = MockRecipeService()
    }

    override func tearDown() {
        recipeService = nil
    }

    func test_getRecipes_count() {
        recipeService.getRecipes { (result) in
            switch result {
            case .failure(let err):
                XCTFail(err.localizedDescription)
            case .success(let recipes):
                XCTAssertEqual(recipes.count, 3, "Not equal counts of JSON recipes!")
            }
        }
    }
}
