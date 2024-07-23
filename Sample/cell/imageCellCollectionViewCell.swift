//
//  imageCellCollectionViewCell.swift
//  Sample
//
//  Created by Bhoomika HP on 23/07/24.
//

import UIKit

class imageCellCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    var task: URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    
    func configureCell(widthValue: CGFloat, imageURL: String){
        imageViewWidthConstraint.constant = widthValue - 10
        
        task?.cancel()
        
        // Download the image asynchronously
        if let url = URL(string: imageURL) {
            task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard error == nil, let data = data, let image = UIImage(data: data) else {
                    print("Error downloading image:", error?.localizedDescription ?? "Unknown error")
                    return
                }
                
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
            task?.resume()
        }
    }
}
