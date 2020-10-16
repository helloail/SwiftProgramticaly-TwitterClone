//
//  TweetHeader.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 15/10/20.
//

import UIKit

protocol TweetHeaderDelegate : class {
    func showActionSheet()
    
}

class TweetHeader: UICollectionReusableView {
    //Mark: -  Properties
    
    var tweet : Tweet? {
        didSet {
            configure()
        }
    }
    
    weak var delagate : TweetHeaderDelegate?
    
    private lazy var profileimageview : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48/2
        iv.layer.masksToBounds = true
        iv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlerProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    
    private let fullnamelabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "kadal"
        return label
    }()
    
    private let usernamelabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "@kadal"
        return label
    }()
    
    private let captionlabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.text = "kadal nya banyak"
        return label
    }()
    
    private let datelabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.text = "6:33 - 1/12/2020"
        return label
    }()
    
    private let optionbutton : UIButton = {
        let button = UIButton()
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetlabel = UILabel()
    
    private lazy var likelabel = UILabel()
    
    private lazy var statsView : UIView = {
        let views = UIView()
        
        let devider1 = UIView()
        devider1.backgroundColor = .systemGroupedBackground
        views.addSubview(devider1)
        devider1.anchor(top: views.topAnchor, left: views.leftAnchor, right: views.rightAnchor, paddingLeft: 8,  height: 1.0)
        
        let stack = UIStackView(arrangedSubviews: [retweetlabel,likelabel])
        stack.axis = .horizontal
        stack.spacing = 8

        views.addSubview(stack)
        stack.centerY(inView: views)
        stack.anchor(left : views.leftAnchor, paddingLeft: 16)

        let devider2 = UIView()
        devider2.backgroundColor = .systemGroupedBackground
        
        views.addSubview(devider2)
        devider2.anchor( left: views.leftAnchor, bottom: views.bottomAnchor, right: views.rightAnchor, paddingLeft: 8,  height: 1.0)
        
        return views
        
    }()
    
    
    private lazy var commentbutton : UIButton = {
        let button = createButton(withImageName: "comment")
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var likebutton : UIButton = {
        let button = createButton(withImageName: "like")
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var retweetbutton : UIButton = {
        let button = createButton(withImageName: "retweet")
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var sharebutton : UIButton = {
        let button = createButton(withImageName: "share")
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    //Mark: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let labelstack = UIStackView(arrangedSubviews : [fullnamelabel, usernamelabel])
        labelstack.axis = .vertical
        labelstack.spacing = -8
        
        
        let stack = UIStackView(arrangedSubviews : [profileimageview, labelstack])
        stack.axis = .horizontal
        stack.spacing = 12
        
        addSubview(stack)
        stack.anchor(top : topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        
        addSubview(captionlabel)
        captionlabel.anchor(top : stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12  , paddingLeft: 16, paddingRight: 16)
        
        addSubview(datelabel)
        datelabel.anchor(top : captionlabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20  , paddingLeft: 16, paddingRight: 16)
        
        addSubview(optionbutton)
        optionbutton.centerY(inView: stack)
        optionbutton.anchor(right: rightAnchor, paddingRight: 8)
        
        addSubview(statsView)
        statsView.anchor(top : datelabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, height: 40)
        
        let actionstack = UIStackView(arrangedSubviews: [commentbutton,retweetbutton,likebutton,sharebutton])
        actionstack.axis = .horizontal
        actionstack.spacing = 72
        
        addSubview(actionstack)
        actionstack.centerX(inView: self)
        actionstack.anchor(  top: statsView.bottomAnchor,paddingTop:  12)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //Mark : - Selector
    @objc func handlerProfileImageTapped() {
        
    }
    
    @objc func showActionSheet() {
        delagate?.showActionSheet()
    }
    
    
    @objc func handleCommentTapped() {
        
    }
    
    
    @objc func handleLikeTapped() {
        
    }
    
    @objc func handleRetweetTapped() {
        
    }
    
    @objc func handleShareTapped() {
        
    }
    
    
    //Mark : - Helper
    
    func configure(){
        guard let tweet = tweet else {
            return
        }
        
        let viewmodel = TweetViewModel(tweet: tweet)
        
        captionlabel.text = viewmodel.tweet.caption
        fullnamelabel.text = viewmodel.user.fullname
        usernamelabel.text = viewmodel.user.username
        profileimageview.sd_setImage(with: viewmodel.profileimage)
        datelabel.text = viewmodel.headerTtimestamp
        retweetlabel.attributedText = viewmodel.retweetAtributtedString
        likelabel.attributedText =  viewmodel.liketributtedString
    }
    
    
    func createButton(withImageName imageName: String ) -> UIButton {
        let button = UIButton()
        
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 24, height: 24)
        return button
    }
}
