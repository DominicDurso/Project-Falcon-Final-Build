//
//  DiningController.swift
//  Project Falcon V4
//
//  Created by Daniel Da Silva Mullane on 10/15/24.
//

import UIKit
import WebKit
import SwiftSoup

class DiningController: UIViewController, WKNavigationDelegate {
    
    // Sagedining ViewController
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showMenu()
    }
    
    func showMenu() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set the navigation delegate to self
        webView.navigationDelegate = self
        
        // Add the WKWebView to the view hierarchy
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set constraints for the web view to be within the safe area
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
        // Start loading the web page
        if let url = URL(string: "https://www.sagedining.com/sites/palmertrinity/menu") { // Replace with your target URL
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        showMenu()
    }
    
    
/*
    // WKNavigationDelegate method to know when the page has finished loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //print("Page loaded")
    }
*/
}

