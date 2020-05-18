//
//  CompundInterestViewController.swift
//  CW1
//
//  Created by Adam Ayub on 28/02/2020.
//  Copyright © 2020 Adam Ayub. All rights reserved.



import UIKit

class CompundInterestViewController: UIViewController, UITextFieldDelegate {
    
       //connecting components to the view controller
    @IBOutlet weak var initialAmountTextField: UITextField!
    @IBOutlet weak var futureAmountTextField: UITextField!
    @IBOutlet weak var interestTextField: UITextField!
    @IBOutlet weak var numberOfYearsTextField: UITextField!
    @IBOutlet weak var numberOfYearsLabel: UILabel!
    @IBOutlet weak var interestLabel: UILabel!
    @IBOutlet weak var initialAmountLabel: UILabel!
    @IBOutlet weak var futureAmountLabel: UILabel!
    
    //calling user defaults class
      let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //calling user defaults class
        self.initialAmountTextField.delegate = self
        self.interestTextField.delegate = self
        self.futureAmountTextField.delegate = self
        self.numberOfYearsTextField.delegate = self

        
        //creating a selector type that is a pointer to a function. can pass functions names to a method more easily.
        let saveSelector = #selector(self.saveTextFields)
        let notificationCentre = NotificationCenter.default
        notificationCentre.addObserver(self, selector: saveSelector, name: UIApplication.willResignActiveNotification, object: nil)
        
        //restore Values
        let cIA = defaults.string(forKey: "CIInitialAmount")
        let cFA = defaults.string(forKey: "CIFutureAmount")
        let cI = defaults.string(forKey: "CIInterest")
        let cNoY = defaults.string(forKey: "CINumberOfYears")
        let cNoYL = defaults.string(forKey: "CINoY")
        let cIL = defaults.string(forKey: "CII")
        let cIAL = defaults.string(forKey: "CIIA")
        let cFAL = defaults.string(forKey: "CIFA")
        
        //set the texts to the restored values that were previously saved
        self.initialAmountTextField.text = cIA
        self.futureAmountTextField.text = cFA
        self.interestTextField.text = cI
        self.numberOfYearsTextField.text = cNoY
        self.numberOfYearsLabel.text = cNoYL
        self.interestLabel.text = cIL
        self.initialAmountLabel.text = cIAL
        self.futureAmountLabel.text = cFAL
        
    }
     //assigns a key to each textfield entry when data is entered and then saves it
    @objc func saveTextFields(){
        defaults.set(self.initialAmountTextField.text, forKey: "CIInitialAmount")
        defaults.set(self.futureAmountTextField.text, forKey: "CIFutureAmount")
        defaults.set(self.interestTextField.text, forKey: "CIInterest")
        defaults.set(self.numberOfYearsTextField.text, forKey: "CINumberOfYears")
        defaults.set(self.numberOfYearsLabel.text, forKey: "CINoY")
        defaults.set(self.interestLabel.text, forKey: "CII")
        defaults.set(self.initialAmountLabel.text, forKey: "CIIA")
        defaults.set(self.futureAmountLabel.text, forKey: "CIFA")
    }
    
    //clears all fields
    @IBAction func simpleSavingsClear(_ sender: Any) {
        initialAmountTextField.text = ""
        futureAmountTextField.text = ""
        interestTextField.text = ""
        numberOfYearsTextField.text = ""
        numberOfYearsLabel.text = "-"
        interestLabel.text = "%"
        initialAmountLabel.text = "0.00"
        futureAmountLabel.text = "£0.00"
    }
    
    //calculate button
    @IBAction func simpleSavingsButton(_ sender: Any) {
        calculatePayment()
    }
    
    //dismisses keybord when any non functional part of the view is pressed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //calls on initialiser of the calculations class
    var interestCalculation = InterestCalculation(initialAmount: 0.0, futureAmount: 0.0, numberOfYears: 0.0, interestRate: 0.0)
    
      // asings values enteres to the the initialiser values so they may be calculated
    func calculatePayment(){
        interestCalculation.initialAmount = (initialAmountTextField.text! as NSString).doubleValue
        interestCalculation.futureAmount = (futureAmountTextField.text! as NSString).doubleValue
        interestCalculation.numberOfYears = (numberOfYearsTextField.text! as NSString).doubleValue
        interestCalculation.interestRate = (interestTextField.text! as NSString).doubleValue / 100
        
         // validation to ensure all textfields are entered
        var completed = 0
        let filledTextFields = 4
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
        if (filledTextFields - completed) == 1 {
            UpdateUI()
        }
        else {
            validationCheck()
        }
    }
    
     //setting the  labels with the correct values when they button is selected
    func UpdateUI(){
        
        if interestCalculation.interestRate == 0.0 {
            
            initialAmountLabel.text = "£0.00"
            futureAmountLabel.text = "£0.00"
            numberOfYearsLabel.text = "-"
            interestCalculation.calculateInterstRate()
            interestLabel.text = String( format: "%.2f%%", interestCalculation.interestRate)
            interestTextField.text = String( format: "%.2f", interestCalculation.interestRate)
            
        } else if interestCalculation.initialAmount == 0.0 {
            
            interestLabel.text = "%"
            futureAmountLabel.text = "£0.00"
            numberOfYearsLabel.text = "-"
            interestCalculation.calculateInitialAmount()
            initialAmountLabel.text = String( format: "£%.2f", interestCalculation.initialAmount)
            initialAmountTextField.text = String( format: "%.2f", interestCalculation.initialAmount)
            
        } else if interestCalculation.futureAmount == 0.0 {
            
            interestLabel.text = "%"
            initialAmountLabel.text = "£0.00"
            numberOfYearsLabel.text = "-"
            interestCalculation.caclulateFinalAmount()
            futureAmountLabel.text = String( format: "£%.2f", interestCalculation.futureAmount)
            futureAmountTextField.text = String( format: "%.2f", interestCalculation.futureAmount)
            
        } else if  interestCalculation.numberOfYears == 0.0 {
            
            interestLabel.text = "%"
            initialAmountLabel.text = "£0.00"
            futureAmountLabel.text = "£0.00"
            interestCalculation.calculateNumberOfYears()
            numberOfYearsLabel.text = String( format: "%.0f", interestCalculation.numberOfYears)
            numberOfYearsTextField.text = String( format: "%.0f", interestCalculation.numberOfYears)
        }
        
        //lets text be edited after they have changed
        initialAmountTextField.allowsEditingTextAttributes = true
        interestTextField.allowsEditingTextAttributes = true
        futureAmountTextField.allowsEditingTextAttributes = true
        numberOfYearsTextField.allowsEditingTextAttributes = true
    }
    
    //prevents the user from inputting more that one decimal place and setting the patters to only all values top be up to 2 decimal places.
    func textField(_ initialAmountTextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let Text = (initialAmountTextField.text ?? "") as NSString
        let NewText = Text.replacingCharacters(in: range, with: string)
        if let Regex = try? NSRegularExpression(pattern: "^[0-9]*((.)[0-9]{0,2})?$", options: .caseInsensitive) {
            initialAmountTextField.allowsEditingTextAttributes = true
            return Regex.numberOfMatches(in: NewText, options: .reportProgress, range: NSRange(location: 0, length: (NewText as NSString).length)) > 0
        }
        return false
    }
    
      //pop up on the phone to inform user of any errors when completeing calculations
    func validationCheck() {
        let popup = UIAlertController(title: "Oops!", message: "Makes sure 3 fields are filled in!", preferredStyle: UIAlertController.Style.alert)
        popup.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
        self.present(popup, animated: true, completion: nil)
        return
    }
}

