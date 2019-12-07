//
//  Person.swift
//  L5_Starter
//  Created by Maitreyi Chatterjee on 11/05/19.
//  Copyright © 2019 Maitreyi Chatterjee. All rights reserved.
//
//

import Foundation

class Restaurant{
    
    var profileImageName: String
    var name: String
    var food:String
    var selected: Bool = false

    init(food:String,imageName: String, name: String) {
        self.profileImageName = imageName
        self.name = name
        self.food=food
        
    }
}
