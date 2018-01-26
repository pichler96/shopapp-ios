//
//  SortModalViewController.swift
//  ShopClient
//
//  Created by Evgeniy Antonov on 9/27/17.
//  Copyright © 2017 Evgeniy Antonov. All rights reserved.
//

import UIKit

protocol SortModalControllerProtocol: class {
    func didSelect(item: String)
}

let kSortTableCellHeight: CGFloat = 40
let kSortingViewCornerRadius: CGFloat = 7

class SortModalViewController: UIViewController, SortModalDataSourceProtocol, SortModalDelegateProtocol {
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var sortByLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var sortButton: UIButton!
    
    var sortItems = [String]()
    var selectedSortItem = String()
    
    weak var delegate: SortModalControllerProtocol?
    
    private var tableDataSource: SortModalDataSource!
    // swiftlint:disable weak_delegate
    private var tableDelegate: SortModalDelegate!
    // swiftlint:enable weak_delegate
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTableView()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        backgroundView.layer.cornerRadius = kSortingViewCornerRadius
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, at: 0)
        
        sortByLabel.text = NSLocalizedString("Label.SortBy", comment: String())
        sortButton.setTitle(NSLocalizedString("Button.Sort", comment: String()), for: .normal)
    }
    
    private func setupTableView() {
        let articleNib = UINib(nibName: String(describing: SortModalTableViewCell.self), bundle: nil)
        tableView.register(articleNib, forCellReuseIdentifier: String(describing: SortModalTableViewCell.self))
        
        tableViewHeightConstraint.constant = CGFloat(sortItems.count) * kSortTableCellHeight
        
        tableDataSource = SortModalDataSource()
        tableDataSource.delegate = self
        tableView.dataSource = tableDataSource
        
        tableDelegate = SortModalDelegate()
        tableDelegate.delegate = self
        tableView.delegate = tableDelegate
    }
    
    // MARK: - Action
    
    @IBAction func sortTapped(_ sender: UIButton) {
        delegate?.didSelect(item: selectedSortItem)
        dismiss(animated: true)
    }
    
    // MARK: - SortModalDataSourceProtocol
    
    func itemsCount() -> Int {
        return sortItems.count
    }
    
    func item(at index: Int) -> String? {
        if index < sortItems.count {
            return sortItems[index]
        }
        return nil
    }
    
    func selectedItem() -> String? {
        return selectedSortItem
    }
    
    // MARK: - SortModalDelegateProtocol
    
    func heightForRow() -> CGFloat {
        return kSortTableCellHeight
    }
    
    func didSelectItem(at index: Int) {
        if index < sortItems.count {
            selectedSortItem = sortItems[index]
            tableView.reloadData()
        }
    }
}