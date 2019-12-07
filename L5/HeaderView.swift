//
//  HeaderView.swift
//  L5_Starter
//
//  Created by Maitreyi Chatterjee on 11/05/19.
//  Copyright © 2019 Maitreyi Chatterjee. All rights reserved.
//
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "THIS IS MY HEADER VIEW!"
        label.textAlignment = .center
        addSubview(label)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
