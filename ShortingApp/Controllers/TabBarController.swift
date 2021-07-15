import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let firstTab = ShortingController()
        
        firstTab.tabBarItem = UITabBarItem(title: "Shorten now", image: UIImage(systemName: "lasso.sparkles"), tag: 0)
        
        let secondTab = HistoryController()
        
        secondTab.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "list.star"), tag: 1)
        
        let tabBarList = [firstTab, secondTab]
        
        viewControllers = tabBarList
    }
}
