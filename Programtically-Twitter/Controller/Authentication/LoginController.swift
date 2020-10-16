//
//  LoginController.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 26/09/20.
//

import Foundation
import UIKit

class LoginController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    private let logoimageview : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "TwitterLogo")
        return iv
    }()
    
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
    
    
    private let emailtextfield : UITextField = {
        let tf = Utils().textField(withplaceholder: "Email")
        return tf
    }()
    
    private let passwordtextfield : UITextField = {
       
        let tf = Utils().textField(withplaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginbutton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius =  5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handlerLogin), for: .touchUpInside)
        return button
        
    }()
    
    
    @objc func handlerLogin(){
        guard let email = emailtextfield.text else {
            print("LOGCAT :  error email")
            return

        }

        guard let password = passwordtextfield.text else {
            print("LOGCAT :  password email")
            return

        }
        AuthService.shared.LoginUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("LOGCAT :  login error\(error.localizedDescription)")
            }
            
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {
                return
            }
            
            guard let tab = window.rootViewController as? MainTabViewController else {return}
            
            tab.authUserAndConfigureUI()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    private let donthavebutton : UIButton = {
        let button = Utils().atributtedButton("Don't have account!", " Sign Up")
        button.addTarget(self, action: #selector(handlerSignup), for: .touchUpInside)
        return  button
        
    }()
    
    
    @objc func handlerSignup(){
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true )
    }
    
    
    private func configureUI(){
        
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoimageview)
        logoimageview.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0)
        logoimageview.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailconteiner,passwordconteiner, loginbutton])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top : logoimageview.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(donthavebutton)
        donthavebutton.anchor(left : view.leftAnchor, bottom : view.safeAreaLayoutGuide.bottomAnchor , right: view.rightAnchor ,paddingLeft: 32, paddingRight: 32)
    }
    
}
