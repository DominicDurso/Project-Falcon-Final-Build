//
//  Scraper.swift
//  Project Falcon V4
//
//  Created by Frank Ratmiroff on 9/24/24.
//

import UIKit
import WebKit

class Scraper: NSObject, WKNavigationDelegate {
    var webView: WKWebView!
    var onDataScraped: ((String?) -> Void)?
    
    override init() {
        super.init()
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1"

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            webView.frame = window.bounds
            window.addSubview(webView)
        }
    }
    
    func scrapeData(from url: URL = URL(string: "https://www.palmertrinity.org/calendar")!) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    
    // Load the webpage and scrape the content
    func loadWebsite(urlString: String = "https://www.palmertrinity.org/calendar") {
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
    
    // WKNavigationDelegate method when page finishes loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let pageTitle = """
        document.documentElement.outerHTML;
        """
        webView.evaluateJavaScript(pageTitle) { [weak self] (result, error) in
            guard let self = self else { return }
            if let data = result as? String {
                if data.contains("May 30") || data.contains("5/30") {
                    print("=== POTENTIAL MAY 30 EVENTS ===")
                    print(data)
                    print("================================")
                }
                DataManager.shared.globalData = data
                self.onDataScraped?(data)
            } else  {
                self.onDataScraped?(nil)
            }
        }
    }
    
    // Method to print the scraped data
    func printScrapedData() {
        if let data = onDataScraped {
           print("Scraped Data: \(data)")
        } else {
  //          print("No Valid Data Scraped")
        }
    }
}
