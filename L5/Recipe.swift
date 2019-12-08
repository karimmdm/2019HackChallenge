//
//  Recipe.swift
//  L5
//
//  Created by Maitreyi Chatterjee on 22/11/19.
//  Copyright © 2019 Kevin Chan. All rights reserved.
//

import Foundation
import UIKit

struct Recipe: Codable {
    let id:Int
    
    let detailOid:Int
    
    let foodName: String
    let ingredients:String
    let allergens:String
    let alochol:Bool
    let eggs:Bool
    let fish:Bool
    let gluten:Bool
    let milk:Bool
    let peanuts:Bool
    let pork_U:Bool
    let sesame:Bool
    let soy:Bool
    let treeNuts:Bool
    let wheat:Bool
    
    
    
    
    
}

struct RecipeSearchResponse: Codable {
    var success:Bool
    var data: [Recipe]
    
}



