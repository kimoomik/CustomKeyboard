//
//  CustomKeyboardView.swift
//  MyIosKeyboard
//
//  Created by Mediana Abdelkarim on 27/05/2023.
//

import UIKit

class CustomKeyboardView: UIInputView {
    
    weak var delegate: CustomKeyboardDelegate?
    @IBOutlet weak var contentView: UIView?

    @IBOutlet weak var button: UILabel!
    
    // Override init(frame:style:) to load the XIB file
    override init(frame: CGRect, inputViewStyle: UIInputView.Style) {
        super.init(frame: frame, inputViewStyle: inputViewStyle)
        //commonInit()
    }
    
    // Implement required initializer for Interface Builder (IB)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //commonInit()
    }
    
    func commonInit() {
        print("here")
        let nib = UINib(nibName: "CustomKeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: self, options: nil)
        if let view = objects.first as? UIView{
            print("hore")
            self.contentView = view
            self.addSubview(view)
            
                        view.translatesAutoresizingMaskIntoConstraints = false
                        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
                        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
                        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
//            Bundle.main.loadNibNamed(String(describing: CustomKeyboardView.self), owner: self, options: nil)
//
//            guard let contentView = contentView else { return }
//            self.addSubview(contentView)
        }
    
//    private func commonInit() {
//        // Load the XIB file
//        if let view = Bundle.main.loadNibNamed("CustomKeyboardView", owner: self, options: nil)?.first as? UIView {
//            addSubview(view)
//
//            // Set the constraints or frame of the loaded view to fit within the CustomKeyboardView
//            // For example, if using constraints:
//            view.translatesAutoresizingMaskIntoConstraints = false
//            view.topAnchor.constraint(equalTo: topAnchor).isActive = true
//            view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//            view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//            view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        }
//    }
    
    // Other methods and logic
    
    @IBAction func buttonTapped(_ sender: UIButton) {
            delegate?.customKeyboardDidTapButton(sender)
        }
        
}


protocol CustomKeyboardDelegate: AnyObject {
    func customKeyboardDidTapButton(_ button: UIButton)
    // Define additional delegate methods as needed
}
