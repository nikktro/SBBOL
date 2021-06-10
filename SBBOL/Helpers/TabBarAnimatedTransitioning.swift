//
//  TabBarAnimatedTransitioning.swift
//  SBBOL
//
//  Created by Nikolay Trofimov on 10.06.2021.
//

import UIKit

final class TabBarAnimatedTransitioning: NSObject,
                                         UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext:
                            UIViewControllerContextTransitioning) {
        guard let destination = transitionContext.view(
                forKey: UITransitionContextViewKey.to) else { return }
        
        destination.alpha = 0.0
        destination.transform = .init(scaleX: 1.0, y: 1.0)
        transitionContext.containerView.addSubview(destination)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {
                        destination.alpha = 1.0
                        destination.transform = .identity
                       }, completion: { transitionContext.completeTransition($0) })
    }
    
    func transitionDuration(using transitionContext:
                                UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
}
