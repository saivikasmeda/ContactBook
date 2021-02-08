//
//  NameTableViewCell.swift
//  DB_Project
//
//  Created by Student on 3/19/20.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit

// This class create objects for rows in add contact table view controller firstname, lastname, middle name.
class NameTableViewCell: UITableViewCell,UITextFieldDelegate {

    // global objects.
    var tableObj: AddContactTableViewController?

    // Outlets are name textfield uicomponent.
    @IBOutlet weak var nameOutlet: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameOutlet.delegate = self
        // Initialization code
    }
    
    
    // textfield delete method which trigger when there is change in textfield.
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if(textField.tag == 0){
               tableObj?.studentDict?["fname"] =  textField.text
           }else if(textField.tag == 1){
               tableObj?.studentDict?["mname"] =  textField.text
           }else {
               tableObj?.studentDict?["lname"] =  textField.text
           }
        tableObj?.ImageNameOutlet.text = String((tableObj?.studentDict?["fname"] as! String).first?.uppercased() ?? "")+String((tableObj?.studentDict?["lname"] as! String).first?.uppercased() ?? "")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameOutlet.resignFirstResponder()
    }
}
