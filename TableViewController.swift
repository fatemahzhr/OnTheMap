//  TableViewController.swift
//  OnTheMap Project
//
//  Created by Fatimah Abdulraheem on 28/01/2019.
//

import UIKit
import Foundation

//This class "TableViewController" will inherit from UsedButtonsVC to create the required (Logout, Add, and Refresh) buttons.
class TableViewController: UsedButtonsVC {
    @IBOutlet weak var tableView: UITableView!
    
    //override the locations data into a new variable "LD"
    override var LD: LData? {
        didSet {
            guard let LD = LD else { return }
            l = LD.UdacityUsersL
        }
    }
    //define locations variable array
    var l: [SLocation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set tableview dataSource and delegate
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
}//end of class TableViewController

extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return l.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: "StudentCell") as! TableViewCell
        if l.count == 0 {
            return c
        }
        //show the name of users and thier submitted URLs
        let detail = self.l[(indexPath as NSIndexPath).row]
        c.userTextCell.text = ("\(detail.firstName ?? "?") \(detail.lastName ?? "?")")
        c.urlText.text = ("\(detail.mediaURL ?? "?")")
        return c
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //When selecting the cell, if the URL is correct then the clicked link will be opened for the user
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = self.l[(indexPath as NSIndexPath).row]
        if let urlString = URL(string: ("\(detail.mediaURL ?? "?")")),
            //open the URL
        UIApplication.shared.canOpenURL(urlString) {
            UIApplication.shared.open(urlString, options: [:], completionHandler: nil)
        }
    }//end of didSelectRowAt
}//end of extension TableViewController
