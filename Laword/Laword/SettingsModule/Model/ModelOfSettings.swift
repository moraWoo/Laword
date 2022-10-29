//
//  ModelOfSettings.swift
//  Laword
//
//  Created by Ильдар on 23.10.2022.
//

import Foundation
import UIKit

enum Section {
    case main
}

enum ListItem: Hashable {
    case header(HeaderItem)
    case symbol(SFSymbolItem)
}

struct HeaderItem: Hashable {
    let title: String
    let symbols: [SFSymbolItem]
}

struct SFSymbolItem: Hashable {
    let name: String
    let imageName: String
    let image: UIImage
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
        self.image = UIImage(systemName: imageName)!
    }
}
