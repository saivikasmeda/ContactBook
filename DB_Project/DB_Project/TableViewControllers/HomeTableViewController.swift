//
//  HomeTableViewController.swift
//  DB_Project
//
//  Created by Student on 3/18/20.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit
// Adding a new feature to URL Class Objects.  appending query parameters to URL string.
extension URL {
    /// Returns a new URL by adding the query items, or nil if the URL doesn't support it.
    /// URL must conform to RFC 3986.
    func appending(_ queryItems: [URLQueryItem]) -> URL? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil
        }
        // append the query items to the existing ones
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        // return the url from new url components
        return urlComponents.url
    }
}



// This is the class from Home page tableview controller.
class HomeTableViewController: UITableViewController,UISearchBarDelegate {

    // global varibles of HometableviewController class.
    var index = 0
    let appD = UIApplication.shared.delegate as? AppDelegate
    let server = "http://localhost:3000"
    var Contact_Details:NSMutableArray?
    var contactDetails:NSDictionary?
    var name:String?
    
    
    // Oulets objects in home screen.
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    
    // This is searchbar delegate method. This method gets triggered when ever user types anything in the search bar.
    //Based on user search we fetch data from the server using URLSession Object. we add search text as queryparamters to the url string.
    // response is stored in Contact_Details object.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let url = URL(string: server)!
        let queryItems = [URLQueryItem(name: "search", value: searchBar.text)]
        let newUrl = url.appending(queryItems)
        var request = URLRequest(url: newUrl ?? url)
                request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) {
                     (data, response, error) in
                     if let error = error {
                         print(error)
                         return
                     }
                     DispatchQueue.main.async {
                         guard let resdata = data else {return}
                        print(resdata)
                        do{
                            let detailsArray = try JSONSerialization.jsonObject(with: resdata, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray
                            self.Contact_Details = detailsArray?.mutableCopy() as? NSMutableArray
                        }catch{
                            print("error")
                        }

                        self.tableView.reloadData()
                    }
                 }
                 task.resume()
    }

    // this method is triggered when the home table view's view is loaded for the first time into the memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarOutlet.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // this method triggers when ever the view appears on the screen. In this method we fetch all the contact details from the MYSQL database.
    override func viewDidAppear(_ animated: Bool) {
        let url = URL(string: server)!
               let queryItems = [URLQueryItem(name: "search", value: "")]
               let newUrl = url.appending(queryItems)
               var request = URLRequest(url: newUrl ?? url)
                       request.httpMethod = "GET"
                        // background task to make request with URLSession
                        let task = URLSession.shared.dataTask(with: request) {
                            (data, response, error) in
                            if let error = error {
                                print(error)
                                return
                            }
                            
                          
                            // update the UI if all went OK
                            DispatchQueue.main.async {
                                do{
                                    guard let resdata = data else {return}
                                    print(resdata)
                                    let detailsArray = try JSONSerialization.jsonObject(with: resdata, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray
                                    self.Contact_Details = detailsArray?.mutableCopy() as? NSMutableArray
                                    self.tableView.reloadData()
                                    }catch{
                                        print("error")
                                    }
                                    
                           }
                        }
                        task.resume()
        
    }
    
    // This edit button allows to delete the rows from the tableview and database.
    @IBAction func EditActionButton(_ sender: UIBarButtonItem) {
        if(sender.title == "Edit"){
            sender.title = "Done"
            tableView.isEditing = true
        }else{
            sender.title = "Edit"
            tableView.isEditing = false
        }
        
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Contact_Details?.count ?? 0
    }

    // Cell Objects are the rows are created and returned here for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? HomeTableViewCell
        let dict = Contact_Details?[indexPath.row] as! NSDictionary
        cell?.imageLabelOutlet.text = String((dict["fname"] as! String ).first!).uppercased() + String(( dict["lname"] as! String).first!).uppercased()
        cell?.imageLabelOutlet.textColor = UIColor.white
        cell?.NameOutlet.text = (dict["fname"] as! String ) + " " + ( dict["mname"] as! String ) + " " + ( dict["lname"] as! String)
        

        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! HomeTableViewCell
        name = cell.imageLabelOutlet.text
    }

    
    // Allows the user to edit rows in the table.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if(editBarButton.title == "Edit"){
            return false
        }; return true
    }
    
    
    // the Tableview is commited with the deleted rows. and the deleted object is removed from database.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dict = Contact_Details?.object(at: indexPath.row) as! NSDictionary
            deleteContact(objdict: dict)
            index = indexPath.row
            Contact_Details?.removeObject(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {

        }    
    }
    
    
    // alert message asking for user confirmation before removing contact from database.
    func deleteContact(objdict:NSDictionary){
        let alert = UIAlertController(title: "Alert", message: "Are you Sure you want to delete contact", preferredStyle: UIAlertController.Style.actionSheet)
        
        let action = UIAlertAction(title: "DELETE CONTACT", style: UIAlertAction.Style.default) { (UIAlertAction) in
                    let url = URL(string: self.server)!
            let contactID = objdict["contact_id"] as? String
                    let queryItems = [URLQueryItem(name: "contact_id", value: contactID )]
                    let newUrl = url.appending(queryItems)
                    var request = URLRequest(url: newUrl ?? url)
                    request.httpMethod = "DELETE"
                    let task = URLSession.shared.dataTask(with: request) {
                            (data, response, error) in
                            if let error = error {
                                print(error)
                                return
                            }
                            guard let resdata = data else {return}
                            print(resdata)
                            let res = String.init(data: resdata, encoding: String.Encoding.ascii)
                            DispatchQueue.main.async {
                            if(res == "deleted"){
                                self.appD?.scheduleNotification(notificationType: String(objdict["fname"] as! String) + " is removed from Database.")
                            }
                            }
                    }
                    task.resume()
                   }
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel){
            (UIAlertAction) in
            self.Contact_Details?.insert(objdict, at: self.index)
            self.tableView.reloadData()
        }
                   alert.addAction(action)
                   alert.addAction(cancelAction)
                   present(alert, animated: true, completion: nil)
                   
    }

    @objc func dismissAddContact(){
        let alert = UIAlertController(title: "Attention !", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let action = UIAlertAction(title: "DISCARD CHANGES / Exit", style: UIAlertAction.Style.default){
                  (obj) in
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
            
       
    }
    
    // MARK: - Navigation

    
    // this method is triggered when we navigate from homeview controller to addContact table view controller.
    // In this method we pass data from this view to next view. the data is fetched based on contact_id of the person from database.
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addconct = segue.destination as! AddContactTableViewController
        
        // if "+" sign is clicked this if condition is executed.
        if(segue.identifier == "AddContact" ){
                addconct.tableView.isEditing = true
                addconct.saveBarButtonOutlet.title = "Save"
            let barbutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(dismissAddContact))
            addconct.navigationItem.leftBarButtonItem = barbutton
                        
        }else{
            // when the user selects the row the else is executed. here data of that particular person is fetched with help of contact_id and transfered to next screen.
        let url = URL(string: server)!
            let dict  = Contact_Details?[tableView.indexPathForSelectedRow!.row] as! NSDictionary
            let contactID  =  dict["contact_id"] as! String
        let queryItems = [URLQueryItem(name: "contact_id", value: contactID )]
        let newUrl = url.appending(queryItems)
        var request = URLRequest(url: newUrl ?? url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) {
                    (data, response, error) in
                    if let error = error {
                        print(error)
                        return
                    }
            guard let resdata = data else {return}
            print(resdata)
            do{
                self.contactDetails = try JSONSerialization.jsonObject(with: resdata, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
            }catch{
                print("error")
            }
            DispatchQueue.main.async {
                    addconct.addArray  = (self.contactDetails?["address"] as! NSArray).mutableCopy() as! NSMutableArray
                    addconct.pharray  = (self.contactDetails?["phone"] as! NSArray).mutableCopy() as! NSMutableArray
                    addconct.datArray  = (self.contactDetails?["date"] as! NSArray).mutableCopy() as! NSMutableArray
                addconct.studentDict =  (self.contactDetails!).mutableCopy() as? NSMutableDictionary
                        addconct.ImageNameOutlet.text = self.name
                    addconct.tableView.reloadData()
            }
        }
        task.resume()
    }
    }
}

