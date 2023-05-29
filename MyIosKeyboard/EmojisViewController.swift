//
//  EmojisViewController.swift
//  MyIosKeyboard
//
//  Created by Mediana Abdelkarim on 29/05/2023.
//

import UIKit

class EmojisViewController: UIInputViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private var dataSource: EmojiDataSource!
    
    private var proxy : UITextDocumentProxy {
        return textDocumentProxy
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = EmojiDataSource()
    }
    
    
    @IBAction func switchToLetters(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    
    @IBAction func deleteText(_ sender: Any) {
        proxy.deleteBackward()
    }
    
}
extension EmojisViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
    }
}


class EmojiCell: UICollectionViewCell {
    @IBOutlet  weak var emojiBtn: UIButton!
    
    func configure(with emoji: String) {
        emojiBtn.setTitle(emoji, for: .normal)
    }
    
    @IBAction func selectEmoji(_ sender: UIButton) {
        UIView.animate(withDuration: 0.4, animations:{
            sender.transform = CGAffineTransformScale(.identity, 2.0, 2.0)
        }){_ in
            sender.transform = CGAffineTransformScale(.identity, 1.0, 1.0)
        }
        print(sender.title(for: .normal))
    }
    
}


class EmojiDataSource: NSObject, UICollectionViewDataSource {
    var emojis: [String] = []
    
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
        cell.configure(with: emoji)
        cell.emojiBtn.addTarget(self, action: #selector(emojiTapped), for: .touchUpInside)
        return cell
    }
    
    @objc private func emojiTapped() {
        
    }
}

