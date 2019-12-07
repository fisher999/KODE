//
//  DetailRecipeController.swift
//  KODE
//
//  Created by Victor on 08.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

protocol DetailRecipeView {
    
}

class DetailRecipeController: BaseController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var instructionsLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
