//
//  SearchViewController.swift
//  L5
//
//  Created by Maitreyi Chatterjee on 22/11/19.
//  Copyright © 2019 Kevin Chan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating {
    
    // MARK: View vars
    
    var tableView = UITableView()
    let receipCellIdentifier = "RecipeCell"
    var searchController: UISearchController!
    var restaurant:Restaurant!
    // MARK: Search var
    let searchBy: SearchType = .ingredients // TODO: You change this to search by titles or ingredients
    
    // MARK: Model var
    
    var recipes: [Recipe] = []
    var UnitOid = ["Bear Necessities":1,
                   "Bus Stop Bagels":2,
                   "Cafe Jennie":3,
                   "Cornell Dairy":4,
                   "Goldies":5,
                   "The Ivy Room":6,
                   "Mattins":7,
                   "Sweet Sensations":8,
                   "Trillium":9,
                   "Martha's Express":10,
                   "Take Us Home":11
    
    ]
     
    
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set navigation bar title
        title = "Dishes"
        
        
        // Layout views
        view.addSubview(tableView)
        
        // Pin the tableview’s anchors to its superview
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // Set up tableview logic
        tableView.dataSource = self
        tableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: receipCellIdentifier)
        
        // Make tableview cells' height dynamically resize
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        // Set up search controller logic
        
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense. Should probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = searchBy == .title ? "Search by title": "Search by ingredients (deliminate \"; \")"
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        
        
    }
    
    // MARK: UITableView Data Source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: receipCellIdentifier, for: indexPath) as! RecipeTableViewCell

       cell.titleLabel.text = recipes[indexPath.row].foodName
        
        cell.detailLabel.text = "Ingredients: \(recipes[indexPath.row].ingredients)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    // MARK: UISearchResultsUpdating Protocol
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if !searchText.isEmpty {
                switch searchBy {

                /// ***
                /// NOTE: You can set searchBy to be .title or .ingredients at the top of this class
                /// ***
                case .title:
                    // TODO: Make a request to the Recipe Puppy API using a
                    // title and then update the table view with the updated [Recipe]
                    // that you get after you decode the response
                    // Hint: The searchText is the title.
                    NetworkManager.getRecipe(fromTitle: searchText) { recipes in
                        self.recipes = recipes
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    print("search by title")
                    
                case .ingredients:
                    // TODO: Make a request to the Recipe Puppy API using a list of
                    // ingredients and then update the table view with the updated [Recipe]
                    // that you get after you decode the response
                    // Hint: The searchText is a string where the ingredients are
                    // separated by commas. (i.e. Apple, Butter, Cream)
                    var unitoid=UnitOid[restaurant.name]!
                    var arr = searchText.components(separatedBy: ",")
                NetworkManager.getRecipe(fromIngredients:arr,unitoid:unitoid) { recipes in
                        self.recipes = recipes
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    print("search by ingredients")
                    
                }
            }
            else {
                self.recipes = []
                self.tableView.reloadData()
            }
        }
    }

}

