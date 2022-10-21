//
//  DictionaryCollectionViewCell.swift
//  Laword
//
//  Created by Ildar Khabibullin on 22.10.2022.
//

import UIKit

//let reuseIdentifier = "newCell"


class DictionaryCollectionViewCell: UICollectionViewCell {
    @IBOutlet var nameOfDictionary: UILabel!
    @IBOutlet var countOfWordsInCurrentDictionary: UILabel!
    @IBOutlet var photosImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
}
