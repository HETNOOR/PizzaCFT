//
//  MainTabBarController.swift
//  PizzaCFT
//
//  Created by Максим Герасимов on 06.07.2024.
//

import UIKit


class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tabBar.tintColor = .systemOrange
        
        navigationItem.hidesBackButton = true
       
        
        
        let pizzaVC = PizzaListViewController()
        let ordersVC = OrdersViewController()
        let cartVC = BasketViewController()
        let profileVC = UserViewController()
        

        pizzaVC.tabBarItem = UITabBarItem(title: "Пицца", image: UIImage(named: "pizza"), tag: 0)
        ordersVC.tabBarItem = UITabBarItem(title: "Заказы", image: UIImage(named: "order"), tag: 1)
        cartVC.tabBarItem = UITabBarItem(title: "Корзина", image: UIImage(named: "trash"), tag: 2)
        profileVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(named: "user"), tag: 3)
        
        title = pizzaVC.tabBarItem.title
        viewControllers = [pizzaVC, ordersVC, cartVC, profileVC]
        
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        title = viewController.tabBarItem.title
    }
}
