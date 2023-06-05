//
//  SettingsBundleHelper.swift
//  MyIosKeyboard
//
//  Created by Mediana Abdelkarim on 03/06/2023.
//

import Foundation

class SettingsBundleHelper {
    struct SettingsBundleKeys {
        static let micSettingsOut = "mic_preference"
        static let micSetting = "mic_setting"
        static let suggestionSetting = "suggestion_setting"
        static let emojisSettings = "emojis_setting"
        static let analyticsSettings = "analytics_setting"
    }
}

public enum SettingsKeys : String {
    case mic
    case suggestion
    case emojis
    case analytics
}

extension UserDefaults {

    //MARK: Check Enabled
    func setValue(Of key: SettingsKeys, value: Bool) {
        set(value, forKey: key.rawValue)
        //synchronize()
    }

    func getValue(Of key: SettingsKeys)-> Bool {
        return bool(forKey: key.rawValue)
    }
}

