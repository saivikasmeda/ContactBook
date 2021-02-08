//
//  DateTableViewCell.swift
//  DB_Project
//
//  Created by Student on 3/19/20.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit
// This class creates the object for each row in date group of add contacttable view controller.
class DateTableViewCell: UITableViewCell,UIPickerViewDelegate,UIPickerViewDataSource {

    // uicomponenets objects.
    @IBOutlet weak var buttoncatOutlet: UIButton!
    @IBOutlet weak var dateOutlet: UITextField!
    
    // global varibales
    var datArray = ["Birhtday","Anniversary","others"]
    var pickerObj = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height:   140))
    var tableobj: AddContactTableViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerObj.delegate = self
        pickerObj.dataSource = self
        self.dateOutlet.setInputDatePicker(target: self, selector: #selector(tapDone))
        
    }
    
    // date formatting.
    @objc func tapDone() {
        if let datePicker = self.dateOutlet.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            
            dateformatter.dateFormat = "yyyy-MM-dd" // 2-3
            self.dateOutlet.text = dateformatter.string(from: datePicker.date) //2-4
        }
         let dict = (self.tableobj?.datArray[self.dateOutlet.tag]  as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.tableobj?.datArray[self.dateOutlet.tag] = dict
        dict["date"] = dateOutlet.text
        self.dateOutlet.resignFirstResponder() // 2-5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // this method return what type of date the user is selects
    @IBAction func ButtonAction(_ sender: UIButton) {
        if(tableobj?.tableView.isEditing) ?? false{
        let alert = UIAlertController(title: "Choose", message: "\n\n\n\n\n", preferredStyle: .alert)
           alert.isModalInPresentation = true
           alert.view.addSubview((pickerObj))
           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            sender.setTitle(self.datArray[self.pickerObj.selectedRow(inComponent: 0)], for: UIControl.State.normal)
            let dict = self.tableobj?.datArray[self.dateOutlet.tag] as! NSMutableDictionary
            dict["type"] = self.datArray[self.pickerObj.selectedRow(inComponent: 0)]
           }))
           tableobj?.present(alert, animated: true, completion: nil)
        }
    }
    
    // this method return the title for each row in picker view
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
              var pickerLabel: UILabel? = (view as? UILabel)
              if pickerLabel == nil {
                  pickerLabel = UILabel()
                  pickerLabel?.font = UIFont(name: "Arial", size: 18)
                  pickerLabel?.textAlignment = .center
              }
              pickerLabel?.text = datArray[row]
              pickerLabel?.textColor = UIColor.black

              return pickerLabel!
          }
//    this method return the no.of componenets in picker view
          func numberOfComponents(in pickerView: UIPickerView) -> Int {
              return 1
          }
//     this method return the no. of rows in each group of pciker view
          func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
              return datArray.count
          }
       
    
}
extension UITextField{
//     This method display the date picker view when the user select the text field to select.
    func setInputDatePicker(target: Any, selector: Selector){
        let screenWidth = UIScreen.main.bounds.width
            let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
            datePicker.datePickerMode = .date //2
            self.inputView = datePicker //3
            
            // Create a toolbar and assign it to inputAccessoryView
            let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
            let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
            let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
            let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
            toolBar.setItems([cancel, flexible, barButton], animated: false) //8
            self.inputAccessoryView = toolBar //9
        
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }

}
