//
//  AppDelegate.swift
//  CloudmineVideoUploading
//
//  Created by Bohdan Shcherbyna on 7/11/17.
//  Copyright © 2017 Bohdan Shcherbyna. All rights reserved.
//

import UIKit
import CloudMine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let APP_IDENTIFIER = ""
    let APP_SECRET = ""


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let credentials:CMAPICredentials = CMAPICredentials.sharedInstance()

        credentials.appIdentifier = APP_IDENTIFIER
        credentials.appSecret = APP_SECRET
        
        assert(APP_IDENTIFIER != "" && APP_SECRET != "", "You must to assign APP_IDENTIFIER and APP_SECRET for using this sample app.")
        
        return true
    }

}

