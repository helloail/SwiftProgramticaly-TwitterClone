//
//  UploadTweetController.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 03/10/20.
//

import Foundation
import UIKit
import ActiveLabel

class UploadTweetController: UIViewController {
    
    
    //Mark - Properties
    
    private let user : User
    private let config : UploadTwetConfiguration
    private lazy var viewmodel =  UploadTweetViewModel(config : config)
    
    
    private lazy var rightbarbutton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32/2
        button.addTarget(self, action: #selector(hadleUploadTweet), for: .touchUpInside)
        return button
        
    }()
    
    private let profileimageview : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48/2
        iv.layer.masksToBounds = true
        iv.backgroundColor = .twitterBlue
        return iv
    }()
    
    private lazy var replylabel : ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.tintColor = .lightGray
        label.mentionColor = .twitterBlue
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
    private let captiontextview = CaptionTextView()
    
    
    init(user : User, config: UploadTwetConfiguration) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //Mark - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        switch config {
        case .reply(let tweet):
            print("LOGCAT config reply \(tweet.caption)")
        case .tweet:
            print("LOGCAT config tweet")
            
        }
    }
    
    //Mark - Selector
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func hadleUploadTweet(){
        
        guard let caption = captiontextview.text else {
            return
        }
        
        TweetService.shared.uploadtweet(caption: caption, type: config) { (error, result) in
            
            if let error  =  error{
                print("LOGCAT : TWEEET error \(error.localizedDescription)")
                return
            }
            if case .reply(let tweet) = self.config{
                NotificationService.shared.uploadNotification(type: .reply, tweet: tweet)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    //Mark - API
    
    
    //mark - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        configureMentionHandler()
        
        guard let imageurl = URL(string: user.profileImageUrl) else {
            return
        }
        
        let imagecaptionstack = UIStackView(arrangedSubviews: [profileimageview,captiontextview])
        imagecaptionstack.axis = .horizontal
        imagecaptionstack.spacing = 12
        
        let stack =  UIStackView(arrangedSubviews: [replylabel,imagecaptionstack])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        profileimageview.sd_setImage(with: imageurl, completed: nil)
        
        rightbarbutton.setTitle(viewmodel.actionButtontittle, for: .normal)
        captiontextview.placeholderlabel.text = viewmodel.placeholdertext
        replylabel.isHidden = !viewmodel.shouldShowReplyLabel
        guard let replytext = viewmodel.replytext else {
            return
        }
        replylabel.text = replytext

    }
    
    private func configureNavigationBar()  {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightbarbutton)
    }
    
    func configureMentionHandler()  {
        replylabel.handleMentionTap { userhandler in
            
        }
    }
}
