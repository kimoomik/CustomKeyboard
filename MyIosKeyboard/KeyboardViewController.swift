//
//  KeyboardViewController.swift
//  MyIosKeyboard
//
//  Created by Mediana Abdelkarim on 22/05/2023.
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


class KeyboardViewController: UIInputViewController {
    
    @IBOutlet var keyButtons: [UIButton]!
    
    @IBOutlet weak var firstSuggestion: UIButton!
    @IBOutlet weak var secondSuggestion: UIButton!
    @IBOutlet weak var thirdSuggestion: UIButton!
    @IBOutlet weak var suggestionStack: UIStackView!
    
    
    // Variables
    private var proxy: UITextDocumentProxy {
        return textDocumentProxy
    }
    var chosingKeyboard: Keyboard = .Letters
    var shiftMode: Shift = .Maj
    let lettersbutton = [
                          "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P",
                          "A", "S", "D", "F", "G", "H", "J", "K", "L",
                          "⬆", "Z", "X", "C", "V", "B", "N", "M", "⌫",
                          "123", "😊", "Espace",  "Entrer"
                        ]
    
    let characters1 = [
                        "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
                        ",", ".", "?", "!", "'", "\"", "-", "+", "=",
                        "#+=", "/", "\\", "<", ">", "[", "]", "{","⌫",
                        "ABC", "😊", "Espace",  "Entrer"
                      ]
    
    let characters2 = [
                        "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
                        "}", "(", ")", "#", "%", "^", "*", ":",";",
                        "#+=", ";", "_", "@", "&", "$", "€", "£","⌫",
                        "ABC", "😊", "Espace",  "Entrer"
                      ]

    
   // Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let standardKeyboardHeight = self.inputView?.frame.height ?? 0
        var newFrame = self.view.frame
        newFrame.size.height = standardKeyboardHeight
        self.view.frame = newFrame
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillLetters(mode: shiftMode)
        suggestionStack.isHidden = true
    }
    
    override func textWillChange(_ textInput: UITextInput?) {

        // Called when the text will change
       
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // Called when the text has changed
        //suggestionStack.isHidden = false

    }
    
    
    private func fillLetters(mode: Shift){
        chosingKeyboard = .Letters
        shiftMode = mode
        for button in  keyButtons {
            button.setTitle( mode == .Maj ?  lettersbutton[button.tag].uppercased() : lettersbutton[button.tag].lowercased() , for: .normal)
        }
    }
    
    private func fillCaracters(mode: Shift){
        chosingKeyboard = .Chars
        shiftMode = mode
        for button in  keyButtons {
            button.setTitle(mode == .FirstChars ?  characters1[button.tag] : characters2[button.tag] , for: .normal)
        }
    }
    
    private func getTextFromTextInput(_ textInput: UITextInput?) -> String? {
        if let textRange = textInput?.selectedTextRange {
            if let text = textInput?.text(in: textRange) {
                return text
            }
        }
        return nil
    }
    
    
    
   // Action Button

    @IBAction func numbers(_ sender: Any) {
         if chosingKeyboard == .Letters {
            fillCaracters(mode: shiftMode)
        }else{
            fillLetters(mode: shiftMode == .FirstChars ? .SecondChars : .FirstChars)
        }
    }
    
    @IBAction func shiftButton(_ sender: Any) {
     
        if chosingKeyboard == .Chars {
            fillCaracters(mode: shiftMode == .FirstChars ? .SecondChars : .FirstChars)
        }else{
            fillLetters(mode: shiftMode == .Maj ? .Min : .Maj)
        }
    }
    
    @IBAction func keyPressed(_ sender: UIButton) {
        suggestionStack.isHidden = false
        UIView.animate(withDuration: 0.2, animations:{
            sender.transform = CGAffineTransformScale(.identity, 1.2, 1.2)
        }){_ in
            sender.transform = CGAffineTransformScale(.identity, 1.0, 1.0)
        }
        
        if chosingKeyboard == .Letters {
            proxy.insertText(lettersbutton[sender.tag])
            fillLetters(mode: .Min)
            if let text = self.proxy.documentContextBeforeInput{
                firstSuggestion.setTitle(text, for: .normal)
            }
        }else{
            proxy.insertText(shiftMode == .FirstChars ?  characters1[sender.tag] : characters2[sender.tag])
        }
    }
    
    @IBAction func deleteKeyPressed(_ sender: UIButton) {
        proxy.deleteBackward()
    }
    
    @IBAction func spaceKeyPressed(_ sender: UIButton) {
        proxy.insertText(" ")
    }
    
    @IBAction func returnKeyPressed(_ sender: UIButton) {
        proxy.insertText("\n")
    }
    
}
 



 

