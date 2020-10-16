//
//  MainTabViewController.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 24/09/20.
//

import UIKit
import Firebase

class MainTabViewController: UITabBarController {
    
    var user : User? {
        didSet{
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feedcontroller = nav.viewControllers.first as? FeedCOntroller else { return }
            
            feedcontroller.user = user
        }
    }
    
    
    let actionbutton : UIButton =  {
        
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionbuttontapped), for: .touchUpInside)
        return button
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//
//        logUserOut()
        authUserAndConfigureUI()
    }
    
    
    private func configureUI() {
        view.addSubview(actionbutton)
        actionbutton.anchor( bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionbutton.layer.cornerRadius = 56/2
        
    }
    
    private func configureController()  {
        let feed = FeedCOntroller(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected"), rootviewcontroller: feed)
        
        let explorer = ExplorerController()
        let nav2 = templateNavigationController(image: UIImage(named: "search_unselected"), rootviewcontroller: explorer)
        
        let notification = NotificationController()
        let nav3 = templateNavigationController(image: UIImage(named: "search_unselected"), rootviewcontroller: notification)
      
        let convertation = ConvertationController()
        let nav4 = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootviewcontroller: convertation)
      
        viewControllers = [nav1,nav2,nav3,nav4]
    }
    
    @objc func actionbuttontapped() {
        
        guard let user = user else {
            return
        }
        let controller = UploadTweetController(user: user, config: .tweet)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil )
    }
    
    func authUserAndConfigureUI(){
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            
        }else{
            configureController()
            configureUI()
            fetchuser()
            print("LOGCAT : status login")
        }
    }
    
    
    func logUserOut()  {
        do{
            try Auth.auth().signOut()
            print("LOGCAT : logout succes")
        }catch let error {
            print("LOGCAT : logout error \(error.localizedDescription)")
        }
    }
    
    func templateNavigationController(image : UIImage?, rootviewcontroller : UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootviewcontroller)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
        
    }

    
    func fetchuser() {
        guard  let uid =  Auth.auth().currentUser?.uid else {
            return
        }
        
        UserService.shared.fetchuser(uid: uid) { user in
            self.user = user
        }
    }
 

}
