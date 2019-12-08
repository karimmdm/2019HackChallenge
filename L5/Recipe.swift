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
    let oid:Int
    let detailOid:Int
    let menuName:String
    let foodName: String
    
    
    
}

struct RecipeSearchResponse: Codable {
    var success:Bool
    var data: [Recipe]
    
}



