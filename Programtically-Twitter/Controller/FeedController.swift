//
//  FeedController.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 24/09/20.
//

import Foundation
import UIKit
import SDWebImage

class FeedCOntroller: UICollectionViewController {
    
    
    //MARK: - Properties
    var user : User? {
        didSet{
            configureleftbarbutton()
        }
    }
    private var tweets = [Tweet]() {
        didSet{
            collectionView.reloadData()
        }
    }
    
    
    
    //MARK: - Liofecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        
        navigationController?.navigationBar.isHidden = false
    }
    
    
    func fetchTweet()  {
        TweetService.shared.fetchtweet { [self] tweet in
            self.tweets = tweet
        }
    }
    
    
    //MARK: - Helper
    private func configureUI(){
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: "TweetCell")
        
        collectionView.backgroundColor = .white
        
        let imageview = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageview.contentMode = .scaleAspectFit
        imageview.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageview
        
    }
    
    func configureleftbarbutton() {
        guard let user = user else {
            return
        }
        
        let profileimage = UIImageView()
        profileimage.setDimensions(width: 32, height: 32)
        profileimage.layer.cornerRadius = 32/2
        profileimage.layer.masksToBounds  = true
        
        
        guard let imageurl = URL(string: user.profileImageUrl) else {
            return
        }
        profileimage.sd_setImage(with: imageurl , completed: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileimage)
    }
}

//MARK: - UICollectionViewDelegate/DataSource

extension FeedCOntroller {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweets = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: tweets[indexPath.row])
        
        navigationController?.pushViewController(controller, animated: true)
        
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FeedCOntroller : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tweet = tweets[indexPath.row]
        let viewmodel = TweetViewModel(tweet: tweet)
        let height = viewmodel.size( forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: height+80)
    }
}

//MARK: - TweetCellDelegate

extension FeedCOntroller : TweetCellDelegate {
    func handlerreplytapped(_ cell: TweetCell) {
        guard  let tweet = cell.tweets else {
            return
        }
        
        let controller = UploadTweetController(user: tweet.user, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func handlerprofileimagetapped(_ cell: TweetCell) {
        guard  let user = cell.tweets?.user else {
            return
        }
        
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
