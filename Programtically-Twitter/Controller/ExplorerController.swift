//
//  ExplorerController.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 24/09/20.
//

import Foundation
import UIKit



class ExplorerController: UITableViewController {
    
    //Mark: - Properties
    let reuseidentifier = "UserCell"
    
    private var users = [User]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    private var filtereduser = [User]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    private var inSearchMode : Bool {
        return seachcontroller.isActive && !seachcontroller.searchBar.text!.isEmpty
    }
    
    private let seachcontroller = UISearchController(searchResultsController: nil)
    
    //Mark: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        ConfigureSearchController()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    
    //Mark : - API
    
    func fetchUser() {
        UserService.shared.fetchuser { users in
            self.users = users
        }
    }
    
    //Mark : - Helper
    
    private func configureUI(){
        
        view.backgroundColor = .white
        navigationItem.title = "Explore"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseidentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
    }
    
    
    private func ConfigureSearchController(){
        seachcontroller.searchResultsUpdater = self
        seachcontroller.obscuresBackgroundDuringPresentation = false
        seachcontroller.hidesNavigationBarDuringPresentation = false
        seachcontroller.searchBar.placeholder = "Search For User"
        navigationItem.searchController = seachcontroller
        definesPresentationContext = false
    }
    
    
}



//Mark: - UITableViewDelegate / DataSource
extension ExplorerController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filtereduser.count : users.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseidentifier, for: indexPath) as! UserCell
        let user = inSearchMode ? filtereduser[indexPath.row] : users[indexPath.row]
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let user = inSearchMode ? filtereduser[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}


extension ExplorerController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchtext = seachcontroller.searchBar.text?.lowercased() else {
            return
        }
        filtereduser = users.filter({$0.username.contains(searchtext) || $0.fullname.contains(searchtext)})
        
    }
    
    
}
