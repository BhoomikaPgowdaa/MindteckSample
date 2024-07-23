//
//  ImageListViewController.swift
//  Sample
//
//  Created by Bhoomika HP on 23/07/24.
//

import UIKit

class ImageListViewController: UIViewController{
  
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionViewHeightConstraints: NSLayoutConstraint!
    
    var response: [Category]?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpTableView()
    }
    
    
    private func setUpTableView() {
        registerCells()
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.gray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionViewHeightConstraints.constant = 180
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right:0)
            layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width * 0.8) - 10, height: collectionViewHeightConstraints.constant)
        }
        
       
    }
    
    func registerCells(){
        collectionView.register(UINib(nibName: "imageCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageCellCollectionViewCell")
    }
    
    class func ImageItemViewControllerInstance() -> ImageListViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ImageListViewController") as? ImageListViewController else {
            return nil
        }
        return viewController
    }
    
    func calculateCategoryCount() -> Int {
        
        return response?.count ?? 0
    }
    
    func getCategoryDetails(index: Int) -> Category? {
        return response?[index]
    }

    
    func updateResponse(_ newResponse: [Category]?) {
        response = newResponse
        DispatchQueue.main.async {
            self.pageControl.numberOfPages = newResponse?.count ?? 0
            self.collectionView.reloadData()
            print("collectionView reloaded")
        }
            
        }
    

    

}

extension ImageListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return calculateCategoryCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCellCollectionViewCell", for: indexPath) as! imageCellCollectionViewCell

        cell.configureCell(widthValue:  (view.frame.width * 0.8), imageURL: response?[indexPath.section].strCategoryThumb ?? "")
        return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (UIScreen.main.bounds.size.width * 0.8) - 10
        let itemHeight = collectionViewHeightConstraints.constant
        return CGSize(width: itemWidth, height: itemHeight)
    }
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
                return
            }
        let cellWidthIncludingSpacing = (layout.itemSize.width * 0.8) + layout.minimumLineSpacing
            let pageIndex = round(scrollView.contentOffset.x / cellWidthIncludingSpacing)
            pageControl.currentPage = Int(pageIndex)
        }
    
}
