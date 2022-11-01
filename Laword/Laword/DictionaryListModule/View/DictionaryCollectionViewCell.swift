//
//  DictionaryCollectionViewCell.swift
//  Laword
//
//  Created by Ildar Khabibullin on 22.10.2022.
//

import UIKit

class DictionaryCollectionViewCell: UICollectionViewCell {
    @IBOutlet var nameOfDictionary: UILabel!
    @IBOutlet var countOfWordsInCurrentDictionary: UILabel!
    @IBOutlet var photosImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        nameOfDictionary.textColor = ColorAppearence.textColor.uiColor()
//        let nib = UIView()
//        nib.backgroundColor = ColorAppearence.backgroudColor.uiColor()
//        countOfWordsInCurrentDictionary.textColor = ColorAppearence.textColorOfCountWords.uiColor()
    }
}
