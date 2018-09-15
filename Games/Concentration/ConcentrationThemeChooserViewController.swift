//
//  ConcentrationThemeChooserViewController.swift
//  Games
//
//  Created by Anna Garcia on 9/14/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController {
    
    private var theme = Theme()
    
    @IBAction func changeTheme(_ sender: Any) {
        performSegue(withIdentifier: "Choose Theme", sender: sender)
    }
    private func getTheme(identifier: String) -> [String] {
        switch identifier {
        case "halloween":
            return theme.getThemeIcons(by: Theme.Theme.halloween)
        case "love":
            return theme.getThemeIcons(by: Theme.Theme.love)
        case "animal":
            return theme.getThemeIcons(by: Theme.Theme.animal)
        case "water":
            return theme.getThemeIcons(by: Theme.Theme.waterCreatures)
        case "weather":
            return theme.getThemeIcons(by: Theme.Theme.weather)
        case "plants":
            return theme.getThemeIcons(by: Theme.Theme.plants)
        case "random":
            return theme.getRandomThemeIcons()
        default:
            return theme.getRandomThemeIcons()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let buttonIdentifier = (sender as? UIButton)?.restorationIdentifier, let cvc = segue.destination as? ConcentrationViewController {
                let selectedTheme = getTheme(identifier: buttonIdentifier)
                print("selectedTheme", selectedTheme)
                cvc.theme = selectedTheme
            }
        }
    }
    
}
