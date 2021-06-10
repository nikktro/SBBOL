//
//  AnimationTabBarController.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 08.06.2021.
//

import UIKit

final class AnimatedTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
}

// MARK: - UITabBarControllerDelegate
extension AnimatedTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          animationControllerForTransitionFrom fromVC: UIViewController,
                          to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarAnimatedTransitioning()
    }
    
}

