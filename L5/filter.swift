//
//  filter.swift
//  L5
//
//  Created by Maitreyi Chatterjee on 05/11/19.
//  Copyright © 2019 Maitreyi Chatterjee. All rights reserved.
//

import Foundation
class Filter {
    
    
    var name: String
    var select:Bool

    init( select:Bool,name: String) {
        
        self.name = name
        self.select=select
    }
    
}
