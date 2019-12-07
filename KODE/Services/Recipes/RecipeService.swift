//
//  RecipeService.swift
//  KODE
//
//  Created by Victor on 07.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

protocol RecipeService {
    func getRecipes(completion: @escaping (Result<[Recipe], RecipeError>) -> ())
}
