//
//  KeyboardViewController.swift
//  MyIosKeyboard
//
//  Created by Mediana Abdelkarim on 22/05/2023.
//

import UIKit



class KeyboardViewController: UIInputViewController {
    
    @IBOutlet var keyButtons: [UIButton]!
    @IBOutlet weak var firstSuggestion: UIButton!
    @IBOutlet weak var secondSuggestion: UIButton!
    @IBOutlet weak var thirdSuggestion: UIButton!
    @IBOutlet weak var suggestionStack: UIStackView!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    
    // Variables
    var popUpView: UIView!
    var selectedButton: UIButton?
    var buttonX: UIButton?
    var micVc: MicViewController?
    var emojisVc: EmojisViewController?
    var settingsVc: SettingsViewController?
    var suggestions: [String] {
        loadSuggestionsFromJSONFile() ?? []
    }
    var suggestionEnable: Bool = false


    private var proxy: UITextDocumentProxy {
        return textDocumentProxy
    }
    
    var chosingKeyboard: Keyboard = .Letters
    var shiftMode: Shift = .Maj
    let lettersbutton = [
                          "A", "Z", "E", "R", "T", "Y", "U", "I", "O", "P",
                          "Ɓ", "S", "D", "F", "G", "H", "J", "K", "L",
                          "⬆", "W", "Ɗ", "C", "V", "B", "N", "M", "⌫",
                          "123", "😊", "nafasi",  "kurudi"
                        ]
    
    let characters1 = [
                        "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
                        ",", ".", "?", "!", "'", "\"", "-", "+", "=",
                        "#+=", "/", "\\", "<", ">", "[", "]", "{","⌫",
                        "ABC", "😊", "nafasi",  "kurudi"
                      ]
    
