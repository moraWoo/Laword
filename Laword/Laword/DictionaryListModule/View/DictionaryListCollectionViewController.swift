//
//  DictionaryListCollectionViewController.swift
//  Laword
//
//  Created by Ildar Khabibullin on 22.10.2022.
//

import UIKit

class DictionaryListCollectionViewController: UICollectionViewController {

    weak var viewController: UIViewController?
    
    let itemsPerRow: CGFloat = 2
    let sectionInserts = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    let photos = ["sanfransisco", "newyork"]
    
    let labelOfSection = ["Базовые", "Пользовательские"]
    let countOfWordsInDictionary = ["1 / 100", "230 / 370"]
    
    var namesOfDicts: [String] = []
    
    var dict1: String = ""
    var dict2: Int!
    
    var presenter: DictionaryListViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Список словарей"
        
        namesOfDicts = presenter.getNamesOfDictionary() ?? [""]

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.scrollDirection = .vertical
        collectionView.showsVerticalScrollIndicator = false
        collectionView?.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        
        let nib = UINib(nibName: "DictionaryCollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "dictionaryCell")
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            UserDefaults.standard.set(0, forKey: "currentDictionary")
        } else {
            if UserDefaults.standard.bool(forKey: "Test Dictionary.dictionaryIsEmpty") {
                alertFinishWordsInCurrentDict()
            } else {
                UserDefaults.standard.set(1, forKey: "currentDictionary")
            }
        }
        _ = navigationController?.popToRootViewController(animated: true)
    }
    // MARK: To load current dictionary to Main
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingToParent {
            let currentDictFromMain = UserDefaults.standard.integer(forKey: "currentDictionary")
            UserDefaults.standard.set(currentDictFromMain, forKey: "currentDictionary")
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dictionaryCell", for: indexPath) as! DictionaryCollectionViewCell
        
        cell.nameOfDictionary.text = namesOfDicts[indexPath.item]
        UserDefaults.standard.set(indexPath.item, forKey: "currentDictionary")
                      
        let nameOfCurrentDictionary = namesOfDicts[indexPath.item]
        let allWordsFromUserDef = UserDefaults.standard.dictionary(forKey: "allWordsCount") ?? ["" : ""]
        let numberOfAllWords = allWordsFromUserDef[nameOfCurrentDictionary] as? Int
  
        let remainWordsFromUserDef = UserDefaults.standard.dictionary(forKey: "remainWordsCount") ?? ["" : ""]
        let numberOfRemainWords = remainWordsFromUserDef[nameOfCurrentDictionary] as? Int
        if let stringWithNumberOfAllWords = numberOfAllWords {
            let newNumberOfRemainWords = numberOfRemainWords ?? 0
            cell.countOfWordsInCurrentDictionary.text = "\(String(describing: newNumberOfRemainWords)) " + " | " + " \(stringWithNumberOfAllWords)"
        }
        
        let imageName = photos[indexPath.item]
        let image = UIImage(named: imageName)
        
        cell.photosImageView.layer.cornerRadius = 10
        cell.photosImageView.layer.masksToBounds = true
        
        cell.tag = indexPath.item

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
            header.configure(labelOfSection[indexPath.section])
        } else {
            header.configure(labelOfSection[indexPath.section])
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 50)
    }
}

extension DictionaryListCollectionViewController: DictionaryListViewProtocol {
    func setDictionaryName(dictionaryName: String) {
    }
    func getNamesOfDictionary() -> [String]? {
        return []
    }
}

extension DictionaryListCollectionViewController {
    
    private func alertFinishWordsInCurrentDict() {
        let alert = UIAlertController(title: "В данном словаре на сегодня закончились слова", message: "Выберите другой словарь словарь", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: { [self] _ in
            dismiss(animated: true)
        }))
    }
}


