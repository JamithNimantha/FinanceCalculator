//
//  MainTabController.swift
//  FinanceCalculator
//
//  Created by Jamith Nimantha on 2023-07-29.
//

import UIKit

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    @IBOutlet weak var userInterfaceTabBarItem: UITabBar!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarAppearance()
    }
    
    // MARK: - Private Methods
    
    private func setupTabBarAppearance() {
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
    }
}
