//
//  SettingsViewController.swift
//  MyIosKeyboard
//
//  Created by Mediana Abdelkarim on 03/06/2023.
//

import UIKit

class SettingsViewController: UIInputViewController {
    
    // MARK: - Outlet

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables

    var data : [Setting] = []
    private var dataSource: SettingsDataSource!
    weak var delegate: KeyboardViewControllerDelegate?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        dataSource = SettingsDataSource()
     }
    
    // MARK: - Private Functions

    // MARK: - Actions

    @IBAction func closeSettings(_ sender: Any) {
        delegate?.refreshSettings()
        self.dismiss(animated: false)
    }
    
}

// MARK: - UICollectionViewDelegate

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.tableView(tableView, numberOfRowsInSection: section)
    }
     
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
    
    private func tableView(_ tableView: UITableView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
    }
}

// MARK: - UICollectionViewCell

class SettingCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var isEnable: UISwitch!
    
    var setting : Setting!
    
 
    func configure(with setting: Setting){//, delegate: KeyboardViewControllerDelegate) {
        self.titleLabel.text = setting.title
        self.descriptionLabel.text = setting.description
        self.isEnable.isOn = UserDefaults.standard.getValue(Of: setting.key)
        self.setting = setting
    }
    
 
    @IBAction func setValue(_ sender: UISwitch) {
        UserDefaults.standard.setValue(Of: setting.key, value: sender.isOn)
    }
    
}

// MARK: - EmojiDataSource

class SettingsDataSource: NSObject, UITableViewDataSource {
    
    var data : [Setting] = []
 
    private func fillData() -> [Setting]{
        return [
            Setting(title: "Activer Mic", key: .mic, description: "Le Lorem Ipsum est simplement du faux texte employé dans la composition et la mise en page avant impression.") ,
            Setting(title: "Activer Emoji's", key: .emojis, description: ""),
            
            Setting(title: "Activer Suggestion", key: .suggestion, description: "Le Lorem Ipsum est simplement du faux texte employé dans la composition")
                ]
        
//        Setting(title: "Activer Annalytics", key: .analytics, description: "Le Lorem Ipsum est simplement du faux texte employé dans la composition"),
    }
    
    override init() {
        super.init()
        self.data = self.fillData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        let setting = data[indexPath.item]
        cell.configure(with: setting)//,delegate: self.delegate!)
        return cell
    }
     
}
