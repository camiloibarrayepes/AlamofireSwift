//
//  UsersViewController.swift
//  AlamofireSwiftyJSON
//
//  Created by camilo andres ibarra yepes on 4/20/19.
//  Copyright © 2019 camilo andres ibarra yepes. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UsersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var usersData: [UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 50
        self.tableView.register(UINib(nibName: "UsersTableViewCell", bundle: nil), forCellReuseIdentifier: "userCell")
        
        fetchUsersData()
    }
    
    func fetchUsersData(){
        DispatchQueue.main.async {
            Alamofire.request("https://api.myjson.com/bins/10b384").responseJSON(completionHandler: {(response) in switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let data = json["data"]
                    data["users"].array?.forEach({(user) in
                        let user = UserModel(name: user["name"].stringValue, email: user["email"].stringValue)
                        self.usersData.append(user)
                    })
                    self.tableView.reloadData()
                
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }

}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UsersTableViewCell
        cell.nameLabel.text = self.usersData[indexPath.row].name
        cell.emailLabel.text = self.usersData[indexPath.row].email
        return cell
    }
    
    
}
