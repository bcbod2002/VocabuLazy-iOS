//
//  AnalyticsModel.swift
//  Swallow
//
//  Created by 蘇健豪1 on 2016/10/4.
//  Copyright © 2016年 WishCan. All rights reserved.
//

import UIKit

import Flurry_iOS_SDK
//import Mixpanel
import Fabric
import Crashlytics


class AnalyticsModel: NSObject {
    func initAnalytics() {
        initFlurry()
        initGoogleAnalytics()
        initMixpanel()
        initCrashlytics()
    }
    
    fileprivate func initFlurry() {
        Flurry.startSession("VTQG4JHWBXSCX99DKGBH")
    }
    
    fileprivate func initGoogleAnalytics() {
//        // Configure tracker from GoogleService-Info.plist.
//        var configureError:NSError?
//        GGLContext.sharedInstance().configureWithError(&configureError)
//        assert(configureError == nil, "Error configuring Google services: \(configureError)")
//        
//        // Optional: configure GAI options.
//        let gai = GAI.sharedInstance()
//        gai?.trackUncaughtExceptions = true  // report uncaught exceptions
//        gai?.logger.logLevel = GAILogLevel.verbose  // remove before app release
    }
    
    
    /// 初始化 Mixpanel
    ///
    /// - returns: void
    fileprivate func initMixpanel() {
//        printLog("initMixpanel")
//        Mixpanel.initialize(token: "c4f967edcc4f7545c311bc46bee0e0cf")
//        Mixpanel.mainInstance().track(event: "Test",
//                                      properties: ["Key" : "Value"])
    }
    
    fileprivate func initCrashlytics() {
        Fabric.sharedSDK().debug = true
        Fabric.with([Crashlytics.self])
    }
}
