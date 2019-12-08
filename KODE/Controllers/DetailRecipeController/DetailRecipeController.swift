//
//  DetailRecipeController.swift
//  KODE
//
//  Created by Victor on 08.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit
import Cosmos

protocol DetailRecipeView: class {
    func reload()
    func changePage(index: Int)
}

class DetailRecipeController: BaseController {
    //MARK: Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var instructionsLabel: UILabel!
    @IBOutlet private weak var ratingView: CosmosView!
    @IBOutlet private weak var pageControl: UIPageControl!

    //MARK: Props
    var presenter: DetailRecipePresenter!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        presenter.preload()
        setupCollectionView()
        setupOther()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageRecipeCell.self)
    }
    
    private func setupOther() {
        nameLabel.text = presenter.name()
        descriptionLabel.text = presenter.description()
        instructionsLabel.text = presenter.instruction()
        ratingView.isUserInteractionEnabled = false
        ratingView.rating = presenter.rating()
        pageControl.numberOfPages = presenter.numberOfRows()
    }
}

//MARK: -DetailRecipeView
extension DetailRecipeController: DetailRecipeView {
    func changePage(index: Int) {
        pageControl.currentPage = index
    }
    
    func reload() {
        pageControl.numberOfPages = presenter.numberOfRows()
        collectionView.reloadData()
    }
}

//MARK: -CollectionViewDataSource
extension DetailRecipeController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageRecipeCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.model = presenter.cellForRowAtIndexPath(indexPath)
        return cell
    }
}

//MARK: -CollectionViewDelegate
extension DetailRecipeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK: -ScrollViewDelegate
extension DetailRecipeController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        presenter.viewDidScrolled(offsetX: scrollView.contentOffset.x, pageWidth: scrollView.frame.width)
    }
}
