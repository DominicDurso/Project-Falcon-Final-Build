//
//  Swiper.swift
//  Project Falcon V4
//
//  Created by Daniel Da Silva Mullane on 10/16/24.
//


import UIKit

class SwipeController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        
        if gesture.direction == .left {
            if selectedIndex < (viewControllers?.count ?? 0) - 1 {
                selectedIndex += 1 // Move to the next tab
            }
        } else if gesture.direction == .right {
            if selectedIndex > 0 {
                selectedIndex -= 1 // Move to the previous tab
            }
        }
    }
}
