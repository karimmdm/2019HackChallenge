//
//  PersonCollectionViewCell.swift
//  L5
//
// Created by Maitreyi Chatterjee on 11/05/19.
//  Copyright © 2019 Maitreyi Chatterjee. All rights reserved.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {
    
    var photoImageView: UIImageView!
    var nameLabel:UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        photoImageView = UIImageView()
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.masksToBounds = true
        photoImageView.layer.cornerRadius=30
        contentView.addSubview(photoImageView)
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.contentMode = .scaleAspectFill
        nameLabel.layer.masksToBounds = true
        contentView.addSubview(nameLabel)
        
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                   ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        
        
    }
    
    func configure(for person: Restaurant) {
        photoImageView.image = UIImage(named: person.profileImageName)
        nameLabel.text = person.name
        nameLabel.textColor = .systemPink
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
