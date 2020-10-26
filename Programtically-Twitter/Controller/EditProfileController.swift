//
//  EditPrifileController.swift
//  Programtically-Twitter
//
//  Created by Moh Zinnur Atthufail Addausi on 20/10/20.
//

import UIKit

class EditProfileController: UITableViewController{
    //Mark:-  Prperties
    
    private let reuseidentifire = "EditProfileCell"
    private let imagepicker = UIImagePickerController()
    private let user : User

    
    private lazy var headerview = EditProfileHeader(user: user)
    
    private var selectedimage : UIImage? {
        didSet {
            headerview.profileImageView.image = selectedimage
        }
    }
    init(user : User ) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Mark:-  Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        configureImagePicker()
    }
    
    
    
    //Mark:-  Selector
    
    @objc func handlecancle(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handledone(){
        dismiss(animated: true, completion: nil)
    }
    
    //Mark:-  API
    
    //Mark:-  Helper
    
    func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = .twitterBlue
        
        navigationController?.navigationBar.tintColor = .white
        
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = "Edit Profile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handlecancle))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handledone))
        
    }
    
    func configureTableView()  {
        tableView.tableHeaderView = headerview
        headerview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        headerview.delegate = self
        tableView.separatorStyle = .none
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseidentifire)
    }
    
    func configureImagePicker()  {
        
        imagepicker.delegate = self
        imagepicker.allowsEditing = true
    }
}

extension EditProfileController : EditProfileHeaderDelegate {
    func didtapChangProfilePhoto() {
    
        present(imagepicker, animated: true, completion: nil)
    }
    
    
}
extension EditProfileController  {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOption.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseidentifire, for: indexPath) as! EditProfileCell
        
        return cell
    }
}

extension EditProfileController  {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard  let option = EditProfileOption(rawValue: indexPath.row) else {
            return 0
        }
        return option == .bio ? 100 : 48
    }
    
}
extension EditProfileController : UIImagePickerControllerDelegate, UINavigationControllerDelegate   {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        self.selectedimage = image
        dismiss(animated: true, completion: nil)
    }
}
