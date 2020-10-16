//
//  NotificationController.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 24/09/20.
//

import Foundation
import UIKit

class NotificationController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI(){
        
        view.backgroundColor = .white
        navigationItem.title = "Notification"
        
    }
}
