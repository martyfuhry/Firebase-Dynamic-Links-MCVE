//
//  AppDelegate.swift
//  DynamicLinksMCVE
//
//  Created by Marty Fuhry on 4/21/17.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // [START didfinishlaunching]
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Set deepLinkURLScheme to the custom URL scheme you defined in your
        // Xcode project.
        FIRApp.configure()
        return true
    }
    // [END didfinishlaunching]
    // [START openurl]
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return application(app, open: url, sourceApplication: nil, annotation: [:])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let dynamicLink = FIRDynamicLinks.dynamicLinks()?.dynamicLink(fromCustomSchemeURL: url)
        if let dynamicLink = dynamicLink {
            // Handle the deep link. For example, show the deep-linked content or
            // apply a promotional offer to the user's account.
            // [START_EXCLUDE]
            // In this sample, we just open an alert.
            let message = generateDynamicLinkMessage(dynamicLink)
            if #available(iOS 8.0, *) {
                showDeepLinkAlertView(withMessage: message)
            } else {
                // Fallback on earlier versions
            }
            // [END_EXCLUDE]
            return true
        }
        
        // [START_EXCLUDE silent]
        // Show the deep link that the app was called with.
        if #available(iOS 8.0, *) {
            showDeepLinkAlertView(withMessage: "openURL:\n\(url)")
        } else {
            // Fallback on earlier versions
        }
        // [END_EXCLUDE]
        return false
    }
    // [END openurl]
    // [START continueuseractivity]
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        guard let dynamicLinks = FIRDynamicLinks.dynamicLinks() else {
            return false
        }
        let handled = dynamicLinks.handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
            // [START_EXCLUDE]
            let message = self.generateDynamicLinkMessage(dynamiclink!)
            self.showDeepLinkAlertView(withMessage: message)
            // [END_EXCLUDE]
        }
        
        // [START_EXCLUDE silent]
        if !handled {
            // Show the deep link URL from userActivity.
            let message = "continueUserActivity webPageURL:\n\(userActivity.webpageURL?.absoluteString ?? "")"
            showDeepLinkAlertView(withMessage: message)
        }
        // [END_EXCLUDE]
        return handled
    }
    // [END continueuseractivity]
    func generateDynamicLinkMessage(_ dynamicLink: FIRDynamicLink) -> String {
        let matchConfidence: String
        if dynamicLink.matchConfidence == .weak {
            matchConfidence = "Weak"
        } else {
            matchConfidence = "Strong"
        }
        let message = "App URL: \(dynamicLink.url?.absoluteString ?? "")\nMatch Confidence: \(matchConfidence)\n"
        return message
    }
    
    @available(iOS 8.0, *)
    func showDeepLinkAlertView(withMessage message: String) {
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) -> Void in
            print("OK")
        }
        
        let alertController = UIAlertController.init(title: "Deep-link Data", message: message, preferredStyle: .alert)
        alertController.addAction(okAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}

