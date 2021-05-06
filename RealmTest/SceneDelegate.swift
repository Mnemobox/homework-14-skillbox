
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
  

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let ws = scene as? UIWindowScene {
            let myWindow = UIWindow(windowScene: ws)
            let navContr = UINavigationController()
           let vc = TaskListViewController()
            let vc2 = TaskViewController()
            let vc3 = WeatherViewController()
            let vc4 = CoreDataViewController()
            
            let tabbar = UITabBarController()
            
            tabbar.viewControllers = [navContr, vc, vc2, vc3, vc4]
            
            let item1 = UITabBarItem()
            item1.title = "To Do List"
            item1.image = .checkmark
            vc.tabBarItem = item1
            
            let item2 = UITabBarItem()
            item2.title = "Textfields"
            item2.image = .checkmark
            vc2.tabBarItem = item2
            
            let item3 = UITabBarItem()
        item3.title = "Weather"
            item3.image = .checkmark
            vc3.tabBarItem = item3
            
            let item4 = UITabBarItem()
        item4.title = "To Do List"
            item4.image = .checkmark
            vc4.tabBarItem = item4
            
            navContr.viewControllers = [vc4, vc]
            myWindow.rootViewController = tabbar
            
//            let coreToDoListNavigation = UINavigationController()
//            coreToDoListNavigation.viewControllers = [vc4]
            
            self.window = myWindow
            myWindow.makeKeyAndVisible()
            vc.readTsksAndUpdate()
       
       
        }
        
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }


    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


