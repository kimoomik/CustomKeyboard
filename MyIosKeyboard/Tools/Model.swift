//
//  CustomKeyboardView.swift
//  MyIosKeyboard
//
//  Created by Mediana Abdelkarim on 27/05/2023.
//

import UIKit


enum Keyboard {
    case Letters
    case Chars
    case CharsII
    case Emojis
    case Mic
}

enum Shift {
    case Maj
    case Min
    case FirstChars
    case SecondChars
}


protocol CustomKeyboardDelegate: AnyObject {
    func customKeyboardDidTapButton(_ button: UIButton)
    // Define additional delegate methods as needed
}

struct Setting {
    var title: String
    var key: SettingsKeys
    var description: String
}
