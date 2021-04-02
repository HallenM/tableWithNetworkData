//
//  NetworkService.swift
//  app03.2.0
//
//  Created by developer on 05.03.2021.
//

import UIKit
import Alamofire

enum NetworkServiceError: Error {
    case noDataError(localizedError: String)
}

class NetworkService {
    
    func fetchMealCategories(completion: @escaping (_ mealCategories: Result<[MealCategory]>) -> Void) {
        /* Old requests
         // Simple generation of inner data
         for i in 0..<100 {
         listOfData.append("cell number \(i+1)")
        }
        
         // Alamofire Request
         Alamofire.request(
            "https://www.themealdb.com/api/json/v1/1/categories.php",
            method: .get)
            .validate()
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success:
                    
                    guard let jsonArray = responseJSON.result.value as? [String: AnyObject] else { return }
                    
                    guard let innerArray = jsonArray["categories"] as? [AnyObject] else { return }
                    
                    for elements in innerArray {
                        guard let element = elements["strCategory"] as? String else { return }
                        self.listOfData.append("Category \(element)")
                    }
                    completion()
                case .failure(let error):
                    print("Fail_resp:  \(error)")
                }
            }  */
        
        // URL Session Request
        let session = URLSession(configuration: .default)
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php") else { return }
        session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                completion(.failure(NetworkServiceError.noDataError(localizedError: "No data from server")))
                return
            }
            do {
                let categoriesData = try JSONDecoder().decode(CategoriesData.self, from: data)
                
                completion(.success(categoriesData.categories))
                
            } catch {
                print ("Error::   \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
