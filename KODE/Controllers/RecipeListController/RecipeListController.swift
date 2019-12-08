//
//  RecipeListController.swift
//  KODE
//
//  Created by Victor on 07.12.2019.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit

protocol RecipeListView: class {
    func reload()
    func didHappenedError(error: String)
    func pushController(_ controller: UIViewController)
}

class RecipeListController: BaseController {
    //MARK: Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var sortSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var ascendingButton: UIButton!
    private var searchController: UISearchController = .init(searchResultsController: nil)
    
    //MARK: Prop
    var presenter: RecipeListPresenter! {
        didSet {
            presenter.preload()
        }
    }
    
    //MARK: Init
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupTableView()
        setupSearchController()
        setupOther()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecipeCell.self)
        tableView.separatorStyle = .none
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = presenter.searchBarTitle()
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = presenter.searchBarScopeTitles()
        searchController.searchBar.delegate = self
    }
    
    private func setupOther() {
        title = presenter.title()
        ascendingButton.setTitle(presenter.ascendingButtonTitle(), for: .normal)
        sortSegmentedControl.removeAllSegments()
        for (index, sortTitle) in presenter.sortTypes().enumerated() {
            sortSegmentedControl.insertSegment(withTitle: sortTitle, at: index, animated: false)
        }
        sortSegmentedControl.selectedSegmentIndex = 0
        sortSegmentedControl.addTarget(self, action: #selector(didSelectSegmentedControl(_:)), for: .valueChanged)
        ascendingButton.addTarget(self, action: #selector(didTappedAscendingButton(_:)), for: .touchUpInside)
    }
}

//MARK: -Actions
private extension RecipeListController {
    @objc func didSelectSegmentedControl(_ sender: UISegmentedControl) {
        self.presenter.didSelectSortType(sortIndex: sender.selectedSegmentIndex)
    }
    
    @objc func didTappedAscendingButton(_ sender: UIButton) {
        self.presenter.didTappedAscendingButton()
        sender.setTitle(presenter.ascendingButtonTitle(), for: .normal)
    }
    
    @objc private func keyboardWillShow(sender: NSNotification) {
        guard  let userInfo = sender.userInfo else {return}
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = self.tableView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        tableView.contentInset = contentInset
    }
    
    @objc private func keyboardWillHide(sender: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInset
    }
}

//MARK: -RecipeListView
extension RecipeListController: RecipeListView {
    func pushController(_ controller: UIViewController) {
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func reload() {
        self.tableView.reloadData()
    }
    
    func didHappenedError(error: String) {
        self.showDefaultAlert(title: "Ошибка", message: error)
    }
}

//MARK: -UITableViewDataSource
extension RecipeListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecipeCell = tableView.dequeueReusableCell(for: indexPath)
        cell.model = presenter.cellForRowAtIndexPath(indexPath)
        return cell
    }
}

//MARK: -UITableViewDelegate
extension RecipeListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectRowAtIndexPath(indexPath)
    }
}

//MARK: -UISearchResultsUpdating
extension RecipeListController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        presenter.didChangedSearchCategory(index: searchBar.selectedScopeButtonIndex, text: searchBar.text)
    }
}

extension RecipeListController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        presenter.didChangedSearchCategory(index: selectedScope, text: searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.didChangedSearchCategory(index: searchBar.selectedScopeButtonIndex, text: searchBar.text)
    }
}
