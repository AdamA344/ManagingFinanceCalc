//
//  SavingsViewController.swift
//  CW1
//
//  Created by Adam Ayub on 19/02/2020.
//  Copyright © 2020 Adam Ayub. All rights reserved.
//

import UIKit

class SavingsViewController: UIViewController, UITextFieldDelegate {
    
    //connecting components to the view controller
    @IBOutlet weak var initialAmountTextField: UITextField!
    @IBOutlet weak var interestTextField: UITextField!
    @IBOutlet weak var PMTTextField: UITextField!
    @IBOutlet weak var futureAmountTextField: UITextField!
    @IBOutlet weak var numberOfYearsTextField: UITextField!
    @IBOutlet weak var initialAmountLabel: UILabel!
    @IBOutlet weak var futureAmountLabel: UILabel!
    @IBOutlet weak var PMTLabel: UILabel!
    @IBOutlet weak var numberOfYearsLabel: UILabel!
    
     //calling user defaults class
    let defaults = UserDefaults.standard
    
    var KeyboardShown = false
    var KeyboardHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //calling user defaults class
        self.initialAmountTextField.delegate = self
        self.interestTextField.delegate = self
        self.PMTTextField.delegate = self
        self.futureAmountTextField.delegate = self
        self.numberOfYearsTextField.delegate = self
        
        //creating a selector type that is a pointer to a function. can pass functions names to a method more easily.
        
        let saveSelector = #selector(self.saveTextFields)
        let notificationCentre = NotificationCenter.default
        notificationCentre.addObserver(self, selector: saveSelector, name: UIApplication.willResignActiveNotification, object: nil)
        
        //restore Values
        let sIA = defaults.string(forKey: "SInitialAmount")
        let sI = defaults.string(forKey: "SInterest")
        let sPMT = defaults.string(forKey: "SPMT")
        let sFA = defaults.string(forKey: "SFutureAmount")
        let sNOY = defaults.string(forKey: "SNumberOfYears")
        let sIAL = defaults.string(forKey: "SInitialAmountLabel")
        let sFAL = defaults.string(forKey: "SFutureAmountLabel")
        let sPMTL = defaults.string(forKey: "SPMTLabel")
        let sNOYL = defaults.string(forKey: "SNumberOfYearsLabel")
        
