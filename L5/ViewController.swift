//
//  ViewController.swift
//  L5
//
//  Created by Maitreyi Chatterjee on 11/05/19.
//  Copyright © 2019 Maitreyi Chatterjee. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UISearchResultsUpdating {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
     
      
   
    
   
    
    var filterView:UICollectionView!
    var collectionView: UICollectionView!
    
    var persons: [Restaurant] = []
    var restaurants: [Restaurant] = []
    
    
    var filters: [Filter] = []
    var selectedFilters: [String] = []
    var restaurant1: Restaurant!
    var restaurant2: Restaurant!
    var restaurant3: Restaurant!
    var restaurant4: Restaurant!
    var restaurant5: Restaurant!
    var restaurant6: Restaurant!
    var restaurant7: Restaurant!
    var restaurant8: Restaurant!
    var restaurant9: Restaurant!
    var restaurant10: Restaurant!
    var restaurant11: Restaurant!
    var american: Filter!
    var mexican: Filter!
    var indian: Filter!
    var breakfast: Filter!
    var BRB: Filter!
    var filter6: Filter!
    var filter7: Filter!
    var filter8: Filter!
    var filter9: Filter!
    var filter10: Filter!
     
    let personCellReuseIdentifier = "personCellReuseIdentifier"
    let filterCellReuseIdentifier = "filterCellReuseIdentifier"
    

    let padding: CGFloat = 10
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        title = "Restaurants"
        view.backgroundColor = .lightGray
        
        // Create Person objects
        
        restaurant1 = Restaurant(food: "american", imageName: "restaurant1", name: "Bear Necessities")
        restaurant2 = Restaurant(food: "mexican", imageName: "restaurant 2", name: "Bus Stop Bagels")
        restaurant3 = Restaurant(food: "american", imageName: "restaurant 3", name: "Cafe Jennie")
        restaurant4 = Restaurant(food: "mexican", imageName: "restaurant4", name: "Cornell Dairy ")
        
        restaurant5 = Restaurant(food: "american", imageName: "restaurant5", name: "Goldies")
        restaurant6 = Restaurant(food: "mexican", imageName: "resaturant6", name: "The Ivy Room")
        
        restaurant7 = Restaurant(food: "american", imageName: "resaturant7", name: "Mattins")
        restaurant8 = Restaurant(food: "mexican", imageName: "restaurant8", name: "Sweet Sensations")
        
        restaurant9 = Restaurant(food: "american", imageName: "restaurant9", name: "Trillium")
        restaurant10 = Restaurant(food: "mexican", imageName: "restaurant10", name: "Martha's Express")
        restaurant11  = Restaurant(food: "mexican", imageName:"takeushome", name: "Take Us Home")
        
        
        
        
        
        
        persons=[ restaurant1,restaurant2,restaurant3,restaurant4,restaurant5,restaurant6,restaurant7,restaurant4,restaurant8,restaurant9,restaurant10,restaurant11]
        
        
        american = Filter(select: false, name: "american")
        mexican = Filter(select: false, name: "mexican")
        indian = Filter(select: false, name: "Indian")
        BRB = Filter(select: false, name: "BRB")
        breakfast = Filter(select: false, name: "breakfast")
        filters=[american,indian,mexican,BRB,breakfast]
        
        
        // TODO: Setup collectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        
    
      
   
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .lightGray
        collectionView.layer.borderColor = UIColor.softBlue.cgColor
        collectionView.register(PersonCollectionViewCell.self, forCellWithReuseIdentifier: personCellReuseIdentifier)
     
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        filterView = UICollectionView(frame: .zero, collectionViewLayout: layout2)
        filterView.translatesAutoresizingMaskIntoConstraints = false
        filterView.backgroundColor = .softBlue
        filterView.layer.cornerRadius=30
        filterView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: filterCellReuseIdentifier)
        filterView.dataSource = self
        filterView.delegate = self
    
        
        view.addSubview(filterView)
        
        if selectedFilters == [] {
            restaurants = persons
            collectionView.reloadData()
        }
        
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:padding),
            filterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant:75),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: filterView.bottomAnchor, constant: padding),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
    }

}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.collectionView)
        {
            return restaurants.count}
        else
        {return filters.count}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
                         
        if(collectionView==self.collectionView){
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: personCellReuseIdentifier, for: indexPath) as! PersonCollectionViewCell
        cell.configure(for: restaurants[indexPath.row])
            
            
            return cell
            
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCellReuseIdentifier, for: indexPath) as! FilterCollectionViewCell
            cell.configure(for: filters[indexPath.row])
            
            
            return cell
        }
    }
    
   

}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // We want: | padding CELL padding CELL padding CELL padding |
        if(collectionView==self.collectionView){
        let size = (collectionView.frame.width -  padding) / 1.0
            return CGSize(width: size, height: size)}
        else{
            let size = (collectionView.frame.width - 2*padding) / 3.0
                     return CGSize(width: size+70, height: 30)
        }
    }
    
    
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView==self.filterView)
        {
            let cell = self.filterView.cellForItem(at: indexPath) as! FilterCollectionViewCell
            
            
            
            cell.followButtonPressed()
            print(indexPath)
            if cell.isFollowing {
                selectedFilters.append(cell.filterName)
            } else {
                var removeIndex: Int!
                
                for filter in selectedFilters {
                    if filter == cell.filterName {
                        removeIndex = selectedFilters.firstIndex(of: filter)
                    }
                }

                selectedFilters.remove(at: removeIndex)
            }
            
            
            restaurants = []
            
            for selectedFilter in selectedFilters {
                
                for i in persons
                {
                    
                    if(i.food==selectedFilter)
                    {
                        // Check that resturants doesnt contain the new one (No duplicates)
                        restaurants.append(i)

                    }
                    
                }
            }
            // Handle the case of not following (removing restuarants with this filter
            
            self.collectionView.reloadData()
             //for i in persons
            // {
               // if(i.food==filters[indexPath.row].name)
               // {
                 // i.selected.toggle()
               // }
                
                //collectionView.reloadData()
               
        }
            
            if selectedFilters == [] {
                restaurants = persons
                collectionView.reloadData()
            }
            
            
        
            
 if collectionView == self.collectionView {
        var newvc = searchView()
        print(indexPath.row)
    
        //print(restaurants[indexPath.row])
       newvc.restaurant = restaurants[indexPath.row]
        navigationController?.pushViewController(newvc, animated: true)
        
        collectionView.reloadData()
        }
        
      
        }

        
        
        
      
        
}
extension UIColor {

  @nonobjc class var softBlue: UIColor {
    return UIColor(red: 87.0 / 255.0, green: 130.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var white: UIColor {
    return UIColor(white: 1.0, alpha: 1.0)
  }

}


