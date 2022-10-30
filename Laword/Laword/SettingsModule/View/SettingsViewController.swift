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
                SFSymbolItem(name: "Темная тема", imageName: "powersleep"),
                SFSymbolItem(name: "Кнопки слева", imageName: "rectangle.lefthalf.inset.filled.arrow.left"),
                SFSymbolItem(name: "Язык", imageName: "globe"),
            ])
        ]
    
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
            collectionView.backgroundColor = ColorAppearence.backgroudColor.uiColor()
            view.addSubview(collectionView)
            view.backgroundColor = ColorAppearence.backgroudColor.uiColor()
            

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
                
                // Dequeue symbol cell
                let cell = collectionView.dequeueConfiguredReusableCell(using: symbolCellRegistration,
                                                                        for: indexPath,
                                                                        item: symbolItem)
                let switchInCell = UISwitch()
                switchInCell.isOn = false
                               
                cell.addSubview(switchInCell)
                
                switchInCell.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)


                
                switchInCell.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    switchInCell.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10.0),
                    switchInCell.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 0.0)
                ])
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
                configuration.textProperties.color = ColorAppearence.textColor.uiColor()
                configuration.directionalLayoutMargins = .init(top: 20.0, leading: 0.0, bottom: 10.0, trailing: 0.0)
                
                
                // Apply the configuration to header view
                headerView.contentConfiguration = configuration
            }
            
            let footerRegistration = UICollectionView.SupplementaryRegistration
            <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionFooter) {
                [unowned self] (footerView, elementKind, indexPath) in
                
                let headerItem = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
                let symbolCount = headerItem.symbols.count
                
                // Configure footer view content
                var configuration = footerView.defaultContentConfiguration()
                configuration.text = "Symbol count: \(symbolCount)"
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

    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        UserDefaults.standard.set(value, forKey: "dark_mode")
        print("switch status in Userdefaults: \(UserDefaults.standard.bool(forKey: "dark_mode"))")
    }
}
