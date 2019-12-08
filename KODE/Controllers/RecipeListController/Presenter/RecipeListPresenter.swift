//
//  RecipeListPresenter.swift
//  KODE
//
//  Created by Victor on 07.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import FutureKit

protocol RecipeListPresenter: class {
    func preload()
    func title() -> String
    func searchBarTitle() -> String
    func numberOfRows() -> Int
    func cellForRowAtIndexPath(_ indexPath: IndexPath) -> RecipeCellModel?
    func didSelectRowAtIndexPath(_ indexPath: IndexPath)
    func searchBarScopeTitles() -> [String]
    func sortTypes() -> [String]
    func didChangedSearchCategory(index: Int, text: String?)
    func ascendingButtonTitle() -> String
    func didSelectSortType(sortIndex: Int)
    func didTappedAscendingButton()
}

class RecipeListPresenterImpl {
    //MARK: Enums
    enum SortType: String, CaseIterable {
        case name = "По названию"
        case date = "По дате"
    }
    
    enum SearchType: String, CaseIterable {
        case name = "Название"
        case description = "Описание"
        case instruction = "Инструкция"
        case all = "Все "
    }
    //MARK: Public
    weak var view: RecipeListView!
    
    //MARK: Private
    private var allRecipes: [Recipe] = [] {
        didSet {
            filteredRecipes = allRecipes
            reload()
        }
    }
    
    //MARK: Services
    private let recipeService: RecipeService
    private let concurrentDownloader: ConcurrentDownloader
    
    //MARK: Variables
    private var filteredRecipes: [Recipe] = []
    private var sortType: SortType = .name
    private var searchType: SearchType = .name
    private var text: String = ""
    private var ascending: Bool = true
    
    //MARK: Init
    init(with recipeService: RecipeService = RecipeAPIService(),
         concurrentDownloader: ConcurrentDownloader = GCDDownloader(),
         recipeView: RecipeListView) {
        self.recipeService = recipeService
        self.view = recipeView
        self.concurrentDownloader = concurrentDownloader
    }
}

//MARK: -RecipeListPresenter
extension RecipeListPresenterImpl: RecipeListPresenter {
    func didTappedAscendingButton() {
        ascending = !ascending
        reload()
    }
    
    func didSelectSortType(sortIndex: Int) {
        guard sortIndex < SortType.allCases.count else {
            return
        }
        self.sortType = SortType.allCases[sortIndex]
        reload()
    }
    
    func didSelectSortTypeWithIndex(_ index: Int) {
        guard index < SortType.allCases.count else {
            return
        }
        self.sortType = SortType.allCases[index]
        self.reload()
    }
    
    func didSelectAscendingWithIndex(_ index: Int) {
        switch index {
        case 0:
            ascending = true
        case 1:
            ascending = false
        default:
            break
        }
        reload()
    }
    
    func ascendingButtonTitle() -> String {
        if ascending {
            return "По убыв."
        } else {
            return "По возр."
        }
    }
    
    func preload() {
        getRecipesRequest()
    }
    
    func title() -> String {
        return "Recipes"
    }
    
    func searchBarTitle() -> String {
        return "Recipe list"
    }
    
    func numberOfRows() -> Int {
        return filteredRecipes.count
    }
    
    func cellForRowAtIndexPath(_ indexPath: IndexPath) -> RecipeCellModel? {
        guard indexPath.row < filteredRecipes.count else {
            return nil
        }
        let recipe = filteredRecipes[indexPath.row]
        let imageData: Future<Data>
        if let url = recipe.images.first {
            imageData = concurrentDownloader.downloadImage(url: url)
        } else {
            imageData = .init(fail: RecipeError.emptyUrl)
        }
        return RecipeCellModel(imageData: imageData,
                               name: recipe.name,
                               description: recipe.description)
    }
    
    func didSelectRowAtIndexPath(_ indexPath: IndexPath) {
        guard indexPath.row < self.filteredRecipes.count else {
            return
        }
        let recipe = self.filteredRecipes[indexPath.row]
        let controller = DetailRecipeController()
        let presenter = DetailRecipePresenterImpl(recipe: recipe,
                                                  view: controller)
        controller.presenter = presenter
        self.view.pushController(controller)
    }
    
    func searchBarScopeTitles() -> [String] {
        return SearchType.allCases.map { (search) -> String in
            return search.rawValue
        }
    }
    
    func didChangedSearchCategory(index: Int, text: String?) {
        guard index < SearchType.allCases.count else {return}
        self.searchType = SearchType.allCases[index]
        self.text = text ?? ""
        reload()
    }
    
    func sortTypes() -> [String] {
        return SortType.allCases.map { (type) -> String in
            return type.rawValue
        }
    }
}

//MARK: -Helping methods
private extension RecipeListPresenterImpl {
    func getRecipesRequest() {
        recipeService.getRecipes {[weak self] (result) in
            switch result {
            case .success(let recipes):
                self?.allRecipes = recipes
            case .failure(let error):
                self?.view.didHappenedError(error: error.localizedDescription)
            }
        }
    }
    
    func reload() {
        filter()
        sort()
        view.reload()
    }
    
    func filter() {
        guard !text.isEmpty else {
            self.filteredRecipes = allRecipes
            return
        }
        self.filteredRecipes = self.allRecipes.filter({ (recipe) -> Bool in
            switch self.searchType {
            case .description:
                return recipe.description?.lowercased().contains(text.lowercased()) ?? false
            case .instruction:
                return recipe.instructions.lowercased().contains(text.lowercased())
            case .name:
                return recipe.name.lowercased().contains(text.lowercased())
            case .all:
                return recipe.description?.lowercased().contains(text.lowercased()) ?? false ||
                       recipe.instructions.lowercased().contains(text.lowercased()) ||
                       recipe.name.lowercased().contains(text.lowercased())
            }
        })
    }
    
    func sort() {
        switch sortType {
        case .date:
            self.filteredRecipes = self.filteredRecipes.sorted(by: { (recipeA, recipeB) -> Bool in
                if ascending {
                    return recipeA.lastUpdatedDate < recipeB.lastUpdatedDate
                } else {
                    return recipeA.lastUpdatedDate > recipeB.lastUpdatedDate
                }
            })
        case .name:
            self.filteredRecipes = self.filteredRecipes.sorted(by: { (recipeA, recipeB) -> Bool in
                if ascending {
                    return recipeA.name < recipeB.name
                } else {
                    return recipeA.name > recipeB.name
                }
            })
        }
    }
}