    let characters2 = [
                        "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
                        "}", "(", ")", "#", "%", "^", "*", ":",";",
                        "#+=", ";", "_", "@", "&", "$", "€", "£","⌫",
                        "ABC", "😊", "nafasi",  "kurudi"
                      ]

    
   // Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var newFrame = self.view.frame
        newFrame.size.height = 400
        self.view.frame = newFrame
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillLetters(mode: shiftMode)
        
//        selectedButton = getButtonByTag(buttons: keyButtons , tag: 10) // 21
//        buttonX = getButtonByTag(buttons: keyButtons , tag: 21)
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:)))
        longGesture.minimumPressDuration = 1.2
        let longGestureII = UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:)))
        longGesture.minimumPressDuration = 1.2
        getButtonByTag(buttons: keyButtons , tag: 10).addGestureRecognizer(longGesture)
        getButtonByTag(buttons: keyButtons , tag: 21).addGestureRecognizer(longGestureII)

       // Use Bandel Settings
       // NotificationCenter.default.addObserver(self, selector: #selector(defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
       // defaultsChanged()
        
        setUpSettings()
        setUpView()
        
    }
    
    private func setUpView(){
        
        for button in keyButtons {
            button.addShadow(opacity: 0.6)
        }
        micButton.addShadow(opacity: 0.6)
        settingsButton.addShadow(opacity: 0.6)
    }
    
    
    private func setUpSettings() {
        getButtonByTag(buttons: keyButtons , tag: 29).isHidden = !UserDefaults.standard.getValue(Of: .emojis)
        micButton.isHidden = !UserDefaults.standard.getValue(Of: .mic)
        suggestionEnable = UserDefaults.standard.getValue(Of: .suggestion)
    }
    
    private func loadSuggestionsFromJSONFile() -> [String]? {
        if let path = Bundle.main.path(forResource: "suggestion", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let words = json as? [String] {
                    return words
                }
            } catch {
                print("Error reading JSON file: \(error)")
            }
        }
        return nil
    }
    
    func filterSuggestions(with input: String) -> [String] {
        return suggestions.filter { $0.lowercased().contains(input.lowercased()) }
            .sorted { $0.count < $1.count }
            .prefix(3)
            .map { $0 }
    }
    
    @objc func longPress( sender: Any) {
        let longPressGesture = sender as! UILongPressGestureRecognizer
        if longPressGesture.state != UIGestureRecognizer.State.began {
            return
        }
        let selectedButton =  getButtonByTag(buttons: keyButtons , tag: (sender as AnyObject).view?.tag ?? 0)
       // let tapLocation = longPressGesture.location(in: self.view)
        
        
      
        
        let viewHeight = selectedButton.frame.height + 10
        let viewWidth  = selectedButton.frame.width + 15
                
        let point = selectedButton.convert(selectedButton.frame.origin, to: self.view)
        let decal = selectedButton.tag == 21 ? 55.0 : 0.0

        popUpView = UIView(frame: CGRect(x: selectedButton.frame.origin.x + decal , y: point.y - viewHeight + 5 , width: viewWidth , height: viewHeight))
        popUpView.backgroundColor = UIColor.white
        popUpView.addShadow(opacity: 0.6)
 
        let btn0: UIButton = UIButton()
        btn0.setTitle(selectedButton.tag == 21 ? "x" : "q", for: .normal)
        btn0.setTitleColor(UIColor.black, for: .normal)
        btn0.frame = popUpView.bounds
        popUpView.addSubview(btn0)
        btn0.addTarget(self, action: #selector(self.buttonAction(sender:)),
                       for: UIControl.Event.touchUpInside)
//        for btn in self.keyButtons {
//            btn.alpha = 0.8
//        }
        self.view.addSubview(popUpView)

    }
    
    @objc func buttonAction( sender: UIButton) {
        //Than remove popView
        proxy.insertText(shiftMode == .Maj ? sender.title(for: .normal)?.uppercased() ?? "" : sender.title(for: .normal)?.lowercased() ?? "")
        for btn in self.keyButtons {
            btn.alpha = 1
        }
        popUpView.removeFromSuperview()
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
    
    private func getButtonByTag(buttons: [UIButton], tag: Int) -> UIButton {
        for button in buttons {
            if button.tag == tag {
                return button
            }
        }
        return UIButton()
    }
    
    // Overide Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToVoiceKeyboard" {
            if let _micVC = segue.destination as? MicViewController {
                self.micVc = _micVC
                self.micVc?.delegate = self
            }
        }else if
            segue.identifier == "ToEmojiKeyboard" {
            if let _emojisVC = segue.destination as? EmojisViewController {
                self.emojisVc = _emojisVC
                self.emojisVc?.delegate = self
            }
        }else if
            segue.identifier == "ToSettingsKeyboard" {
            if let _settingsVC = segue.destination as? SettingsViewController {
                self.settingsVc = _settingsVC
                self.settingsVc?.delegate = self
            }
        }
    }
    
    // Use Bandel Settings
    @objc func defaultsChanged(){
        if UserDefaults.standard.bool(forKey: "mic_preference") {
            self.view.backgroundColor = UIColor.red
        }
        else {
            self.view.backgroundColor = UIColor.green
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    private func fillSuggestion(withe word: String){
        let suggestions = self.filterSuggestions(with: word)
        firstSuggestion.setTitle( word == "" ? "" : "\"\(word)\"", for: .normal)
        if  suggestions.count >= 1 && suggestionEnable {
            secondSuggestion.setTitle(suggestions[0], for: .normal)
        }else{
            secondSuggestion.setTitle("", for: .normal)
        }
        if suggestions.count >= 2 && suggestionEnable {
            thirdSuggestion.setTitle(suggestions[1], for: .normal)
        }else{
            thirdSuggestion.setTitle("", for: .normal)
        }
    }
    
    private func clearSuggestion(){
        firstSuggestion.setTitle("", for: .normal)
        secondSuggestion.setTitle("", for: .normal)
        thirdSuggestion.setTitle("", for: .normal)
    }
    
    private func getTheLastWordInProxy()-> String{
        if let text = self.proxy.documentContextBeforeInput {
            return getLastWord(from: text) ?? ""
        }
        return ""
    }
    
    func getLastWord(from text: String) -> String? {
        let words = text.components(separatedBy: .whitespaces)
        return words.last
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
        //suggestionStack.isHidden = false
        UIView.animate(withDuration: 0.2, animations:{
            sender.transform = CGAffineTransformScale(.identity, 1.2, 1.2)
        }){_ in
            sender.transform = CGAffineTransformScale(.identity, 1.0, 1.0)
        }
        
        if chosingKeyboard == .Letters {
            let letter = shiftMode == .Maj ? lettersbutton[sender.tag].uppercased() : lettersbutton[sender.tag].lowercased()
            proxy.insertText(letter)
            fillLetters(mode: .Min)
            fillSuggestion(withe: self.getTheLastWordInProxy())
        }else{
            proxy.insertText(shiftMode == .FirstChars ?  characters1[sender.tag] : characters2[sender.tag])
        }
        
        if (popUpView != nil){
            popUpView.removeFromSuperview()
        }
    }
    
    @IBAction func deleteKeyPressed(_ sender: UIButton) {
        proxy.deleteBackward()
        fillSuggestion(withe: getTheLastWordInProxy())
        
    }
    
    @IBAction func spaceKeyPressed(_ sender: UIButton) {
        proxy.insertText(" ")
        clearSuggestion()
    }
    
    @IBAction func returnKeyPressed(_ sender: UIButton) {
        proxy.insertText("\n")
    }
    
    @IBAction func suggestionPressed(_ sender: UIButton) {
        
        if sender != firstSuggestion {
            let lastString = getTheLastWordInProxy()
            var alltext = self.proxy.documentContextBeforeInput
            alltext =  alltext?.replacingOccurrences(of: lastString, with: sender.title(for: .normal) ?? "")
            while proxy.hasText {
                proxy.deleteBackward()
            }
            
            proxy.insertText(alltext ?? "")
            clearSuggestion()
            proxy.insertText(" ")
        }
    }
    
    
}
 

extension KeyboardViewController : KeyboardViewControllerDelegate {
    func insertText(text: String){
        self.proxy.insertText(text)
    }
    
    func clearTextInKeyboard() {
        while proxy.hasText {
            proxy.deleteBackward()
        }
    }
    
    func deleteBackWard() {
        proxy.deleteBackward()
    }
    
    func refreshSettings() {
        setUpSettings()
    }
}
 


protocol KeyboardViewControllerDelegate: AnyObject {
    func insertText(text: String)
    func clearTextInKeyboard()
    func deleteBackWard()
    func refreshSettings()
}


  
extension UIView {
    func addShadow(opacity: Float){
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height : -5.0)
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = 5
    }
}
