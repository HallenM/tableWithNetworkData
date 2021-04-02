//
//  MealCategory.swift
//  app03.2.0
//
//  Created by developer on 09.03.2021.
//

import Foundation

struct MealCategory: Decodable {
    let id: String
    var name: String?
    let thumbLink: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "idCategory"
        case name = "strCategory"
        case thumbLink = "strCategoryThumb"
        case description = "strCategoryDescription"
    }
}

struct CategoriesData: Decodable {
    let categories: [MealCategory]
}
