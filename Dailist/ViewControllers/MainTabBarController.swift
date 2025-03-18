//
//  MainTabBarController.swift
//  Dailist
//
//  Created by 안지희 on 3/17/25.
//

// 하단바

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let communityVC = UINavigationController(rootViewController: CommunityViewController())
        let notificationVC = UINavigationController(rootViewController: NotificationViewController())
        let myPageVC = UINavigationController(rootViewController: MyPageViewController())

        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        communityVC.tabBarItem = UITabBarItem(title: "커뮤니티", image: UIImage(systemName: "bubble.left.and.bubble.right"), tag: 1)
        notificationVC.tabBarItem = UITabBarItem(title: "알림", image: UIImage(systemName: "bell"), tag: 2)
        myPageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person"), tag: 3)

        viewControllers = [homeVC, communityVC, notificationVC, myPageVC]
    }
}

#if DEBUG
import SwiftUI

struct MainTabBarControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainTabBarController {
        return MainTabBarController()
    }
    
    func updateUIViewController(_ uiViewController: MainTabBarController, context: Context) {}
}

struct MainTabBarController_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarControllerPreview()
    }
}
#endif
