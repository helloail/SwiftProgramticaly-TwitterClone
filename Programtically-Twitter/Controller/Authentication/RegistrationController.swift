//
//  RegistrationController.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 26/09/20.
//

import Foundation
import UIKit
import Firebase

class RegistrationController : UIViewController {
    
    
    private let imagepicker = UIImagePickerController()
    private var profileimage : UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    private let plusphotobutton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo") , for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlerAddProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handlerAddProfilePhoto(){
        present(imagepicker, animated: true,completion: nil)
    }
    
    private lazy var emailconteiner : UIView = {
        let image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        let view = Utils().inputContinerView(withImage: image, textfield: emailtextfield)
        view.backgroundColor = .twitterBlue
        
        return view
    }()
    
    private lazy var passwordconteiner : UIView = {
        
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Utils().inputContinerView(withImage: image, textfield: passwordtextfield)
        view.backgroundColor = .twitterBlue
        
        return view
    }()
    
    private lazy var fullnameconteiner : UIView = {
        
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utils().inputContinerView(withImage: image, textfield: fullnametextfield)
        view.backgroundColor = .twitterBlue
        
        return view
    }()
    
    private lazy var usernameconteiner : UIView = {
        
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utils().inputContinerView(withImage: image, textfield: usernametextfield)
        view.backgroundColor = .twitterBlue
        
        return view
    }()
    
    
    private let emailtextfield : UITextField = {
        let tf = Utils().textField(withplaceholder: "Email")
        return tf
    }()
    
    private let passwordtextfield : UITextField = {
        
        let tf = Utils().textField(withplaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullnametextfield : UITextField = {
        let tf = Utils().textField(withplaceholder: "FullName")
        return tf
    }()
    
    private let usernametextfield : UITextField = {
        
        let tf = Utils().textField(withplaceholder: "UserName")
        return tf
    }()
    
    private let signupbutton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius =  5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handlerRegister), for: .touchUpInside)
        return button
        
    }()
    
    @objc func handlerRegister(){
        print("LOGCAT :  REGISTER")
        
        guard let profileimage = profileimage else {
            print("LOGCAT :  please select a profile image")
            return
        }
        
        guard let email = emailtextfield.text else {
            print("LOGCAT :  error email")
            return

        }

        guard let password = passwordtextfield.text else {
            print("LOGCAT :  password email")
            return

        }

        guard let fullname = fullnametextfield.text else { return }

        guard let username = usernametextfield.text?.lowercased() else { return }
        
        let credential = AuthCredential(email: email, password: password, username: username, fullname: fullname, profileimage: profileimage)
        
        AuthService.shared.RegisterService(credential: credential) { (error, ref) in
            print("LOGCAT : Register Succes")
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {
                return
            }
            
            guard let tab = window.rootViewController as? MainTabViewController else {return}
            
            tab.authUserAndConfigureUI()
            
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
   
    private let alreadyhavebutton : UIButton = {
        let button = Utils().atributtedButton("Don't have account!", " Sign Up")
        button.addTarget(self, action: #selector(handlerLogin), for: .touchUpInside)
        return  button
        
    }()
    
    
    @objc func handlerLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    private func configureUI(){
        
        view.backgroundColor = .twitterBlue
        
        imagepicker.delegate = self
        imagepicker.allowsEditing = true
        
        view.addSubview(plusphotobutton)
        plusphotobutton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0)
        plusphotobutton.setDimensions(width: 128, height: 128)
        
        let stack = UIStackView(arrangedSubviews: [emailconteiner, passwordconteiner, fullnameconteiner, usernameconteiner, signupbutton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top : plusphotobutton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        
        view.addSubview(alreadyhavebutton)
        alreadyhavebutton.anchor(left : view.leftAnchor, bottom : view.safeAreaLayoutGuide.bottomAnchor , right: view.rightAnchor ,paddingLeft: 32, paddingRight: 32)
    }
    
}

extension RegistrationController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileimage = info[.editedImage] as? UIImage else {
            return
        }
        
        self.profileimage = profileimage
        self.plusphotobutton.setImage(profileimage.withRenderingMode(.alwaysOriginal), for: .normal)
        plusphotobutton.layer.cornerRadius = plusphotobutton.frame.height/2
        plusphotobutton.layer.masksToBounds = true
        plusphotobutton.layer.borderWidth = 3
        plusphotobutton.layer.borderColor = UIColor.white.cgColor
        //        plusphotobutton.imageView?.contentMode = .scaleAspectFit
        plusphotobutton.imageView?.clipsToBounds = true
        
        dismiss(animated: true, completion: nil)
    }
}
