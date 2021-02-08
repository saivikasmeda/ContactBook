//
//  PhoneNumberTableViewCell.swift
//  DB_Project
//
//  Created by Student on 3/19/20.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit
// THis class creates objects for rows in phone group.
class PhoneNumberTableViewCell: UITableViewCell,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {

    // uicomponenets objects
    @IBOutlet weak var phOutlet: UIButton!
    @IBOutlet weak var areaCodeOutlet: UITextField!
    @IBOutlet weak var phoneNumberOutlet: UITextField!
    
    var flag = true
    var secondnumber = ""
    var firstnumber = ""
    var phArray = ["Home","Cell","Work","Fax","Others"]
    var pickerObj = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height:   140))
    var tableobj: AddContactTableViewController?
    
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pickerObj.delegate = self
        pickerObj.dataSource = self
        phoneNumberOutlet.delegate = self
        areaCodeOutlet.delegate = self
        
    }
    
    // user cannot add more then 10 digits number. the numbers keypad will be shown to the user.
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if(self.areaCodeOutlet.text!.count == 3){
            self.phoneNumberOutlet.becomeFirstResponder()
        }
        if(self.phoneNumberOutlet.text!.count == 9){
           self.phoneNumberOutlet.text = secondnumber
            return
        }
        secondnumber = self.phoneNumberOutlet.text!
        if(self.phoneNumberOutlet.text?.count == 3 && self.flag){
            self.phoneNumberOutlet.text = self.phoneNumberOutlet.text! + "-"
            self.flag = false
        };if(self.phoneNumberOutlet.text!.count < 3){
            self.flag = true
        }
            let dict = (self.tableobj?.pharray[self.phoneNumberOutlet.tag]  as! NSDictionary).mutableCopy() as! NSMutableDictionary
                self.tableobj?.pharray[self.phoneNumberOutlet.tag]  = dict
                dict["phonenumber"] = phoneNumberOutlet.text
                dict["area"] = areaCodeOutlet.text
                dict["type"] = self.phArray[self.pickerObj.selectedRow(inComponent: 0)] as! String
    }

    
    // This method return the type of phone the user is selected from "Home,Cell,Work,Others" etc
    @IBAction func ButtonAction(_ sender: UIButton) {
        if(tableobj?.tableView.isEditing == true){
            let alert = UIAlertController(title: "Choose", message: "\n\n\n\n\n", preferredStyle: .alert)
            alert.isModalInPresentation = true
            alert.view.addSubview((pickerObj))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                self.phOutlet.setTitle(self.phArray[self.pickerObj.selectedRow(inComponent: 0)], for: UIControl.State.normal)
                let dict = (self.tableobj?.pharray[self.phoneNumberOutlet.tag]  as! NSDictionary).mutableCopy() as! NSMutableDictionary
                self.tableobj?.pharray[self.phoneNumberOutlet.tag]  = dict
                dict["type"] = self.phArray[self.pickerObj.selectedRow(inComponent: 0)]
            }))
            tableobj?.present(alert, animated: true, completion: nil)
        }
    }
    
    //This method returns the titles for each row in picker view.
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
           var pickerLabel: UILabel? = (view as? UILabel)
           if pickerLabel == nil {
               pickerLabel = UILabel()
               pickerLabel?.font = UIFont(name: "Arial", size: 18)
               pickerLabel?.textAlignment = .center
           }
           pickerLabel?.text = phArray[row]
           pickerLabel?.textColor = UIColor.black

           return pickerLabel!
       }
    // no of groups in picker view
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
//    no. of rows in each group of picker view.
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return phArray.count
       }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneNumberOutlet.resignFirstResponder()
        areaCodeOutlet.resignFirstResponder()
    }
}
