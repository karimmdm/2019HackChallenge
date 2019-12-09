//
//  NetworkManager.swift
//  L5
//
//  Created by Maitreyi Chatterjee on 22/11/19.
//  Copyright © 2019 Maitreyi Chatterjee. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum SearchType {
    case ingredients
    case title
}

class NetworkManager {
    

    private static let recipePuppyURL = "http://www.recipepuppy.com/api"
    private static let URL = "http://35.199.7.241:80"

    static func getRecipe(fromIngredients ingredients: [String],unitoid:Int, _ didGetRecipes: @escaping ([Recipe]) -> Void) {
        //recipePuppyURL+"?i="+ingredients.joined(separator: ",")
        let structure =
        [
            "allergens": ingredients.joined(separator: ";")
        ]
        print(unitoid)
       // "/api/menus/"+String(unitoid)+"/filter/"
            // parameters:structure
        let headers=[
            "Content-Type":"application/json"
        
        ]
        
        Alamofire.request(URL + "/api/menus/"+String(unitoid)+"/filter/", method: .post,parameters:structure,encoding:JSONEncoding.default, headers: headers ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                print(data)
                print(String(data:data,encoding: .utf8))
            
                
                if let recipeData = try? jsonDecoder.decode(RecipeSearchResponse.self, from: data) {
                    let url = recipeData.data
                    didGetRecipes(url)
                    
                   // getRecipe(fromTitle: ingredients)
                    
                }
                else{ print("error")
                
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        // TODO: Fill in this function. This function should make a network request
        // to the Recipe Puppy API given an array of ingredients and then call the
        // didGetRecipes closure after you receive a response and decode it.
    }

    static func getRecipe(fromTitle title: String, _ didGetRecipes: @escaping ([Recipe]) -> Void) {
        // TODO: Fill in this function. This function should make a network request
        // to the Recipe Puppy API given a title and then call the
        // didGetRecipes closure after you receive a response and decode it.
        
        Alamofire.request(recipePuppyURL+"?q="+title, method: .get ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
            
                
                if let recipeData = try? jsonDecoder.decode(RecipeSearchResponse.self, from: data) {
                    let url = recipeData.data
                    didGetRecipes(url)
                    
                   // getRecipe(fromTitle: ingredients)
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        
        
        
    }
    

}

