//
//  RecipeCell.swift
//  KODE
//
//  Created by Victor on 07.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var model: RecipeCellModel? {
        didSet {
            setup(model)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.recipeImageView.image = nil
        self.nameLabel.text = nil
        self.descriptionLabel.text = nil
    }
    
    private func setup(_ model: RecipeCellModel?) {
        guard let model = model else { return }
        model.imageData.onSuccess { [weak self] (data) -> Void in
            DispatchQueue.main.async {
                self?.recipeImageView.image = UIImage(data: data)
            }
        }
        self.nameLabel.text = model.name
        self.descriptionLabel.text = model.description
    }
}
