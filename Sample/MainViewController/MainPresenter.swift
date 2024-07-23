//
//  MainPresenter.swift
//  Sample
//
//  Created by Bhoomika HP on 23/07/24.
//


import Foundation


protocol CategoriesPresenterProtocol {
    func fetchCategories()
}

class CategoriesPresenter: CategoriesPresenterProtocol {
    
    weak var view: SampleViewProtocol?
       var model: TestModelProtocol
       
       init(view: SampleViewProtocol) {
           self.view = view
           self.model = TestModel()
       }
    
    func fetchCategories() {
        model.fetchCategories { categoriesResponse in
            self.view?.updateCategoriesImages(result: categoriesResponse)
            }
        }
}






////Model handling
import Foundation


struct Category: Codable {
    let strCategoryThumb: String
    let strCategory: String
}

struct CategoriesResponse: Codable {
    let categories: [Category]
}


protocol TestModelProtocol {
    func fetchCategories(completion: @escaping (CategoriesResponse) -> Void)
}

class TestModel: TestModelProtocol {
    func fetchCategories(completion: @escaping (CategoriesResponse) -> Void) {
        let urlString = "https://www.themealdb.com/api/json/v1/1/categories.php"
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle data fetching and decoding
            if error != nil{
                
                print("url having some issue\(String(describing: error))")
                return
            }
            
            guard let dataResponse = data else{
                return
            }
            do{
                let result = try JSONDecoder().decode(CategoriesResponse.self, from: dataResponse)
                completion(result)
            }catch{
                return
            }
        }.resume()
    }
}
