//
//  AuthService.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 29/09/20.
//

import Foundation
import Firebase

struct AuthCredential{
    let email : String
    let password : String
    let username : String
    let fullname : String
    let profileimage : UIImage
    
}


struct AuthService {
    
    static let shared = AuthService()
    
    func LoginUser(withEmail email : String, password : String, complition :  AuthDataResultCallback?)  {
        Auth.auth().signIn(withEmail: email, password: password,completion: complition) 
        
    }
    
    
    
    
    func RegisterService(credential : AuthCredential, complition : @escaping (Error?, DatabaseReference) -> Void){
        guard let imagedata = credential.profileimage.jpegData(compressionQuality:  0.3) else {
            print("LOGCAT :  error imagedata")
            return
            
        }
        
        let filename = NSUUID().uuidString
        
        let storageref = STORAGE_PROFILE_IMAGE.child(filename)
        
        storageref.putData(imagedata, metadata: nil) { (meta, error) in
            if let error = error {
                print("LOGCAT : error \(error.localizedDescription)")
                return
            }
            
            storageref.downloadURL { (url, error) in
                guard let profileimageurl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: credential.email, password: credential.password) { (result, error) in
                    if let error = error {
                        print("LOGCAT : error \(error.localizedDescription)")
                        return
                    }
                    
                    guard let uid = result?.user.uid else {
                        print("LOGCAT : error uid")
                        return
                    }
                    
                    let values = ["email" : credential.email, "fullname" : credential.fullname, "username" : credential.username, "profileimageurl" : profileimageurl ]
                    
                    
                    REF_USER.child(uid).updateChildValues(values, withCompletionBlock: complition) 
                    
                }
            }
        }
    }
}
