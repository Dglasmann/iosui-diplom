//
//  SceneDelegate.swift
//  MyHabits
//
//  Created by Sasha Soldatov on 23.03.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let tabBarController = UITabBarController()
        
        let habitsVC = HabitsViewController()
        let habitsNavController = UINavigationController(rootViewController: habitsVC)
        habitsNavController.navigationBar.prefersLargeTitles = true
        habitsNavController.tabBarItem = UITabBarItem(
            title: "Привычки",
            image: UIImage(systemName: "rectangle.grid.1x2.fill"),
            tag: 0
        )
        
        let infoVC = InfoViewController()
        let infoNavController = UINavigationController(rootViewController: infoVC)
        infoNavController.tabBarItem = UITabBarItem(
            title: "Информация",
            image: UIImage(systemName: "info.circle.fill"),
            tag: 1
        )
        
        tabBarController.viewControllers = [habitsNavController, infoNavController]
        
        tabBarController.tabBar.tintColor = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
        
    }

    

}

