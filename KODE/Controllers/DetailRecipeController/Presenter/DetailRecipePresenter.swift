//
//  DetailRecipePresenter.swift
//  KODE
//
//  Created by Victor on 08.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import FutureKit

protocol DetailRecipePresenter: class {
    func preload()
    func cellForRowAtIndexPath(_ indexPath: IndexPath) -> Future<Data>?
    func numberOfRows() -> Int
    func name() -> String
    func description() -> String?
    func instruction() -> String
    func rating() -> Double
    func viewDidScrolled(offsetX: CGFloat, pageWidth: CGFloat)
}

class DetailRecipePresenterImpl {
    //MARK: Public
    weak var view: DetailRecipeView!
    
    //MARK: Private
    private let recipe: Recipe
    private let concurrentDownloader: ConcurrentDownloader
    private var images: [Future<Data>] = []
    private var currentPage: Int = 0
    
    init(recipe: Recipe,
         concurrentDownloader: ConcurrentDownloader = GCDDownloader(),
         view: DetailRecipeView) {
        self.recipe = recipe
        self.concurrentDownloader = concurrentDownloader
        self.view = view
    }
}

//MARK: -DetailRecipePresenter
extension DetailRecipePresenterImpl: DetailRecipePresenter {
    func viewDidScrolled(offsetX: CGFloat, pageWidth: CGFloat) {
        currentPage = Int(offsetX / pageWidth)
        view.changePage(index: currentPage)
    }
    
    func preload() {
        loadImages()
        view.reload()
    }
    
    func cellForRowAtIndexPath(_ indexPath: IndexPath) -> Future<Data>? {
        guard indexPath.row < images.count else {
            return nil
        }
        return images[indexPath.row]
    }
    
    func numberOfRows() -> Int {
        return images.count
    }
    
    func name() -> String {
        return recipe.name
    }
    
    func description() -> String? {
        return recipe.description
    }
    
    func instruction() -> String {
        return recipe.instructions
    }
    
    func rating() -> Double {
        return Double(recipe.difficulty)
    }
}

//MARK: -Helping methods
private extension DetailRecipePresenterImpl {
    func loadImages() {
        for url in recipe.images {
            let image = concurrentDownloader.downloadImage(url: url)
            self.images.append(image)
        }
    }
}
