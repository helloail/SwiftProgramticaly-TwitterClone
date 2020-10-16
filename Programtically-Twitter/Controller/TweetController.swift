//
//  TweetController.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 15/10/20.
//

import UIKit

class TweetController: UICollectionViewController {
    //Mark: - Properties
    private let headeridentifire = "TweetHeader"
    private let reuseidentifire = "TweetCell"
    
    private let tweet : Tweet
    private let actionsheet : ActionSheetLauncher
    private var replies = [Tweet](){
        didSet{
            collectionView.reloadData()
        }
    }
    //Mark: - Lifecycle
    
    init(tweet : Tweet) {
        self.tweet = tweet
        self.actionsheet = ActionSheetLauncher(user: tweet.user)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchApi()
    }
    
    
    //Mark: - API
    func fetchApi() {
        TweetService.shared.fetchreplies(fortweet: tweet) { (tweet) in
            self.replies = tweet
        }
    }
    
    //Mark: - Helper
    
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseidentifire)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headeridentifire  )
    }
}


//Mark: - UICollectionViewDataSource
extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseidentifire, for: indexPath) as! TweetCell
        cell.tweets = replies[indexPath.row]
        return cell
    }
    
}


//Mark: - UiCollectionViewDelegate
extension TweetController{
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headeridentifire, for: indexPath) as! TweetHeader
        header.tweet = tweet
        header.delagate = self
        return header
    }
    
}


//Mark: - UICollectionViewDelegateFlowLayout

extension TweetController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewmodel = TweetViewModel(tweet: tweet)
        let height = viewmodel.size( forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: height + 290)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 100)
    }
     
}

extension TweetController : TweetHeaderDelegate {
    func showActionSheet() {
        actionsheet.show()
    }
    
    
}
