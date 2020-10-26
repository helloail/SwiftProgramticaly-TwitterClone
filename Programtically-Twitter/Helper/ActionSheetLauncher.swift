//
//  ActionSheetLauncher.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 16/10/20.
//

import Foundation
import UIKit

class ActionSheetLauncher : NSObject {
    
    //Mark :- Properties
    
    private let reusedidentifire = "ActionSheetCell"
    
    private let user : User
    private let tableview = UITableView()
    private var window : UIWindow?
    
    init(user : User) {
        self.user = user
        super.init()
        
        configureTableView()
    }
    
    func show()   {
        print("LOGcat : launch \(user.username)")
        
        guard  let window = UIApplication.shared.windows.firstIndex(where: {$0.isKeyWindow}) else { return }
//
//        self.window = window
//
//        self.window?.addSubview(tableview)
//        tableview.frame = CGRect(x: 0, y: window.frame.height - 300, width: window.frame.width, height: 300)
    }
    
    func configureTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = .blue
        
        tableview.rowHeight = 60
        tableview.separatorStyle = .none
        tableview.layer.cornerRadius = 5
        tableview.isScrollEnabled = false
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: reusedidentifire)
    }
    
    
}


extension ActionSheetLauncher : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableview.dequeueReusableCell(withIdentifier: reusedidentifire, for: indexPath)
        
        return cell
    }
}

extension ActionSheetLauncher : UITableViewDelegate {
     
}
