//
//  DictionaryListCollectionViewController.swift
//  Laword
//
//  Created by Ildar Khabibullin on 22.10.2022.
//

import UIKit

import UIKit

//let reuseIdentifier = "newCell"

class DictionaryListCollectionViewController: UICollectionViewController {

    let itemsPerRow: CGFloat = 2
    let sectionInserts = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    let photos = ["sanfransisco", "newyork"]
    
    let labelOfSection = ["Базовые словари", "Пользовательские словари"]
    let nameOfDictionary = ["Dictionary 1", "Dictionary 2"]
    let countOfWordsInDictionary = ["1 / 100", "230 / 370"]
    
    var presenter: DictionaryListViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        presenter.setDictionaryName()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.scrollDirection = .vertical
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView?.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        
        let nib = UINib(nibName: "DictionaryCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "dictionaryCell")
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dictionaryCell", for: indexPath) as! DictionaryCollectionViewCell
        
        cell.nameOfDictionary.text = nameOfDictionary[indexPath.row]
        cell.countOfWordsInCurrentDictionary.text = countOfWordsInDictionary[indexPath.row]

        let imageName = photos[indexPath.item]
        let image = UIImage(named: imageName)
        
        cell.photosImageView.layer.cornerRadius = 10
        cell.photosImageView.layer.masksToBounds = true

        cell.photosImageView.image = image
        return cell
    }
}

extension DictionaryListCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingWidth = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
        
        if indexPath.section == 0 {
            header.configure(labelOfSection[0])
        } else {
            header.configure(labelOfSection[1])
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 50)
    }
}

extension DictionaryListCollectionViewController: DictionaryListViewProtocol {
    func setDictionaryName(dictionaryName: String) {
        // dictionaryName.text = dictionaryName?.body
    }
}
