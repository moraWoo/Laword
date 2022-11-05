//
//  SettingsViewController.swift
//  Laword
//
//  Created by Ильдар on 28.10.2022.
//

import UIKit


class SettingsViewController: UIViewController, SettingsViewProtocol {
    let modelObjects = [
        HeaderItem(title: "Внешний вид", symbols: [
            SFSymbolItem(
                name: "Темная тема",
                imageName: "powersleep"
            ),
            SFSymbolItem(
                name: "Кнопки слева",
                imageName: "rectangle.lefthalf.inset.filled.arrow.left"
            ),
        ]),
        HeaderItem(title: "Обучение", symbols: [
            SFSymbolItem(
                name: "Количество слов",
                imageName: "list.bullet.rectangle.fill"
            ),
        ]),
        HeaderItem(title: "Система", symbols: [
            SFSymbolItem(
                name: "Начальный экран выключен",
                imageName: "arrow.right.doc.on.clipboard"
            ),
        ]),
    ]
    var labelForCell = UILabel()
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<HeaderItem, SFSymbolItem>!
    var presenter: SettingsViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Настройки"
        
        // MARK: Create list layout
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutConfig.headerMode = .supplementary
        layoutConfig.footerMode = .supplementary
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        // MARK: Configure collection view
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        view.addSubview(collectionView)
        collectionView.allowsSelection = false
        
        // Make collection view take up the entire view
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
        ])

        // MARK: Cell registration
        let symbolCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SFSymbolItem> {
            (cell, indexPath, symbolItem) in
            
            // Configure cell content
            var configuration = cell.defaultContentConfiguration()
            configuration.image = symbolItem.image

            configuration.text = symbolItem.name
            cell.contentConfiguration = configuration
        }
        
        // MARK: Initialize data source
        dataSource = UICollectionViewDiffableDataSource<HeaderItem, SFSymbolItem>(collectionView: collectionView) { [unowned self]
            (collectionView, indexPath, symbolItem) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: symbolCellRegistration,for: indexPath,item: symbolItem)
            
            let sections = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
//            let rows = self.dataSource.snapshot().itemIdentifiers[indexPath.item]
            if sections.title == "Внешний вид" {
                
                let switchInCell = UISwitch()

                let darkMode = UserDefaults.standard.bool(forKey: "dark_mode")
                switchInCell.setOn(darkMode, animated: false)
                switchInCell.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
                switchInCell.tag = indexPath.row
                            
                cell.addSubview(switchInCell)

                switchInCell.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    switchInCell.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10.0),
                    switchInCell.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 0.0)
                ])
                
                switch switchInCell.tag {
                    case 0:
                        switchInCell.isOn = UserDefaults.standard.bool(forKey: "dark_mode")
                    default:
                        switchInCell.isOn = UserDefaults.standard.bool(forKey: "leftMode")
                }
                                
            } else if sections.title == "Обучение" {
                let stepper = UIStepper()
                stepper.minimumValue = 5
                stepper.maximumValue = 20
                stepper.stepValue = 1
                stepper.value = UserDefaults.standard.double(forKey: "amountOfWords")
                stepper.addTarget(self, action: #selector(stepperChanged), for: .valueChanged)
                cell.addSubview(stepper)
                stepper.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    stepper.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -45.0),
                    stepper.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 0.0)
                ])
                
                labelForCell.text = String(Int(stepper.value))
                cell.addSubview(labelForCell)
                labelForCell.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    labelForCell.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -12.0),
                    labelForCell.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 0.0)
                ])
            } else {
                let switchInCell = UISwitch()
                var launchBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
                switchInCell.setOn(launchBefore, animated: false)
                switchInCell.addTarget(self, action: #selector(launchAppWithOnboarding), for: UIControl.Event.valueChanged)
                switchInCell.tag = indexPath.row
                            
                cell.addSubview(switchInCell)

                switchInCell.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    switchInCell.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10.0),
                    switchInCell.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 0.0)
                ])

                launchBefore.toggle()
                switchInCell.isOn = launchBefore
        }
            
            return cell
        }
        
        // MARK: Supplementary view registration
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) {
            [unowned self] (headerView, elementKind, indexPath) in
            
            // Obtain header item using index path
            let headerItem = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
   
            // Configure header view content based on headerItem
            var configuration = headerView.defaultContentConfiguration()
            configuration.text = headerItem.title
            
            // Customize header appearance to make it more eye-catching
            configuration.textProperties.font = .boldSystemFont(ofSize: 16)
            configuration.directionalLayoutMargins = .init(top: 20.0, leading: 0.0, bottom: 10.0, trailing: 0.0)
            
            // Apply the configuration to header view
            headerView.contentConfiguration = configuration
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration
        <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionFooter) {
            [unowned self] (footerView, elementKind, indexPath) in
            
            let sections = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]

            // Configure footer view content
            var configuration = footerView.defaultContentConfiguration()
            if sections.title == "Внешний вид" {
                configuration.text = "Настройте внешний вид"
            } else if sections.title == "Обучение" {
                configuration.text = "Укажите количество изучаемых слов"
            } else {
                configuration.text = "Показать начальный экран при следующей загрузке"
            }
            footerView.contentConfiguration = configuration
        }
        
        // MARK: Define supplementary view provider
        dataSource.supplementaryViewProvider = { [unowned self]
            (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            
            if elementKind == UICollectionView.elementKindSectionHeader {
                // Dequeue header view
                return self.collectionView.dequeueConfiguredReusableSupplementary(
                    using: headerRegistration, for: indexPath)
            } else {
                // Dequeue footer view
                return self.collectionView.dequeueConfiguredReusableSupplementary(
                    using: footerRegistration, for: indexPath)
            }
        }
        
        // MARK: Setup snapshot
        var dataSourceSnapshot = NSDiffableDataSourceSnapshot<HeaderItem, SFSymbolItem>()
        
        // Create collection view section based on number of HeaderItem in modelObjects
        dataSourceSnapshot.appendSections(modelObjects)
        
        // Loop through each header item to append symbols to their respective section
        for headerItem in modelObjects {
            dataSourceSnapshot.appendItems(headerItem.symbols, toSection: headerItem)
        }
        dataSource.apply(dataSourceSnapshot, animatingDifferences: false)
    }
    
    
    @objc func stepperChanged(stepper: UIStepper) {
        labelForCell.text = String(Int(stepper.value))
        let value = stepper.value
        UserDefaults.standard.set(value, forKey: "amountOfWords")
    }
       
    @objc func switchChanged(mySwitch: UISwitch) {
        let tag = mySwitch.tag
        switch tag {
            case 0:
                if mySwitch.isOn == true {
                    UserDefaults.standard.set(true, forKey: "dark_mode")
                    DispatchQueue.main.async {
                        Theme.dark.setActive()
                    }
                } else {
                    UserDefaults.standard.set(false, forKey: "dark_mode")
                    DispatchQueue.main.async {
                        Theme.light.setActive()
                    }
                }
            case 1:
                if mySwitch.isOn == true {
                    UserDefaults.standard.set(true, forKey: "leftMode")
                } else {
                    UserDefaults.standard.set(false, forKey: "leftMode")
                }
            default:
                return
        }
    }
    
    @objc func launchAppWithOnboarding(mySwitch: UISwitch) {
        if mySwitch.isOn == true {
            // Onboarding is switch off
            UserDefaults.standard.set(false, forKey: "launchedBefore")
        } else {
            // Onboarding is switch on
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }
}
