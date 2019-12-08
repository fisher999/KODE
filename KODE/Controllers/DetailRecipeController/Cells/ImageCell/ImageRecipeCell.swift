//
//  ImageRecipeCell.swift
//  KODE
//
//  Created by Victor on 08.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit
import FutureKit

class ImageRecipeCell: UICollectionViewCell {
    @IBOutlet private weak var recipeImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var model: Future<Data>? {
        didSet {
            model?.onSuccess(block: { [weak self] (data) -> (Void) in
                DispatchQueue.main.async {
                    self?.recipeImageView.image = UIImage(data: data)
                    self?.activityIndicator.stopAnimating()
                }
            })
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.recipeImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
}
