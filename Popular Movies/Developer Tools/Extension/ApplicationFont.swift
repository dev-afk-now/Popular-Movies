//
//  ApplicationFont.swift
//  Popular Movies
//
//  Created by devmac on 20.01.2022.
//

import UIKit

extension UIFont {
    static func applicatonFont(_ type: ApplicationFonts = .avenirBookOblique,
                               size: CGFloat = 15) -> UIFont {
        let fontName = type.rawValue
        return UIFont(name: fontName,
                      size: size) ?? UIFont.systemFont(ofSize: size,
                                                       weight: .regular)
    }
}

enum ApplicationFonts: String {
    case futuraMedium = "Futura Medium"
    case avenirMedium = "Avenir Medium"
    case avenirHeavy = "Avenir Heavy"
    case avenirBookOblique = "Avenir Book Oblique"
    case avenirHeavyOblique = "Avenir Heavy Oblique"
}
