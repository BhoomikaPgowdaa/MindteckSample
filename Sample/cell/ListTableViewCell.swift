//
//  ListTableViewCell.swift
//  Sample
//
//  Created by Bhoomika HP on 22/07/24.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var imageTitle: UILabel!
    var task: URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCategoryCell(imageURL: String, name: String) {
          
          
            
            // Cancel any ongoing image download task for cell reuse
            task?.cancel()
            
            // Download the image asynchronously
            if let url = URL(string: imageURL) {
                task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    guard error == nil, let data = data, let image = UIImage(data: data) else {
                        print("Error downloading image:", error?.localizedDescription ?? "Unknown error")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self?.itemImageView.image = image
                        self?.imageTitle.text = name
                    }
                }
                task?.resume()
            }
        }
    
}
