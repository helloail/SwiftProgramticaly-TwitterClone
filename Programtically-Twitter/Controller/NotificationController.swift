//
//  NotificationController.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 24/09/20.
//

import Foundation
import UIKit

class NotificationController: UITableViewController {
    
    private var notifications = [Notification]() {
        didSet{
            tableView.reloadData()
        }
    }
    private let reuseidentifire = "NotificationCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    private func configureUI(){
        
        view.backgroundColor = .white
        navigationItem.title = "Notification"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseidentifire)
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        
        let refreshcontrol = UIRefreshControl()
        tableView.refreshControl = refreshcontrol
        refreshcontrol.addTarget(self, action: #selector(handlerefresh), for: .valueChanged)
        
    }
    
    private func fetchNotification(){
        refreshControl?.beginRefreshing()
        NotificationService.shared.fetchNotification { (notification) in
            self.refreshControl?.endRefreshing()
            self.notifications = notification
            self.checkIfUserFOllowed(notification: self.notifications)
            
        }
    }
    
     func checkIfUserFOllowed(notification : [Notification]){
        for (index, notification) in notification.enumerated() {
            
            if case .follow = notification.type {
                let user = notification.user
                UserService.shared.checkIfUserIsFollowed(uid: user.uid) { (isFollowed) in
                    self.notifications[index].user.isFollowed = isFollowed
                }
                
            }
        }
    }
    
    
    @objc func handlerefresh() {
        fetchNotification()
    }
}




extension NotificationController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        
        guard let tweetid = notification.tweetID else { return }
        
        TweetService.shared.fetchtweet(withTweetID: tweetid) { tweet in
            let controller = TweetController(tweet: tweet)
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
}
extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseidentifire, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
}


extension NotificationController : NotificationCellDelegate {
    func didTapProfileImage(_ cell: NotificationCell) {
        
        
        print("LOGCat : didTapFollow")
        guard let user = cell.notification?.user else {
            return
        }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapFollow(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else {
            return
        }
        
        if user.isFollowed {
            UserService.shared.unfollowuser(uid: user.uid) { (err, ref) in
                cell.notification?.user.isFollowed = false
            }
        } else {
            UserService.shared.followuser(uid: user.uid) { (err, ref) in
                cell.notification?.user.isFollowed = true
            }
        }
        
    }
}
