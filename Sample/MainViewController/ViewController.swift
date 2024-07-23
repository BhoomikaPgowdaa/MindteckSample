//
//  ViewController.swift
//  Sample
//
//  Created by Bhoomika HP on 22/07/24.
//

import UIKit

enum MyAppScreenSection: Int {
    case DisplayImage
    case search
    case ListItem
    
    init?(indexPath: IndexPath) {
        self.init(rawValue: indexPath.section)
    }
    static var numberOfSections: Int { return 3 }
}

protocol SampleViewProtocol: AnyObject {
    func updateCategoriesImages(result: CategoriesResponse)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var searchCellHeight: CGFloat = 50
    var imageHeight: CGFloat = 0
    var listViewHeight: CGFloat = 70
    
    var presenter: CategoriesPresenter?
    var response:  [Category]? = []
    var filteredCategories: [Category] = []
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = CategoriesPresenter(view: self)
        presenter?.fetchCategories()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = StickyHeaderFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.collectionViewLayout = layout
        
        collectionView.register(ImageListCollectionViewCell.self, forCellWithReuseIdentifier: "ImageListCollectionViewCell")
        collectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SearchCollectionViewCell")
        collectionView.register(ListViewCollectionViewCell.self, forCellWithReuseIdentifier: "ListViewCollectionViewCell")
        NotificationCenter.default.addObserver(self, selector: #selector(handleSearchTextChanged(_:)), name: NSNotification.Name("SearchTextChanged"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleSearchTextChanged(_ notification: Notification) {
        if let searchText = notification.userInfo?["searchText"] as? String {
            if searchText.isEmpty {
                isSearching = false
                filteredCategories = response ?? []
            } else {
                isSearching = true
                filteredCategories = response?.filter { $0.strCategory.lowercased().contains(searchText.lowercased()) } ?? []
            }
            calculateCategoryCount()
            collectionView.reloadData()
            refocusSearchTextField()
        }
    }
    
    func numberForItems(in section: MyAppScreenSection) -> Int {
        switch section {
        case .ListItem:
            return 1
        case .search:
            return 1
        case .DisplayImage:
            return 1
        }
    }
    
    func calculateCategoryCount() {
        let count = isSearching ? filteredCategories.count : (response?.count ?? 0)
        imageHeight = 210
        listViewHeight = CGFloat(count) * 70
    }
    
    func refocusSearchTextField() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let searchCell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: MyAppScreenSection.search.rawValue)) as? SearchCollectionViewCell {
                searchCell.textField.becomeFirstResponder()
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MyAppScreenSection.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let cartSection = MyAppScreenSection(rawValue: section) {
            return numberForItems(in: cartSection)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let section = MyAppScreenSection(indexPath: indexPath) {
            switch section {
            case .ListItem:
                return collectionView.dequeueReusableCell(withReuseIdentifier: "ListViewCollectionViewCell", for: indexPath)
            case .search:
                return collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath)
            case .DisplayImage:
                return collectionView.dequeueReusableCell(withReuseIdentifier: "ImageListCollectionViewCell", for: indexPath)
            }
        }
        return UICollectionViewCell()
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let imageItemCell = cell as? ImageListCollectionViewCell {
            imageItemCell.loadCartItemsView(parent: self, indexPath.row, imageResponse: filteredCategories)
        } else if let listItemCell = cell as? ListViewCollectionViewCell {
            listItemCell.loadCartItemsView(parent: self, indexPath.row, imageResponse: filteredCategories)
        } else if let imageItemCell = cell as? SearchCollectionViewCell {
            imageItemCell.configureCell(widthValue: view.frame.width)
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height: CGFloat
        if let section = MyAppScreenSection(indexPath: indexPath) {
            switch section {
            case .ListItem:
                height = listViewHeight
            case .search:
                height = searchCellHeight
            case .DisplayImage:
                height = imageHeight
            }
        } else {
            height = 0
        }
        return CGSize(width: width, height: height)
    }
}

extension ViewController: SampleViewProtocol {
    func updateCategoriesImages(result: CategoriesResponse) {
        response = result.categories
        filteredCategories = result.categories
        calculateCategoryCount()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

class StickyHeaderFlowLayout: UICollectionViewFlowLayout {
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
