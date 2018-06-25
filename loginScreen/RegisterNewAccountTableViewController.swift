//
//  RegisterNewAccountTableViewController.swift
//  loginScreen
//
//  Created by Wyant, Benjamin on 6/18/18.
//  Copyright © 2018 Wyant, Benjamin. All rights reserved.
//

import UIKit

class RegisterNewAccountTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate{

    var isUsernameValid = false
    var isPasswordValid = false
    var isConfirmPasswordValid = false
    var isEmailValid = false
    var isConfirmEmailValid = false

    @IBOutlet weak var colorPickerStackView: UIStackView!
    @IBOutlet weak var roleTextField: UITextField!

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var lastNameErrorLabel: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameErrorLabel: UILabel!

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!

    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!

    @IBOutlet weak var confirmEmailTextField: UITextField!
    @IBOutlet weak var confirmEmailErrorLabel: UILabel!

    var sectionToTextField = [Int: UITextField]()

    @IBOutlet weak var pickerView: UIPickerView!
    var role: String?

    @IBOutlet weak var createAccountButton: UIButton!

    let roles = ["Player", "Parent", "Coach" ]

    var errorLabels: [Int: UILabel]?

    @IBAction func createAccountButtonTapped(_ sender: Any) {
        
        self.tableView.setContentOffset(CGPoint(x: 0, y: -50), animated: true)

        // Send POST request to the server
        RegisterNewAccountController.shared.attemptRegisterNewUser(username: usernameTextField.text!, passwordString: passwordTextField.text!, email: emailTextField.text!, color: role!) { responses in

            if let responses = responses, responses.count >= 0 {

                DispatchQueue.main.async {

                    if responses[0] == "valid" {

                        let alert = UIAlertController(title: "Account Creation Successful!", message: "Check your email in order to verify your account.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default){ action in

                            self.performSegue(withIdentifier: "RegisterSuccessful", sender: self)

                        })
                        
                        self.present(alert, animated: true, completion: nil)

                    }

                    // Deal with errors
                    else {
                        
                        for reason in responses {
                            
                            switch reason {
                                
                            case "nonunique_username":
                                self.updateFooter(forSection: 0, newText: "Username already taken")
                            case "nonunique_email":
                                self.updateFooter(forSection: 3, newText: "Email already used for another account")
                            case "invalid_password_hash":
                                self.updateFooter(forSection: 1, newText: "Invalid password")
                            case "username_short":
                                self.updateFooter(forSection: 0, newText: "Username is too short")
                            case "username_long":
                                self.updateFooter(forSection: 0, newText: "Username is too long")
                            case "invalid_email":
                                self.updateFooter(forSection: 3, newText: "Invalid email")
                            case "email_long":
                                self.updateFooter(forSection: 3, newText: "Email too long")
                            default:
                                let alert = UIAlertController(title: "Unknown Server Error", message: "Sorry, we don't know what happened!", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                            
                            self.tableView.reloadData()
                            
                        }

                    }

                }

            }

        }

    }

    @IBAction func usernameChanged(_ sender: Any) {

        var text = ""
        
        if let username = usernameTextField.text {
            
            isUsernameValid = false
            
            if username.isEmpty || username.range(of: "[^a-zA-Z0-9._]", options: .regularExpression) != nil {
                
                text = "Username contains invalid characters"
                
            }
                
            else if username.count < 5 {
                
                text = "Username is too short"
                
            }
                
            else if username.count > 40 {
                
                text = "Username is too long"
                
            }
                
            else {
                
                isUsernameValid = true
                
            }
            
        }
        
        updateButton()

        self.updateFooter(forSection: 0, newText: text)

    }

    @IBAction func passwordChanged(_ sender: Any) {
        
        var text = ""
        
        if let password = passwordTextField.text {
            
            isPasswordValid = false
            
            if password.count < 5 {
                
                text = "Password is too short"
                
            }
                
            else {
                
                isPasswordValid = true
                
            }
            
            self.confirmPasswordChanged(self)
            
        }
        
        updateButton()
        
        self.updateFooter(forSection: 1, newText: text)

    }

    @IBAction func confirmPasswordChanged(_ sender: Any) {

        var text = ""
        
        if let confirmPassword = confirmPasswordTextField.text, let password = passwordTextField.text, confirmPassword != password {
            
            isConfirmPasswordValid = false
            
            text = "Password doesn't match"
            
        }
            
        else {
            
            isConfirmPasswordValid = true
            
        }
        
        updateButton()
        
        self.updateFooter(forSection: 2, newText: text)

    }

    @IBAction func emailChanged(_ sender: Any) {

        var text = ""
        
        if let email = emailTextField.text {
            
            isEmailValid = false
            
            if email.count > 45 {
                
                text = "Email is too long"
                
            }
                
            else if !NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}").evaluate(with: email) {
                
                text = "Invalid email"
                
            }
                
            else {
                
                isEmailValid = true
                
            }
            
        }
        
        updateButton()
        
        self.updateFooter(forSection: 3, newText: text)
        
    }

    @IBAction func confirmEmailChanged(_ sender: Any) {
        
        var text = ""
        
        if let confirmEmail = confirmEmailTextField.text, let email = emailTextField.text, confirmEmail != email {
            
            isConfirmEmailValid = false
            
            text = "Email doesn't match"
            
        }
            
        else {
            
            isConfirmEmailValid = true
            
        }
        
        updateButton()
        
        self.updateFooter(forSection: 4, newText: text)
        
    }

    func updateFooter(forSection section: Int, newText text: String) {

        if let label = errorLabels?[section] {

            label.textColor = UIColor.red
            label.font = UIFont(name: label.font.fontName, size: 14)
            label.text = text
            label.sizeToFit()
            label.frame = CGRect(x: label.frame.minX, y: label.frame.minY, width: label.frame.width, height: 16)

        }

    }

    func updateButton() {

        if isUsernameValid && isPasswordValid && isConfirmPasswordValid && isEmailValid && isConfirmEmailValid {

            createAccountButton.isEnabled = true

        }

        else {

            createAccountButton.isEnabled = false

        }

    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        return 1

    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return roles.count

    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return roles[row]

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        role = roles[row]
        roleTextField.text = role

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section < 6 {
            
            return 25 + usernameTextField.bounds.height + usernameErrorLabel.bounds.height
        }
        
        else if indexPath.section == 6 {
            
            return colorPickerStackView.bounds.height
            
        }
        
        else {
            
            return 60
            
        }
        
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self

        roleTextField.text? = roles.first!
        role = roles.first!

        createAccountButton.isEnabled = false

        tableView.setContentOffset(CGPoint(x: 0, y: -15), animated: true)

        errorLabels = [0: self.firstNameErrorLabel,
                       1: self.lastNameErrorLabel,
                       2: self.usernameErrorLabel,
                       3: self.passwordErrorLabel,
                       4: self.confirmPasswordErrorLabel,
                       5: self.emailErrorLabel,
                       6: self.confirmEmailErrorLabel]

    }

    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()

    }

    // MARK: - Table view data source


    /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterUserCellIdentifier", for: indexPath)

        // Configure the cell...

        // let cell = tableView.cellForRow(at: indexPath)
        cell.textLabel?.text = "hello"


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
