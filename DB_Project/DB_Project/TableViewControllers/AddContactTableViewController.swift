//
//  AddContactTableViewController.swift
//  DB_Project
//
//  Created by Student on 3/18/20.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit
// In this class we add new contacts to database. we modify exciting contacts in database. and we delete contacts from database.
class AddContactTableViewController:UITableViewController {
    
    // Global varibles declared in this class.
    let appD = UIApplication.shared.delegate as? AppDelegate
    let server = "http://localhost:3000"
    var pharray = NSMutableArray()
    var addArray = NSMutableArray()
    var datArray = NSMutableArray()
    var studentDict:NSMutableDictionary?
    var data:Data?
    
    // outlet objects from ui components in addcontacttableviewcontroller.
    @IBOutlet weak var saveBarButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var ImageOutlet: UIImageView!
    @IBOutlet weak var ImageNameOutlet: UILabel!
    

    // When the user clicks on cancel button in modifiy mode. ASking for discard changes or else continue with editing data. if discard changes is selected - data will be reseted to default information.
    @objc func dismissAddContact(){
        let alert = UIAlertController(title: "Attention !", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let action = UIAlertAction(title: "DISCARD CHANGES", style: UIAlertAction.Style.default){
            (obj) in
          self.navigationItem.leftBarButtonItem = nil
          self.addArray = (self.studentDict?["address"] as? NSArray)!.mutableCopy()  as! NSMutableArray
          self.pharray =  (self.studentDict?["phone"] as? NSArray)!.mutableCopy() as! NSMutableArray
          self.datArray = (self.studentDict?["date"] as? NSArray)!.mutableCopy() as! NSMutableArray
          self.saveBarButtonOutlet.title = "Modify"
          self.tableView.isEditing = false
          self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
      
    }
    
    // Custom alert message when the input information doesn't not satisfies the condition.
    func alertTrigger(msg: String){
        let alert = UIAlertController(title: "Attention !", message: msg, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // On click of save button right top cornor. The information is updated in database.
    @IBAction func SaveBarButtonAction(_ sender: UIBarButtonItem) {
        if( sender.title == "Save"){
                studentDict?["address"] = addArray
                studentDict?["phone"] = pharray
                studentDict?["date"] = datArray
            
            // validating information entered into the respective fname and lname fields.
            if((studentDict?["fname"] as! String).trimmingCharacters(in: CharacterSet.whitespaces) == "" ){
                alertTrigger(msg: "First Name cannot be empty")
                return
            }else if ((studentDict?["lname"] as! String).trimmingCharacters(in: CharacterSet.whitespaces)  == ""){
                alertTrigger(msg: "Last name can't be empty")
                return
            }
            // validating phone number entered by the user.
            if(pharray.count != 0 ){
               for i in 0..<pharray.count{
               let dict = pharray[i] as? NSDictionary
                if((dict?["area"] as! String).count != 3){
                   alertTrigger(msg: "Area Code should be 3 digit long")
                    return
               }else if ((dict?["phonenumber"] as! String).count != 8){
                   alertTrigger(msg: "Phone number Should be 7 digit long")
                    return
               }
            }};
            
            // validating address entered by the user.
            if(addArray.count != 0){
                for  i in 0..<addArray.count{
                    let dict = addArray[i] as? NSDictionary
                    if((dict?["street"] as! String).trimmingCharacters(in: CharacterSet.whitespaces) == "" && (dict?["city"] as! String).trimmingCharacters(in: CharacterSet.whitespaces) == "" && (dict?["state"] as! String).trimmingCharacters(in: CharacterSet.whitespaces) == "" && (dict?["state"] as! String).trimmingCharacters(in: CharacterSet.whitespaces) == "" && (dict?["zipcode"] as! String).trimmingCharacters(in: CharacterSet.whitespaces) == ""){
                        alertTrigger(msg: "All fields in address can't be empty")
                        return
                        
                    }
            }};
            
            // validating data text field.
            if(datArray.count != 0 ){
                for i in 0..<datArray.count{
                let dict = datArray[i] as? NSDictionary
                    if((dict?["date"] as! String).trimmingCharacters(in: CharacterSet.whitespaces)  == ""){
                    alertTrigger(msg: "Date is missing")
                    return
                }
            }}
           // Updating the details of the user into the database.
            if((studentDict?["contact_id"] as! String).trimmingCharacters(in: CharacterSet.whitespaces) != ""){
                let url = URL(string: server+"/update")!
                let contactID = studentDict!["contact_id"] as? String
                let queryItems = [URLQueryItem(name: "contact_id", value: contactID )]
                let newUrl = url.appending(queryItems)
                var request = URLRequest(url: newUrl ?? url)
                do{
                    data = try JSONSerialization.data(withJSONObject: studentDict!, options: JSONSerialization.WritingOptions.fragmentsAllowed)
                    }
                catch{
                    print("error")
                }
                request.httpBody = data
                request.httpMethod = "POST"
                let task = URLSession.shared.dataTask(with: request) {
                        (data, response, error) in
                        if let error = error {
                            print(error)
                            return
                        }
                        guard let resdata = data else {return}
//                        print(resdata)
                    _ = String.init(data: resdata, encoding: String.Encoding.ascii)
                }
                
                task.resume()
                 self.appD?.scheduleNotification(notificationType: String(self.studentDict?["fname"] as! String) + " details has been Updated.")
            }
            else{
                
                // Adding new contact into the database.
                do{
                    data = try JSONSerialization.data(withJSONObject: studentDict!, options: JSONSerialization.WritingOptions.fragmentsAllowed)
                }
                catch{
                    print("error")
                }
                guard let url  = URL(string: server+"/add") else {return}
                var request = URLRequest(url: url)
                request.httpBody = data
                request.httpMethod = "POST"
                let task = URLSession.shared.dataTask(with: request) {
                    (data, response, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    guard let resdata = data else {return}
                    print(resdata)
                }
                task.resume()
                self.appD?.scheduleNotification(notificationType: String(self.studentDict?["fname"] as! String) + " has been added to Database.")
            }
           
            navigationController?.popViewController(animated: true)
    }
    // updating modify button title based on user selection.
    else if (sender.title == "Modify"){
            let barbutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(dismissAddContact))
            self.navigationItem.leftBarButtonItem = barbutton
            tableView.isEditing = true
            sender.title = "Save"
            tableView.reloadData()
        }
        
}
    
    // When the view is loaded we're setting based properties from image and imagelabel outlet.
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelectionDuringEditing = true
        ImageNameOutlet.text = ""
        ImageNameOutlet.textColor = UIColor.white
        ImageOutlet.layer.masksToBounds = true
        ImageOutlet.layer.cornerRadius = ImageOutlet.bounds.width/2
        
        ImageOutlet.backgroundColor = UIColor.gray
        if(studentDict == nil){
        studentDict = NSMutableDictionary(objects: ["","","","",pharray,addArray,datArray], forKeys: ["contact_id" as NSCopying, "fname" as NSCopying,"mname" as NSCopying, "lname" as NSCopying, "phone" as NSCopying, "address" as NSCopying, "date" as NSCopying ])
        }

    }

    // MARK: - Table view data source

    
    //this method returns no.of sections in the table view (like no of groups)
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if((studentDict?["contact_id"] as! String).trimmingCharacters(in: CharacterSet.whitespaces) != "" && tableView.isEditing == true){
            return 5
        }
        return 4
    }

    //this method returns no. of rows in each group(section).
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.isEditing == false){
            if(section == 0){
                       return 3
            }else if (section == 1){
                       return pharray.count
            }else if (section == 2){
                       return addArray.count
            }else if(section == 3){
                return datArray.count}
            else {
                return 1
            }
        }
        
        if(section == 0){
            return 3
        }else if (section == 1){
            return pharray.count+1
        }else if (section == 2){
            return addArray.count+1
        }else if( section == 3){
            return datArray.count+1}
        return 1
    }

