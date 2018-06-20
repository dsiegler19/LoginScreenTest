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
    @IBOutlet weak var favoriteColorTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmEmailTextField: UITextField!
    
    var sectionToTextField = [Int: UITextField]()
    
    @IBOutlet weak var pickerView: UIPickerView!
    var favoriteColor: String?
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    let colors = ["Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Pink"]
    
    var errorTexts: [Int: String]?

    let events = EventManager()

    @IBAction func createAccountButtonTapped(_ sender: Any) {
                
        // Send POST request to the server
        RegisterNewAccountController.shared.attemptRegisterNewUser(username: usernameTextField.text!, passwordString: passwordTextField.text!, email: emailTextField.text!, color: favoriteColor!) { responses in
            
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
                        
                        self.tableView.setContentOffset(CGPoint(x: 0, y: -15), animated: true)
                        
                        print("here")
                        print(responses)

                        // for reason in responses {
                        //     print(reason)
                        //
                        //     switch reason {
                        //
                        //     case "nonunique_username":
                        //         print(1)
                        //         self.updateFooter(forSection: 3, newText: "Username already taken")
                        //     case "nonunique_email":
                        //         self.updateFooter(forSection: 3, newText: "Email already used for another account")
                        //     case "invalid_password_hash":
                        //         self.updateFooter(forSection: 1, newText: "Invalid password")
                        //     case "username_short":
                        //         self.updateFooter(forSection: 3, newText: "Username is too short")
                        //     case "username_long":
                        //         self.updateFooter(forSection: 3, newText: "Username is too long")
                        //     case "invalid_email":
                        //         self.updateFooter(forSection: 3, newText: "Invalid email")
                        //     case "email_long":
                        //         self.updateFooter(forSection: 3, newText: "Email too long")
                        //     default:
                        //         let alert = UIAlertController(title: "Unknown Server Error", message: "Sorry, we don't know what happened!", preferredStyle: .alert)
                        //         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        //
                        //         self.present(alert, animated: true, completion: nil)
                        //
                        //     }
                        //
                        //     self.tableView.reloadData()
                        //
                        // }

                    }
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func usernameChanged(_ sender: Any) {

        // var text = ""
        //
        // if let username = usernameTextField.text {
        //
        //     isUsernameValid = false
        //
        //     if username.isEmpty || username.range(of: "[^a-zA-Z0-9._]", options: .regularExpression) != nil {
        //
        //         text = "Username contains invalid characters"
        //
        //     }
        //
        //     else if username.count < 5 {
        //
        //         text = "Username is too short"
        //
        //     }
        //
        //     else if username.count > 40 {
        //
        //         text = "Username is too long"
        //
        //     }
        //
        //     else {
        //
        //         isUsernameValid = true
        //
        //     }
        //
        // }
        //
        // updateButton()
        
        // self.updateFooter(forSection: 0, newText: text)

        self.events.trigger(eventName: "usernameChanged")

    }
    
    @IBAction func passwordChanged(_ sender: Any) {
        //
        // var text = ""
        //
        // if let password = passwordTextField.text {
        //
        //     isPasswordValid = false
        //
        //     if password.count < 5 {
        //
        //         text = "Password is too short"
        //
        //     }
        //
        //     else {
        //
        //         isPasswordValid = true
        //
        //     }
        //
        //     self.confirmPasswordChanged(self)
        //
        // }
        //
        // updateButton()
        //
        // self.updateFooter(forSection: 1, newText: text)

        self.events.trigger(eventName: "passwordChanged")

    }
    
    @IBAction func confirmPasswordChanged(_ sender: Any) {

        // var text = ""
        //
        // if let confirmPassword = confirmPasswordTextField.text, let password = passwordTextField.text, confirmPassword != password {
        //
        //     isConfirmPasswordValid = false
        //
        //     text = "Password doesn't match"
        //
        // }
        //
        // else {
        //
        //     isConfirmPasswordValid = true
        //
        // }
        //
        // updateButton()
        //
        // print("in confirm password")
        // print(sender as? RegisterNewAccountTableViewController)
        //
        // self.updateFooter(forSection: 2, newText: text, updateFocus: sender as? RegisterNewAccountTableViewController == nil)
        self.events.trigger(eventName: "confirmPasswordChanged")
    }
    
    @IBAction func emailChanged(_ sender: Any) {

        // var text = ""
        //
        // if let email = emailTextField.text {
        //
        //     if email.count > 45 {
        //
        //         text = "Email is too long"
        //
        //         isEmailValid = false
        //
        //     }
        //
        //     else {
        //
        //         isEmailValid = true
        //
        //     }
        //
        //     self.confirmEmailChanged(self)
        //
        // }
        //
        // updateButton()
        //
        // self.updateFooter(forSection: 3, newText: text)

        self.events.trigger(eventName: "emailChanged")

    }
    
    @IBAction func confirmEmailChanged(_ sender: Any) {
        //
        // var text = ""
        //
        // if let confirmEmail = confirmEmailTextField.text, let email = emailTextField.text, confirmEmail != email {
        //
        //     isConfirmEmailValid = false
        //
        //     text = "Email doesn't match"
        //
        // }
        //
        // else {
        //
        //     isConfirmEmailValid = true
        //
        // }
        //
        // updateButton()
        //
        // self.updateFooter(forSection: 4, newText: text)

        self.events.trigger(eventName: "confirmEmailChanged")

    }

    func updateFooter() {
        self.events.listenTo(eventName: "passwordChanged", action: {
            print("passwordChanged listened to.")

            var text = ""

            if let password = self.passwordTextField.text {
                self.isPasswordValid = false

                if password.count < 5 {
                    text = "Password is too short"
                }

                else {
                    self.isPasswordValid = true
                }

            }

            if let containerView = self.tableView.footerView(forSection: 1) {
                print("Changing label text.");
                containerView.textLabel!.textColor = UIColor.red;
                containerView.textLabel!.text = text;
                containerView.textLabel!.font = UIFont(name: containerView.textLabel!.font.fontName, size: 12);
                containerView.bounds = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 20);
            }
        });

        self.events.listenTo(eventName: "usernameChanged", action: {
            print("usernameChanged listened to.")
        });


        // UIView.setAnimationsEnabled(false)
        // self.tableView.beginUpdates()

        // errorTexts?[section] = text // nope

        // self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        // self.tableView.footerView(forSection: 0)?.reloadInputViews()
        // self.tableView.reloadInputViews()
        // self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        // self.tableView.footerView(forSection: 0)
        
        //self.tableView.endUpdates()
        //UIView.setAnimationsEnabled(false)
        
        
        // self.tableView.reloadData()
        // self.usernameTextField.becomeFirstResponder()

        // if updateFocus {
        //
        //     sectionToTextField[section]!.becomeFirstResponder()
        //
        // }
        //
        // print(section)

        // print(section)
        // print(self.tableView(self.tableView, viewForFooterInSection: section))
        // print("IN UPDATE FOOTER")
        // self.tableView.footerView(forSection: 0).
        
        /*if let containerView = tableView.footerView(forSection: section) { //self.tableView(tableView, viewForFooterInSection: section), let label = containerView.subviews.first as? UILabel {
            
            // print("17")
            
            // label.text = text
            
            containerView.textLabel!.textColor = UIColor.red
            containerView.textLabel!.text = text
            containerView.textLabel!.font = UIFont(name: containerView.textLabel!.font.fontName, size: 12)
            containerView.sizeToFit()
            
            // print(containerView.textLabel?.text)
            
        }*/
        
        // self.tableView.endUpdates()
        // UIView.setAnimationsEnabled(true)
        
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

    // override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //
    //     if indexPath.section == 5 {
    //
    //         return colorPickerStackView.bounds.height
    //
    //     }
    //
    //     else if indexPath.section == 6 {
    //
    //         return 60
    //
    //     }
    //
    //     else {
    //
    //         return super.tableView(tableView, heightForRowAt: indexPath)
    //
    //     }
    //
    // }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        favoriteColorTextField.text = colors.first!
        favoriteColor = colors.first!
        
        createAccountButton.isEnabled = false
        
        tableView.setContentOffset(CGPoint(x: 0, y: -15), animated: true)
        
        errorTexts = [Int: String]()

        sectionToTextField = [0: self.usernameTextField,
                              1: self.passwordTextField,
                              2: self.confirmPasswordTextField,
                              3: self.emailTextField,
                              4: self.confirmEmailTextField]

        self.updateFooter()

    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()

    }

    // override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //
    //     print("IN TABLE VIEW")
    //
    //     // maybe try getting the footer view here, modifying it like i do it the ealier method, then returning that
    //     /*if let containerView = self.tableView.footerView(forSection: section) {
    //
    //         print("IN TABLE VIEW IN THE IF")
    //         containerView.textLabel!.textColor = UIColor.red
    //         containerView.textLabel!.text = "hello"
    //         containerView.textLabel!.font = UIFont(name: containerView.textLabel!.font.fontName, size: 12)
    //         containerView.sizeToFit()
    //
    //         return containerView
    //
    //     }
    //
    //     else {
    //
    //         print("IN TABLE VIEW IN THE ELSE")
    //
    //         /*let newView = UIView(frame: CGRect(x: 8, y: 0, width: 100, height: 40))
    //         newView.textLabel!.textColor = UIColor.red
    //         newView.textLabel!.text = "other hello"
    //         newView.textLabel!.font = UIFont(name: newView.textLabel!.font.fontName, size: 12)*/
    //         let view = UIView(frame: CGRect(x: 8, y: 0, width: 100, height: 40))
    //         let label = UILabel(frame: view.frame)
    //         label.text = "bla bla bla"
    //         label.sizeToFit()
    //         view.addSubview(label)
    //         view.frame = CGRect(x: 8, y: 0, width: 100, height: 20)
    //
    //         return view
    //
    //     }*/
    //
    //     let view = UIView(frame: CGRect(x: 8, y: 0, width: 0, height: 0))
    //     let label = UILabel(frame: view.frame)
    //
    //     label.textColor = UIColor.red
    //     label.text = errorTexts?[section]
    //     label.font = UIFont(name: label.font.fontName, size: 12)
    //
    //     label.sizeToFit()
    //     view.addSubview(label)
    //     view.sizeToFit()
    //
    //     return view
    //
    // }


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
