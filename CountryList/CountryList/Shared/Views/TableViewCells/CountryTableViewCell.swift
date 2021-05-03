//
//  CountryTableViewCell.swift
//  CountryList
//
//  Created by Jonathan Hoche on 03/05/2021.
//

import UIKit

class CountryTableViewCell: UITableViewCell, Reusable, NibLoadable {
    
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var nativeNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func configure(with country: Country) {
        nameLabel.text = country.name
        nativeNameLabel.text = country.nativeName
    }
}
