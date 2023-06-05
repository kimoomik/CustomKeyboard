//
//  EmojisViewController.swift
//  MyIosKeyboard
//
//  Created by Mediana Abdelkarim on 29/05/2023.
//

import UIKit

class EmojisViewController: UIInputViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    
    private var dataSource: EmojiDataSource!
    weak var delegate: KeyboardViewControllerDelegate?

    // MARK: - View Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = EmojiDataSource()
    }
    
    // MARK: - Actions
    
    @IBAction func switchToLetters(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    
    @IBAction func deleteText(_ sender: Any) {
        delegate?.deleteBackWard()
    }
    
}

// MARK: - UICollectionViewDelegate

extension EmojisViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        dataSource.delegate = self.delegate
        return dataSource.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
    }
}

// MARK: - UICollectionViewCell

class EmojiCell: UICollectionViewCell {
    
    @IBOutlet  weak var emojiBtn: UIButton!
    var delegate: KeyboardViewControllerDelegate?
    
    func configure(with emoji: String, delegate: KeyboardViewControllerDelegate) {
        emojiBtn.setTitle(emoji, for: .normal)
        self.delegate = delegate
    }
    
    @IBAction func selectEmoji(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations:{
            sender.transform = CGAffineTransformScale(.identity, 2.5, 2.5)
        }){_ in
            sender.transform = CGAffineTransformScale(.identity, 1.0, 1.0)
        }
        delegate?.insertText(text: sender.title(for: .normal) ?? "")
    }
    
}

// MARK: - EmojiDataSource

class EmojiDataSource: NSObject, UICollectionViewDataSource {
    var emojis: [String] = []
    var delegate: KeyboardViewControllerDelegate?
    
    func getAllEmojis() -> [String] {
        var emojis: [String] = []
        for i in 0x1F600...0x1F64F {
            if let unicodeScalar = UnicodeScalar(i) {
                let emoji = String(unicodeScalar)
                emojis.append(emoji)
            }
        }
        return emojis.sorted()
    }
    
    override init() {
        super.init()
        self.emojis = self.getAllEmojis()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as! EmojiCell
        let emoji = emojis[indexPath.item]
        cell.configure(with: emoji,delegate: self.delegate!)
        return cell
    }
     
}

