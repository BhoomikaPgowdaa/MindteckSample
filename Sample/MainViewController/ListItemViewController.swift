//
//  ListItemViewController.swift
//  Sample
//
//  Created by Bhoomika HP on 22/07/24.
//

import UIKit

class ListItemViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    var response: [Category]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpTableView()
    }
    
    
    private func setUpTableView() {
        registerCells()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 180
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
    }
    
    class func ListItemViewControllerInstance() -> ListItemViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ListItemViewController") as? ListItemViewController else {
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
            self.tableView.reloadData()
            print("Table view reloaded")
        }
            
        }
    

}

extension ListItemViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculateCategoryCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
            
            if let category = getCategoryDetails(index: indexPath.row) {
                cell.configureCategoryCell(imageURL: category.strCategoryThumb, name: category.strCategory)
            }
            
            return cell
        }
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 70
      
    }
    
}
