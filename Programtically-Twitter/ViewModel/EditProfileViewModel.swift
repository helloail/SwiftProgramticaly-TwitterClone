//
//  EditProfileViewModel.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 20/10/20.
//

import Foundation


enum EditProfileOption: Int, CaseIterable {
    case fullname
    case username
    case bio
    
    var description : String {
        switch self {
        case .username:
            return "Username"
        case .fullname:
            return "Fullname"
        case .bio:
            return "Bio"
        }
    }
    
    class EditProfileViewModel {
        
        
        
        private let user: User
        
        private let option: EditProfileOption
        
        init(user: User, option: EditProfileOption) {
            
            self.user = user
            
            self.option = option
            
        }
        
        
        var shouldHideTextField: Bool {
            
            return option == .bio
            
        }
        
        
        var shouldHideTextView: Bool {
            
            return option != .bio
            
        }
        
        var optionLabel: String {
            
            return option.description
            
        }
        
        var infoText: String {
            
            if option == .fullname {
                
                return user.fullname
                
            }
            
            
            
            if option == .username {
                
                return user.username
                
            }
            
            
            
            return ""
            
        }
        
    }
    
}
