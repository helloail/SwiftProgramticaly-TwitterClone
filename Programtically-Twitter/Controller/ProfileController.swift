//
//  ProfileController.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 08/10/20.
//

import Foundation
import UIKit

class ProfileController: UICollectionViewController {
    
    
    //Mark: - Properties
    private let reuseidentifire = "TweetCell"
    
    private let headeridentifire = "ProfileHeader"
    
    private var user : User
    
    private var tweet = [Tweet]() {
        didSet{
            collectionView.reloadData()
        }
    }
    
    init(user : User){
        self.user = user
        
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchTweet()
        checkIfUserIsFOllow()
        fetchUserStat()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    func configureCollectionView() {
        
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseidentifire)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headeridentifire  )
        
    }
    
    //Mark: - API
    
    func fetchTweet(){
        TweetService.shared.fetchtweet(forUser : user) { tweets in
            
            print("LOGCAT TWEET : \(tweets) ")
            self.tweet = tweets
            
        }
    }
    
    func checkIfUserIsFOllow() {
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { (isfollowed) in
            self.user.isFollowed = isfollowed
        }
    }
    
    func fetchUserStat() {
        UserService.shared.fetchUserStat(uid: user.uid) { stat in
            self.user.stats = stat
            self.collectionView.reloadData()
        }
    }
}

//Mark: - UiCollectionViewDataSource

extension ProfileController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweet.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseidentifire, for: indexPath) as! TweetCell
        cell.tweets = tweet[indexPath.row]
        return cell
    }
}

//Mark: - UiCollectionViewDelegate
extension ProfileController{
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headeridentifire, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
    
}





//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 350)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 100)
    }
}





extension ProfileController : ProfileHeaderDelegate {
    func handleProfileFollower(_ header: ProfileHeader) {
        
        if user.isCurretUser {
            print("LOGCAT : Show edit profile controller")
            return
        } else {
            if user.isFollowed {
                UserService.shared.unfollowuser(uid: user.uid) { (err, ref) in
                    print("LOGCAT : UNFOLLOWing")
                    self.user.isFollowed = false
                    self.collectionView.reloadData()
                }
            } else{
                
                UserService.shared.followuser(uid: user.uid) { (err, ref) in
                    print("LOGCAT : FOLLOWing")
                    self.user.isFollowed = true
                    self.collectionView.reloadData()
                }
            }
        }
        
    }
    
    func profiledissmis() {
        navigationController?.popViewController(animated: true)
    }
    
    
}
