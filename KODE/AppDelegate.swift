//
//  AppDelegate.swift
//  KODE
//
//  Created by Victor on 07.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        showController()
        return true
    }
    
    private func showController() {
        let recipesListController = RecipeListController()
        let recipeListPresenter = RecipeListPresenterImpl(recipeView: recipesListController)
        recipesListController.presenter = recipeListPresenter
        let navigationController = UINavigationController(rootViewController: recipesListController)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
}

