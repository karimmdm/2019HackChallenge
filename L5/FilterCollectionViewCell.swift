//
//  FilterCollectionViewCell.swift
//  L5
//
//  Created by Maitreyi Chatterjee on 05/11/19.
//  
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell{
    
    var followLabel: UILabel!
    var filterImageView: UIImageView!
    let padding: CGFloat = 8
    let labelHeight: CGFloat = 16
    var isFollowing: Bool = false
    var filterName: String = ""
       

       override init(frame: CGRect) {
           super.init(frame: frame)
         

           
        followLabel = UILabel()
        followLabel.backgroundColor = .white
        followLabel.layer.cornerRadius=20
        followLabel.layer.masksToBounds = true
        
        followLabel.text = "Follow"
        followLabel.textColor = .black
        followLabel.layer.borderColor = UIColor.softBlue.cgColor
        followLabel.layer.borderWidth = 1
        followLabel.translatesAutoresizingMaskIntoConstraints = false
        
       contentView.addSubview(followLabel)
        
        
        
    
           
           setupConstraints()
        
       }

       func setupConstraints() {
        NSLayoutConstraint.activate([
                   followLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                   followLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                   followLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            followLabel.trailingAnchor.constraint(equalTo:contentView.trailingAnchor )
               ])
          
       }
       
       func configure(for filter: Filter) {
        followLabel.text = filter.name
        followLabel.textAlignment = .center
        filterName = filter.name
        isFollowing = filter.select
       }
       
       

       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    
    func followButtonPressed() {
        isFollowing.toggle()

        followLabel.textColor = isFollowing ? .white : .black
        followLabel.backgroundColor = isFollowing ? .black : .white
        
    }
    
    }


