//
//  ImageListCollectionViewCell.swift
//  Sample
//
//  Created by Bhoomika HP on 23/07/24.
//

import UIKit

class ImageListCollectionViewCell: UICollectionViewCell {
    var imageListViewController: ImageListViewController?
    
    func loadCartItemsView(parent: UIViewController, _ cellIndex: Int, imageResponse: [Category]?) {
        if imageListViewController == nil {
            if let itemsVC = ImageListViewController.ImageItemViewControllerInstance()  {
                addChildVC(parent: parent, child: itemsVC)
                imageListViewController = itemsVC
            }
        }
        imageListViewController?.updateResponse(imageResponse)
    }
    
    private func addChildVC(parent: UIViewController, child: UIViewController) {
        parent.addChild(child)
                self.contentView.addSubview(child.view)
                child.didMove(toParent: parent)
                child.view.frame = self.contentView.bounds
                child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
}
