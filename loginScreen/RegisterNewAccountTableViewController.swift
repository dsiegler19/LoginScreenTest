//
//  RegisterNewAccountTableViewController.swift
//  loginScreen
//
//  Created by Wyant, Benjamin on 6/18/18.
//  Copyright © 2018 Wyant, Benjamin. All rights reserved.
//

import UIKit

class RegisterNewAccountTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var colorPickerStackView: UIStackView!
    @IBOutlet weak var favoriteColorTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmEmailTextField: UITextField!
    
    @IBOutlet weak var pickerView: UIPickerView!
    var favoriteColor: String?
    
    @IBOutlet weak var createAccountButton: UIButton!
    let colors = ["Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Pink"]
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        
        // Send POST request to the server
        RegisterNewAccountController.shared.attemptRegisterNewUser(username: usernameTextField.text!, passwordString: passwordTextField.text!, email: emailTextField.text!, color: favoriteColor!) { responses in
            
            if let responses = responses, responses.count >= 0 && responses[0] == "valid" {
                
                
                
            }
            
            
            
        }
        
        // Read back the results
        // Display the appropriate response/error messages
        
    }
    
    @IBAction func usernameChanged(_ sender: Any) {
        
        var text = ""
        
        if let username = usernameTextField.text {
            
            if username.isEmpty || username.range(of: "[^a-zA-Z0-9._]", options: .regularExpression) != nil {
                
                text = "Username contains invalid characters"
                
            }
            
            if username.count < 5 {
                
                text = "Username is too short"
                
            }
            
            if username.count > 40 {
                
                text = "Username is too long"
                
            }
            
        }
        
        self.updateFooter(forSection: 0, newText: text)
        
    }
    
    @IBAction func passwordChanged(_ sender: Any) {
        
        var text = ""
        
        if let password = passwordTextField.text {
            
            if password.count < 5 {
                
                text = "Password is too short"
                
            }
            
        }
        
        self.updateFooter(forSection: 1, newText: text)
        
    }
    
    @IBAction func confirmPasswordChanged(_ sender: Any) {
        
        var text = ""
        
        if let confirmPassword = confirmPasswordTextField.text, let password = passwordTextField.text, confirmPassword != password {
            
            text = "Password doesn't match"
            
        }
        
        self.updateFooter(forSection: 2, newText: text)
        
    }
    
    @IBAction func confirmEmailChanged(_ sender: Any) {
        
        var text = ""
        
        if let confirmEmail = confirmEmailTextField.text, let email = emailTextField.text, confirmEmail != email {
            
            text = "Email doesn't match"
            
        }
        
        self.updateFooter(forSection: 4, newText: text)
        
    }
    
    func updateFooter(forSection section: Int, newText text: String) {
        
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        
        if let containerView = self.tableView.footerView(forSection: section) {
            
            containerView.textLabel!.textColor = UIColor.red
            containerView.textLabel!.text = text
            containerView.textLabel!.font = UIFont(name: containerView.textLabel!.font.fontName, size: 12)
            containerView.sizeToFit()
            
        }
        
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return colors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        favoriteColor = colors[row]
        favoriteColorTextField.text = favoriteColor
    
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 5 {
            
            return colorPickerStackView.bounds.height
        } else if indexPath.section == 6{
            return 60
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
            
        }
        
    }
    
    /*override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
     
        let footerView = UIView(frame: CGRect(x: 8, y: 0, width: tableView.frame.size.width, height: 12))
        let label = UILabel(frame: footerView.frame)
        label.textColor = UIColor.red
        
        var text = ""

        switch section {
            
        case 0:
            text = usernameErrorText
        case 1:
            text = passwordErrorText
        case 2:
            text = confirmPasswordErrorText
        case 3:
            text = emailErrorText
        case 4:
            text = confirmEmailErrorText
        default:
            text = ""
            
        }
        
        label.text = text
        footerView.addSubview(label)
        
        return footerView
        
    }*/
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        favoriteColorTextField.text = colors.first!

    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()

    }
    
    
    // MARK: - Table view data source

    
    /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        
        let cell = tableView.cellForRow(at: indexPath)

        return cell
    }*/
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
