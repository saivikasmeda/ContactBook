//
//  AddressTableViewCell.swift
//  DB_Project
//
//  Created by Student on 3/18/20.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit

// This class creates objects for address rows in table view.
class AddressTableViewCell: UITableViewCell,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    //Global varibles of this address cell class.
    var addarray = ["Home", "work","Others"]
    var pickerObj = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height:   140))
    var tableobj: AddContactTableViewController?
    
    // UIcomponents objects of address cell.
    @IBOutlet weak var stateOutlet: UITextField!
    @IBOutlet weak var zipOutlet: UITextField!
    @IBOutlet weak var cityOutlet: UITextField!
    @IBOutlet weak var aptOutlet: UITextField!
    @IBOutlet weak var streetOutlet: UITextField!
    @IBOutlet weak var buttonCat: UIButton!
    
    
    
    
    // This method give the type of address the user selected from the popup picker view.
    @IBAction func buttonAction(_ sender: UIButton) {
        if(tableobj?.tableView.isEditing ?? false){
        let alert = UIAlertController(title: "Choose", message: "\n\n\n\n\n", preferredStyle: .alert)
        alert.isModalInPresentation = true
        alert.view.addSubview((pickerObj))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
        sender.setTitle(self.addarray[self.pickerObj.selectedRow(inComponent: 0)] as! String, for: UIControl.State.normal)
        let dict = (self.tableobj?.addArray[self.stateOutlet.tag]  as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.tableobj?.addArray[self.stateOutlet.tag] = dict
        dict["type"] = self.addarray[self.pickerObj.selectedRow(inComponent: 0)] as! String
        }))
        tableobj?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    
    // Setting the delegate and datasource properties to this class. so that delegate methods can be called automatically.
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerObj.delegate = self
        pickerObj.dataSource = self
        streetOutlet.delegate = self
        stateOutlet.delegate = self
        zipOutlet.delegate = self
        cityOutlet.delegate  = self
        aptOutlet.delegate = self
    }
    
    // This is a textfield delegate method which triggers when ever there is change in textfield.
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let dict = (self.tableobj?.addArray[self.stateOutlet.tag]  as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.tableobj?.addArray[self.stateOutlet.tag]  = dict
           dict["street"] = streetOutlet.text
           dict["city"] = cityOutlet.text
           dict["state"] = stateOutlet.text
           dict["zipcode"] = zipOutlet.text
           dict["type"] = self.addarray[self.pickerObj.selectedRow(inComponent: 0)] as! String
           dict["apt"] = aptOutlet.text
           
    }

    
    // This is pickerview related method which provides data to pickerview to diplay for the user.
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Arial", size: 18)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = addarray[row]
        pickerLabel?.textColor = UIColor.black

        return pickerLabel!
    }
    // this method return no.of groups in picker view.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // This method returns no.of rows in each group of picker view.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return addarray.count
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Touch began option will remove the textfields from first responder when the user clicks away. that is the keyboard will disappear.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        streetOutlet.resignFirstResponder()
        cityOutlet.resignFirstResponder()
        zipOutlet.resignFirstResponder()
        stateOutlet.resignFirstResponder()
        aptOutlet.resignFirstResponder()
    }
}
