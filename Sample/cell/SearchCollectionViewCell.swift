//
//  SearchCollectionViewCell.swift
//  Sample
//
//  Created by Bhoomika HP on 23/07/24.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var ouerViewWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //outerView.layer.cornerRadius = 8
        textField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingChanged)
    }

    func configureCell(widthValue: CGFloat){
        //ouerViewWidthConstraints.constant = widthValue - 40
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
            NotificationCenter.default.post(name: NSNotification.Name("SearchTextChanged"), object: nil, userInfo: ["searchText": textField.text ?? ""])
        }
    
}
