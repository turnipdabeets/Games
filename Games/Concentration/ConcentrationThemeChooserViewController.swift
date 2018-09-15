//
//  ConcentrationThemeChooserViewController.swift
//  Games
//
//  Created by Anna Garcia on 9/14/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    private var lastSeguedViewController: ConcentrationViewController?
    
    private var theme = Theme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Choose A Theme"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
        ) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let cvc = segue.destination as? ConcentrationViewController {
                setTheme(of: cvc, by: sender)
                lastSeguedViewController = cvc
            }
        }
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            // allows to change theme in middle of game for ipad
            setTheme(of: cvc, by: sender)
        } else if let cvc = lastSeguedViewController {
            // allows to change theme in middle of game for iphone after selecting a theme
            setTheme(of: cvc, by: sender)
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private func setTheme(of: ConcentrationViewController, by: Any?) -> Void {
        if let buttonIdentifier = (by as? UIButton)?.restorationIdentifier {
            let selectedTheme = getTheme(identifier: buttonIdentifier)
            of.theme = selectedTheme
        }
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
}
