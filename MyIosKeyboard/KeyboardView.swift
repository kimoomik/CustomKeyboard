//
//  KeyboardView.swift
//  MyIosKeyboard
//
//  Created by Mediana Abdelkarim on 22/05/2023.
//

import UIKit

class KeyboardView: UIInputView {
    let numberOfRows = 4
    let numberOfColumns = 10

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        //setupKeyboardButtons()
//        print("tata")
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        //setupKeyboardButtons()
//        print("toto")
//
//    }

    private func setupKeyboardButtons() {
        let buttonTitles = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P",
                            "A", "S", "D", "F", "G", "H", "J", "K", "L",
                            "⬆", "Z", "X", "C", "V", "B", "N", "M", "⌫",
                            "123", "😊", "↩", "␣"]

        let buttonWidth = bounds.width / CGFloat(numberOfColumns)
        let buttonHeight = bounds.height / CGFloat(numberOfRows)

        var xPosition: CGFloat = 0
        var yPosition: CGFloat = 0

        for row in 0..<numberOfRows {
            for column in 0..<numberOfColumns {
                let buttonIndex = row * numberOfColumns + column

                if buttonIndex < buttonTitles.count {
                    let button = UIButton(type: .system)
                    button.setTitle(buttonTitles[buttonIndex], for: .normal)
                    button.addTarget(self, action: #selector(keyboardButtonTapped(_:)), for: .touchUpInside)
                    button.frame = CGRect(x: xPosition, y: yPosition, width: buttonWidth, height: buttonHeight)
                    addSubview(button)
                }

                xPosition += buttonWidth

                if row == 2 && (column == 0 || column == numberOfColumns - 1) {
                    // Adjust the size of Shift and Delete buttons in the third row
                    let buttonWidthWithMargin = buttonWidth * 1.5
                    let buttonHeightWithMargin = buttonHeight
                    let shiftButtonFrame = CGRect(x: xPosition, y: yPosition, width: buttonWidthWithMargin, height: buttonHeightWithMargin)
                    let deleteButtonFrame = CGRect(x: xPosition + buttonWidth * CGFloat(numberOfColumns - 1) - buttonWidthWithMargin, y: yPosition, width: buttonWidthWithMargin, height: buttonHeightWithMargin)
                    viewWithTag(20)?.frame = shiftButtonFrame
                    viewWithTag(27)?.frame = deleteButtonFrame

                    xPosition += buttonWidthWithMargin
                }

                if row == 3 {
                    if column == 0 {
                        // Adjust the size of Number button in the fourth row
                        let buttonWidthWithMargin = buttonWidth
                        let buttonHeightWithMargin = buttonHeight
                        let numberButtonFrame = CGRect(x: xPosition, y: yPosition, width: buttonWidthWithMargin, height: buttonHeightWithMargin)
                        viewWithTag(28)?.frame = numberButtonFrame

                        xPosition += buttonWidthWithMargin
                    } else if column == 1 {
                        // Adjust the size of Emoji button in the fourth row
                        let buttonWidthWithMargin = buttonWidth
                        let buttonHeightWithMargin = buttonHeight
                        let emojiButtonFrame = CGRect(x: xPosition, y: yPosition, width: buttonWidthWithMargin, height: buttonHeightWithMargin)
                        viewWithTag(29)?.frame = emojiButtonFrame

                        xPosition += buttonWidthWithMargin
                    } else if column == 2 || column == 3 {
                        // Adjust the size of Enter button in the fourth row
                        let buttonWidthWithMargin = buttonWidth * 2
                        let buttonHeightWithMargin = buttonHeight
                        let enterButtonFrame = CGRect(x: xPosition, y: yPosition, width: buttonWidthWithMargin, height: buttonHeightWithMargin)
                        viewWithTag(30)?.frame = enterButtonFrame

                        xPosition += buttonWidthWithMargin
                    } else if column == 4 {
                        // Adjust the size of Space button in the fourth row
                        let buttonWidthWithMargin = buttonWidth * 6
                        let buttonHeightWithMargin = buttonHeight
                        let spaceButtonFrame = CGRect(x: xPosition, y: yPosition, width: buttonWidthWithMargin, height: buttonHeightWithMargin)
                        viewWithTag(31)?.frame = spaceButtonFrame

                        xPosition += buttonWidthWithMargin
                    }
                }
            }

            xPosition = 0
            yPosition += buttonHeight
        }
    }

    @objc private func keyboardButtonTapped(_ sender: UIButton) {
        // Handle button tap events
        guard let buttonTitle = sender.currentTitle else {
            return
        }

        print("Button tapped: \(buttonTitle)")
    }
}


extension UIView {
  
    // Rounded corner raius
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    // Shadow color
    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue.cgColor
        }
    }
    
    // Shadow offsets
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    // Shadow opacity
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    // Shadow radius
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
    
    // Border width
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    // Border color
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    // Background color
    @IBInspectable var layerBackgroundColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.backgroundColor!)
        }
        set {
            self.backgroundColor = nil
            self.layer.backgroundColor = newValue.cgColor
        }
    }
  
    // Create bezier path of shadow for rasterize
    @IBInspectable var enableBezierPath: Bool {
        get {
            return self.layer.shadowPath != nil
        }
        set {
            if enableBezierPath {
                self.layer.shadowPath = UIBezierPath(roundedRect: self.layer.bounds, cornerRadius: self.layer.cornerRadius).cgPath
            } else {
                self.layer.shadowPath = nil
            }
        }
    }
    
    // Mask to bounds controll
    @IBInspectable var maskToBounds: Bool {
        get{
            return self.layer.masksToBounds
        }
        set {
            self.layer.masksToBounds = newValue
        }
    }
    
    // Rasterize option
    @IBInspectable var rasterize: Bool {
        get {
            return self.layer.shouldRasterize
        }
        set {
            self.layer.shouldRasterize = newValue
            self.layer.rasterizationScale = UIScreen.main.scale
        }
    }
}
