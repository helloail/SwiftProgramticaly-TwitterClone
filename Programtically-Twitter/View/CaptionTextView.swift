//
//  CaptionTextView.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 03/10/20.
//

import Foundation
import UIKit

class CaptionTextView: UITextView {
    
    
    //Mark - Properties
    let placeholderlabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "what's happening"
        return label
    }()
    
    
    //Mark - lifecycle
    override init(frame : CGRect, textContainer : NSTextContainer?){
        super.init(frame: frame,textContainer: textContainer)
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 200).isActive = true
        addSubview(placeholderlabel)
        placeholderlabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChanged), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //Mark - Selector
    @objc func handleTextInputChanged(){
        if text.isEmpty {
            placeholderlabel.isHidden = false
        }else{
            placeholderlabel.isHidden = true
        }
    }
}

