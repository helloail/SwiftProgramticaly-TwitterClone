//
//  TweetCell.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 04/10/20.
//

import Foundation
import UIKit


protocol TweetCellDelegate : class {
    func handlerprofileimagetapped(_ cell : TweetCell)
    func handlerreplytapped(_ cell : TweetCell)
    
}

class TweetCell: UICollectionViewCell {
    
    //MARK - Properties\
    var tweets : Tweet? {
        didSet{
            configure()
        }
    }
    
    weak var delegate : TweetCellDelegate?
    
    private lazy var profileimageview : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48/2
        iv.layer.masksToBounds = true
        iv.backgroundColor = .twitterBlue
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlerprofileimagerecognizer))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let captionlabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "test caption"
        return  label
    }()
//
    private let infolabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.text = "test @test "
        return label
    }()
    
    private lazy var commentbutton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 26, height: 26)
        button.addTarget(self, action: #selector(HandlerComment), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetbutton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "retweet"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 26, height: 26)
        button.addTarget(self, action: #selector(HandlerRetweet), for: .touchUpInside)
        return button
    }()
    
    private lazy var likebutton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 26, height: 26)
        button.addTarget(self, action: #selector(HandlerLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var sharedbutton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 26, height: 26)
        button.addTarget(self, action: #selector(HandlerShared), for: .touchUpInside)
        return button
    }()
    
    private let underlineview : UIView = {
        let ul = UIView()
        ul.backgroundColor = .systemGroupedBackground
        return ul
    }()
    
    //MARK - lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(profileimageview)
        profileimageview.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8 )
        
        let stack = UIStackView(arrangedSubviews: [infolabel,captionlabel])
        stack.axis = .vertical
        stack.distribution  = .fillProportionally
        stack.spacing = 4
        
        addSubview(stack)
        stack.anchor(top: profileimageview.topAnchor, left: profileimageview.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12)
        
        let actionstack = UIStackView(arrangedSubviews: [commentbutton,retweetbutton,likebutton,sharedbutton])
        actionstack.axis = .horizontal
        actionstack.spacing = 72
        addSubview(actionstack)
        actionstack.centerX(inView: self)
        actionstack.anchor( bottom: bottomAnchor, paddingBottom: 8)
        
        addSubview(underlineview)
        underlineview.anchor( left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK - selectors
    
    @objc func HandlerComment(){
        
    }
    
    
    @objc func HandlerRetweet(){
        delegate?.handlerreplytapped(self)
        
    }
    @objc func HandlerLike(){
        
    }
    @objc func HandlerShared(){
        
    }
    
    @objc func handlerprofileimagerecognizer(){
        
        delegate?.handlerprofileimagetapped(self)
        
    }
    
    
    //MARK - Helper
    private func configure(){
        guard let tweet = tweets else { return }
        let viewmodel = TweetViewModel(tweet: tweet)
        
        captionlabel.text = tweet.caption
    
        profileimageview.sd_setImage(with: viewmodel.profileimage)
        infolabel.attributedText = viewmodel.userinfotext
        
        
    }
}