    // This method returns Footer for each group in table view.
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if(saveBarButtonOutlet.title == "Modify" && section != 3){
            return " "
        }else if(saveBarButtonOutlet.title == "Modify" && section == 3){
            return ""
        }
        if(saveBarButtonOutlet.title == "Save" && section != 4){
               return " "
        }else{
                   return " "
        }
    }
    
    // this method returns Title for each group in tableview.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0 ){
            return "Name Details"
        }else if(section == 1){
            return "Phone Details"
        }else if(section == 2){
            return "Address Details"
        }else if(section == 3 ){
            return "Date Details"
        };return  ""
        
    }
    
    // cell object for each group and each row is created and returned by this method. and we set the properties of avaible UIComponents in this method. Default information or empty fields.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseName", for: indexPath) as! NameTableViewCell
            cell.nameOutlet.tag = indexPath.row
            cell.tableObj = self
            cell.nameOutlet.isEnabled = saveBarButtonOutlet.title == "Save"
            
            if((studentDict?["fname"] as! String).trimmingCharacters(in: CharacterSet.whitespaces) != "" && indexPath.row == 0){
                cell.nameOutlet.text = studentDict?["fname"] as? String
               
            }else if (indexPath.row == 0){
                 cell.nameOutlet.placeholder = "First Name"
            }
            if((studentDict?["mname"] as! String).trimmingCharacters(in: CharacterSet.whitespaces) != "" && indexPath.row == 1){
                cell.nameOutlet.text = studentDict?["mname"] as? String
            }else if (indexPath.row == 1){
                cell.nameOutlet.placeholder = "Middle Name (Optional)"
            }
            if((studentDict?["lname"] as! String).trimmingCharacters(in: CharacterSet.whitespaces) != "" && indexPath.row == 2){
                cell.nameOutlet.text = studentDict?["lname"] as? String
            }else if(indexPath.row == 2){
                 cell.nameOutlet.placeholder = "Last Name"
            }

            return cell
        }else if (indexPath.section == 1){
            if(indexPath.row == pharray.count){
                let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)
                cell.textLabel?.text = "Add PhoneNumber"
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneNumber", for: indexPath) as? PhoneNumberTableViewCell
                cell?.tableobj = self
            cell?.phoneNumberOutlet.tag = indexPath.row
            
            // disabling all UIComponents when view in display mode.
            cell?.phoneNumberOutlet.isEnabled = tableView.isEditing
            cell?.areaCodeOutlet.isEnabled = tableView.isEditing
            
            let dict = (pharray[indexPath.row] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            if((dict["area"] as! String).trimmingCharacters(in: CharacterSet.whitespaces) != ""){
                cell?.areaCodeOutlet.text = dict["area"] as? String
            };
            if((dict["phonenumber"] as! String).trimmingCharacters(in: CharacterSet.whitespaces) != ""){
                cell?.phoneNumberOutlet.text = dict["phonenumber"] as? String
            }
            cell?.phOutlet.setTitle(dict["type"] as? String, for: UIControl.State.normal)
                return cell!
        }else if (indexPath.section == 2){
            if(indexPath.row == addArray.count){
                let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)
                cell.textLabel?.text = "Add Address"

                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "Address", for: indexPath) as? AddressTableViewCell
            cell?.tableobj = self
            cell?.stateOutlet.tag = indexPath.row
            // disabling all UIComponents when view in display mode.
            cell?.stateOutlet.isEnabled = tableView.isEditing
            cell?.cityOutlet.isEnabled = tableView.isEditing
            cell?.zipOutlet.isEnabled = tableView.isEditing
            cell?.streetOutlet.isEnabled = tableView.isEditing
            cell?.aptOutlet.isEnabled = tableView.isEditing
            
             let dict = (addArray[indexPath.row] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            if((dict["street"] as! String).trimmingCharacters(in: CharacterSet.whitespaces) != ""){
                cell?.streetOutlet.text = dict["street"] as? String
            };if((dict["apt"] as! String).trimmingCharacters(in: CharacterSet.whitespaces) != ""){
                cell?.aptOutlet.text = dict["apt"] as? String
            };if((dict["city"] as! String).trimmingCharacters(in: CharacterSet.whitespaces) != ""){
                cell?.cityOutlet.text = dict["city"] as? String
            };if((dict["zipcode"] as! String).trimmingCharacters(in: CharacterSet.whitespaces) != ""){
                 cell?.zipOutlet.text = dict["zipcode"] as? String
            }; if((dict["state"] as! String).trimmingCharacters(in: CharacterSet.whitespaces) != ""){
                cell?.stateOutlet.text = dict["state"] as? String
            }
            cell?.buttonCat.setTitle(dict["type"] as? String, for: UIControl.State.normal)
            return cell!
            
        }else if (indexPath.section == 3){
            if(indexPath.row == datArray.count){
                let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)
                cell.textLabel?.text = "Add Date"

                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "Date", for: indexPath) as! DateTableViewCell
             cell.tableobj = self
            cell.dateOutlet.tag = indexPath.row
            
            // disabling all UIComponents when view in display mode.
            cell.dateOutlet.isEnabled = tableView.isEditing
            
            let dict = (datArray[indexPath.row] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            cell.dateOutlet.text  = dict["date"] as? String
            cell.buttoncatOutlet.setTitle(dict["type"] as? String
                , for: UIControl.State.normal)
            return cell
        }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)
                cell.textLabel?.text = "Delete Contact"
                cell.textLabel?.textColor = UIColor.red

                return cell
            
        }
    }
    
    
    
    // DEleting the contact from tableview and database when the user select delete contact row from tableview while editing.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0 && indexPath.section == 4){
            let alert = UIAlertController(title: "Alert", message: "Are you Sure you want to delete contact", preferredStyle: UIAlertController.Style.actionSheet)
            let action = UIAlertAction(title: "DELETE CONTACT", style: UIAlertAction.Style.default) { (UIAlertAction) in
                let url = URL(string: self.server)!
                let contactID = self.studentDict!["contact_id"] as? String
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
                            self.navigationController?.popViewController(animated: true)
                            if(res == "deleted"){
                               self.appD?.scheduleNotification(notificationType: String(self.studentDict?["fname"] as! String) + " is removed from Database.")
                           }
                  
                       }
                   }
                   task.resume()
            }
            let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
            
           
        }
    }

    // Setting the height of each row in the tableview.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
             return CGFloat.init(exactly: NSNumber.init(integerLiteral: 44 )) ?? 44
        }
        else if(indexPath.section == 1){
            if(indexPath.row == pharray.count){
                return CGFloat.init(exactly: NSNumber.init(integerLiteral:37)) ?? 37}
          return CGFloat.init(exactly: NSNumber.init(integerLiteral:56)) ?? 56
        }
        else if(indexPath.section == 2){
            if(indexPath.row == addArray.count){
            return CGFloat.init(exactly: NSNumber.init(integerLiteral:37)) ?? 37}
            return CGFloat.init(exactly: NSNumber.init(integerLiteral: 103 )) ?? 103}
         return CGFloat.init(exactly: NSNumber.init(integerLiteral: 44 )) ?? 44
    }
    
    
    // This method returns which rows to be editted and which are not.
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.section == 0 || indexPath.section == 4){
            return false
        };if(saveBarButtonOutlet.title == "Modify"){
            return false
        }else{
            return true
        }
    }
    
    
    // This method return what time of editting style should each row contain.
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if(indexPath.section == 1 && indexPath.row == pharray.count){
            return UITableViewCell.EditingStyle.insert
        }else if (indexPath.section == 2 && indexPath.row == addArray.count){
            return UITableViewCell.EditingStyle.insert
        }else if(indexPath.section == 3 && indexPath.row == datArray.count){
            return UITableViewCell.EditingStyle.insert
        }
        else{
           return  UITableViewCell.EditingStyle.delete
        }
    }
    
    
    // This method commit the editing made by the user on the tableview either insert or delete.
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if(indexPath.section == 1){
                pharray.removeObject(at: indexPath.row)}
            else if(indexPath.section == 2){
                addArray.removeObject(at: indexPath.row)
            }else if (indexPath.section == 3){
                datArray.removeObject(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            if(indexPath.section == 1){
                let dict = NSMutableDictionary(objects: ["Home","",""], forKeys: ["type" as NSCopying,"phonenumber" as NSCopying,"area" as NSCopying])
                pharray.add(dict)}
            else if(indexPath.section == 2){
                let dict = NSMutableDictionary(objects: ["Home","","","","",""], forKeys: ["type" as NSCopying,"street" as NSCopying,"apt" as NSCopying,"city" as NSCopying,"state" as NSCopying,"zipcode" as NSCopying])
                addArray.add(dict)
            }else if(indexPath.section == 3){
                let dict = NSMutableDictionary(objects: ["Birthday",""], forKeys: ["type" as NSCopying,"date" as NSCopying])
                datArray.add(dict)
            }
            tableView.reloadData()
        }
        
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
//        det.ActionButton = tableView.cellForRow(at: tableView.indexPathForSelectedRow)
    }
    

}

