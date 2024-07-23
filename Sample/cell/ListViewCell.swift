//
//  ListViewCell.swift
//  Sample
//
//  Created by Bhoomika HP on 22/07/24.
//

import Foundation

import UIKit

class ListViewCollectionViewCell: UICollectionViewCell {
    
    var listItemViewController: ListItemViewController?
    
    func loadCartItemsView(parent: UIViewController, _ cellIndex: Int, imageResponse: [Category]?) {
        if listItemViewController == nil {
            if let itemsVC = ListItemViewController.ListItemViewControllerInstance() {
                addChildVC(parent: parent, child: itemsVC)
                listItemViewController = itemsVC
            }
        }
        listItemViewController?.updateResponse(imageResponse)
    }
    
    private func addChildVC(parent: UIViewController, child: UIViewController) {
        parent.addChild(child)
                self.contentView.addSubview(child.view)
                child.didMove(toParent: parent)
                child.view.frame = self.contentView.bounds
                child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    
}
    
