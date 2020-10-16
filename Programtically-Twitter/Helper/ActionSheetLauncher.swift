//
//  ActionSheetLauncher.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 16/10/20.
//

import Foundation

class ActionSheetLauncher : NSObject {
    
    //Mark :- Properties
    
    private let user : User
    
    init(user : User) {
        self.user = user
        super.init()
    }
    
    func show()   {
        print("LOGcat : launch \(user.username)")
    }
}