        //set the texts to the restored values that were previously saved
        self.initialAmountTextField.text = sIA
        self.interestTextField.text = sI
        self.PMTTextField.text = sPMT
        self.futureAmountTextField.text = sFA
        self.numberOfYearsTextField.text = sNOY
        self.initialAmountLabel.text = sIAL
        self.futureAmountLabel.text = sFAL
        self.PMTLabel.text = sPMTL
        self.numberOfYearsLabel.text = sNOYL
    }
     //assigns a key to each textfield entry when data is entered and then saves it
    @objc func saveTextFields(){
        defaults.set(self.initialAmountTextField.text, forKey: "SInitialAmount")
        defaults.set(self.interestTextField.text, forKey: "SInterest")
        defaults.set(self.PMTTextField.text, forKey: "SPMT")
        defaults.set(self.futureAmountTextField.text, forKey: "SFutureAmount")
        defaults.set(self.numberOfYearsTextField.text, forKey: "SNumberOfYears")
        defaults.set(self.initialAmountLabel.text, forKey: "SInitialAmountLabel")
        defaults.set(self.futureAmountLabel.text, forKey: "SFutureAmountLabel")
        defaults.set(self.PMTLabel.text, forKey: "SPMTLabel")
        defaults.set(self.numberOfYearsLabel.text, forKey: "SNumberOfYearsLabel")
    }
       //dismisses keybord when any non functional part of the view is pressed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
      //clears all fields
    @IBAction func savingsClear(_ sender: Any) {
        initialAmountTextField.text = ""
        interestTextField.text = ""
        PMTTextField.text = ""
        futureAmountTextField.text = ""
        numberOfYearsTextField.text = ""
        initialAmountLabel.text = "£0.00"
        futureAmountLabel.text = "£0.00"
        PMTLabel.text = "£0.00"
        numberOfYearsLabel.text = "-"
    }
    //calculate button
    @IBAction func savingsButton(_ sender: Any) {
        calculateSavings()
    }
     //calls on initialiser of the calculations class
    var savingsCalculation = SavingsCalculation(initialAmount: 0.0, futureAmount: 0.0, interest: 0.0, PMT: 0.0, numberOfYears: 0.0)
    
    // asings values enteres to the the initialiser values so they may be calculated
    func calculateSavings(){
        savingsCalculation.initialAmount = (initialAmountTextField.text! as NSString).doubleValue
        savingsCalculation.interest = (interestTextField.text! as NSString).doubleValue / 100
        savingsCalculation.PMT = (PMTTextField.text! as NSString).doubleValue
        savingsCalculation.futureAmount = (futureAmountTextField.text! as NSString).doubleValue
        savingsCalculation.numberOfYears = (numberOfYearsTextField.text! as NSString).doubleValue 
        
            // validation to ensure all textfields are entered
        var completed = 0
        let filledTextFields = 5
        if initialAmountTextField.text!.count > 0{
            completed += 1
        }
        if interestTextField.text!.count > 0{
            completed += 1
        }
        if numberOfYearsTextField.text!.count > 0{
            completed += 1
        }
        if futureAmountTextField.text!.count > 0{
            completed += 1
        }
        if PMTTextField.text!.count > 0{
            completed += 1
        }
        if savingsCalculation.interest == 0.0 {
            validationCheck()
        }

        if (filledTextFields - completed) == 1 {
            UpdateUI()
        }
        else {
            validationCheck()
        }

    }
    //setting the  labels with the correct values when they button is selecte
    func UpdateUI(){

        if savingsCalculation.futureAmount > 0 && savingsCalculation.numberOfYears > 0 && savingsCalculation.interest > 0 && savingsCalculation.initialAmount >= 0 && savingsCalculation.PMT == 0 {

            savingsCalculation.calculatePMT()
            PMTLabel.text = String (format: "£%.2f", savingsCalculation.PMT)
            PMTTextField.text = String (format: "%.2f", savingsCalculation.PMT)
            numberOfYearsLabel.text = "-"
            initialAmountLabel.text = "£0.00"
            futureAmountLabel.text = "£0.00"
            
        } else if savingsCalculation.initialAmount == 0 && savingsCalculation.numberOfYears == 0.0 {
            
            savingsCalculation.calculateNumberOfYears()
            numberOfYearsLabel.text = String (format: "%.1f", savingsCalculation.numberOfYears)
            numberOfYearsTextField.text = String (format: "%.1f", savingsCalculation.numberOfYears)
            PMTLabel.text = "£0.00"
            initialAmountLabel.text = "£0.00"
            futureAmountLabel.text = "£0.00"

        }else if savingsCalculation.futureAmount > 0 && savingsCalculation.numberOfYears > 0 && savingsCalculation.PMT > 0  && savingsCalculation.interest > 0 && savingsCalculation.initialAmount == 0.0{
        
            savingsCalculation.calculateInitialAmount()
            initialAmountLabel.text = String (format: "£%.2f", savingsCalculation.initialAmount)
            initialAmountTextField.text = String (format: "%.2f", savingsCalculation.initialAmount)
            PMTLabel.text = "£0.00"
            numberOfYearsLabel.text = "-"
            futureAmountLabel.text = "£0.00"

        } else if savingsCalculation.initialAmount >= 0 && savingsCalculation.interest > 0 && savingsCalculation.numberOfYears > 0 && savingsCalculation.PMT > 0 && savingsCalculation.futureAmount == 0.0 {
            
            savingsCalculation.calculateFutureAmount()
            futureAmountLabel.text = String (format: "£%.2f", savingsCalculation.futureAmount)
            futureAmountTextField.text = String (format: "%.2f", savingsCalculation.futureAmount)
            PMTLabel.text = "£0.00"
            numberOfYearsLabel.text = "-"
            initialAmountLabel.text = "£0.00"
        }
        //lets text be edited after they have changed
        initialAmountTextField.allowsEditingTextAttributes = true
        futureAmountTextField.allowsEditingTextAttributes = true
        PMTTextField.allowsEditingTextAttributes = true
        numberOfYearsTextField.allowsEditingTextAttributes = true
        interestTextField.allowsEditingTextAttributes = true
        
    }
        //pop up on the phone to inform user of any errors when completeing calculations
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let Text = (textField.text ?? "") as NSString
        let NewText = Text.replacingCharacters(in: range, with: string)
        if let Regex = try? NSRegularExpression(pattern: "^[0-9]*((.)[0-9]{0,2})?$", options: .caseInsensitive) {
            textField.allowsEditingTextAttributes = true
            return Regex.numberOfMatches(in: NewText, options: .reportProgress, range: NSRange(location: 0, length: (NewText as NSString).length)) > 0
        }
        return false
    }
    
    
 //prevents the user from inputting more that one decimal place and setting the patters to only all values top be up to 2 decimal places.
    func validationCheck() {
        let popup = UIAlertController(title: "Oops!", message: "Makes sure only 4 fields (Including 'Interest') are filled in!", preferredStyle: UIAlertController.Style.alert)
        popup.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
        self.present(popup, animated: true, completion: nil)
        return
    }
    
}
