//
//  DictionaryCollectionViewCell.swift
//  Laword
//
//  Created by Ildar Khabibullin on 22.10.2022.
//

import UIKit

//enum ColorAppearence2 {
//    static let backgroudColor = SchemeColor(dark: Dark.backgroundColor, light: Light.backgroundColor)
//    static let textColorOfCountWords = SchemeColor(dark: Dark.textColorOfCountWords, light: Light.textColorOfCountWords)
//    static let textColor = SchemeColor(dark: Dark.textColor, light: Light.textColor)
//
//    private enum Light {
//        static let backgroundColor = UIColor.white
//        static let textColorOfCountWords = UIColor.gray
//        static let textColor = UIColor.black
//    }
//
//    private enum Dark {
//        static let backgroundColor = UIColor.black
//        static let textColorOfCountWords = UIColor.gray
//        static let textColor = UIColor.white
//    }
//}


class DictionaryCollectionViewCell: UICollectionViewCell {
    @IBOutlet var nameOfDictionary: UILabel!
    @IBOutlet var countOfWordsInCurrentDictionary: UILabel!
    @IBOutlet var photosImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameOfDictionary.textColor = ColorAppearence.textColor.uiColor()
        let nib = UIView()
        nib.backgroundColor = ColorAppearence.backgroudColor.uiColor()
        countOfWordsInCurrentDictionary.textColor = ColorAppearence.textColorOfCountWords.uiColor()
        // Initialization code

    }
}
