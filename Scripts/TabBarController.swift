//
//  TabBarController.swift
//  Project Falcon V4
//
//  Created by Daniel Da Silva Mullane on 10/16/24.
//


import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add swipe gesture recognizers
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
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

