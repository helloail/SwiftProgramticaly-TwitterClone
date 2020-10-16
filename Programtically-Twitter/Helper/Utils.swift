//
//  Utils.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 26/09/20.
//

import Foundation
import UIKit

class Utils {
    func inputContinerView(withImage image: UIImage, textfield : UITextField) -> UIView {
       let view = UIView()
        let iv = UIImageView()
        let deviderview = UIView()
        
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        iv.image = image
        view.addSubview(iv)
        
        iv.anchor(left : view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        iv.setDimensions(width: 24, height: 24)
        
        view.addSubview(textfield)
        textfield.anchor(left : iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        
        view.addSubview(deviderview)
        deviderview.backgroundColor = .white
        deviderview.anchor(left : view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        
        
        return view
    }
    
    func textField(withplaceholder placeholder : String) ->  UITextField  {
        let tf = UITextField()
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor :  UIColor.white])
        return tf
    }
    
    func atributtedButton(_ firstpart : String, _ secondpart : String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributed = NSMutableAttributedString(string: firstpart, attributes:[ NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.white ])
        
        attributed.append(NSMutableAttributedString(string: secondpart, attributes:[ NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.white ]))
        
        button.setAttributedTitle(attributed, for: .normal)
        
        return button
        
    }
    
}
