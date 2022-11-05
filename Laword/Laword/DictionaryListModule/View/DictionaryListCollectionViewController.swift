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
                
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "chevron.backward"), for: .normal)
        button.setTitle("  Back", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.sizeToFit()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(customView: button)
        button.addTarget(self, action: #selector(barButtonAction), for: .touchUpInside)

    }
    
    @objc func barButtonAction() {
        print("Button pressed")
        let nameOfCurrentDictionary = UserDefaults.standard.object(forKey: "currentDictionary") as? String ?? ""
        let currentDictionary = presenter.getCurrentDictionary(nameOfDictionary: nameOfCurrentDictionary)
        if currentDictionary?.countOfRemainWords == 0 {
            alertFinishWordsInCurrentDict()
            print("alertFinishWordsInCurrentDict1")
        }
        _ = navigationController?.popToRootViewController(animated: true)
        print("alertFinishWordsInCurrentDict2")
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nameOfCurrentDictionary = UserDefaults.standard.object(forKey: "currentDictionary") as? String ?? ""
        let currentDictionary = presenter.getCurrentDictionary(nameOfDictionary: namesOfDicts[indexPath.item])
        
        //Check each dictionary Is there any new word
        if currentDictionary?.countOfRemainWords == 0 {
            alertFinishWordsInCurrentDict()
        }
        
        if namesOfDicts[indexPath.item] != nameOfCurrentDictionary {
            if currentDictionary?.countOfRemainWords == 0 {
                alertFinishWordsInCurrentDict()
                print("alertFinishWordsInCurrentDict12  ==  \(nameOfCurrentDictionary)")
            } else {
                UserDefaults.standard.set(namesOfDicts[indexPath.item], forKey: "currentDictionary")
                print("alertFinishWordsInCurrentDict13")
            }
        }
        _ = navigationController?.popToRootViewController(animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dictionaryCell", for: indexPath) as! DictionaryCollectionViewCell
        
        cell.nameOfDictionary.text = namesOfDicts[indexPath.item]
        let nameOfCurrentDictionary = namesOfDicts[indexPath.item]
        let currentDictionaryInfo = presenter.getCurrentDictionary(nameOfDictionary: nameOfCurrentDictionary)
        cell.countOfWordsInCurrentDictionary.text = "\(currentDictionaryInfo?.countOfRemainWords ?? 0) " + " | " + " \(currentDictionaryInfo?.countOfAllWords ?? 0)"

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
        
        let alert = UIAlertController(title: "Вы прошли все слова", message: "Выберите другой словарь словарь", preferredStyle: UIAlertController.Style.alert)

        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) -> Void in
        })
        alert.addAction(alertAction)
        self.present(alert, animated:true, completion: nil)
    }
}

