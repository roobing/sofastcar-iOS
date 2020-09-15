//
//  AppDelegate.swift
//  sofastcar
//
//  Created by 김광수 on 2020/08/21.
//  Copyright © 2020 김광수. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    var rootView: UIViewController = UIViewController()
//    UserDefaults.resetUserAuthTocken() // 로그아웃필요할때 사용
    if UserDefaults.getUserAuthTocken() != nil {
        let mainVC = MainVC()
        mainVC.socarZoneProvider = SocarZoneProvider()
        rootView = mainVC
        
    } else {
        let navigationController = UINavigationController(rootViewController: InitVC())
        let backButtonImage = UIImage(systemName: "arrow.left")
        navigationController.navigationBar.backIndicatorImage = backButtonImage
        navigationController.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        navigationController.navigationBar.topItem?.title = ""
        rootView = navigationController
    }
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = rootView
    window?.makeKeyAndVisible()
    window?.overrideUserInterfaceStyle = .light // add woobin: dark mode off
    return true
  }
  
}
