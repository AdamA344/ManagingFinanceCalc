//
//  FirstViewController.swift
//  CW1
//
//  Created by Adam Ayub on 19/02/2020.
//  Copyright © 2020 Adam Ayub. All rights reserved.
//

import UIKit

class MortgageViewController: UIViewController, UITextFieldDelegate {
    
    //connecting components to the view controller
    @IBOutlet weak var numberOfYears: UITextField!
    @IBOutlet weak var Interest: UITextField!
    @IBOutlet weak var LoanAmount: UITextField!
    @IBOutlet weak var PMT: UITextField!
    @IBOutlet weak var initialAmount: UILabel!
    @IBOutlet weak var paymentPerMonth: UILabel!
    @IBOutlet weak var totalPayment: UILabel!
    @IBOutlet weak var numberOfYearsLabel: UILabel!
    
    //calling user defaults class
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set delegates to the textfields
        self.LoanAmount.delegate = self
        self.Interest.delegate = self
        self.numberOfYears.delegate = self
        self.PMT.delegate = self
        
        //creating a selector type that is a pointer to a function. can pass functions names to a method more easily.
        
        let saveSelector = #selector(self.saveTextFields)
        let notificationCentre = NotificationCenter.default
        notificationCentre.addObserver(self, selector: saveSelector, name: UIApplication.willResignActiveNotification, object: nil)
        
        //restore Values when app is opened
        let mNOY = defaults.string(forKey: "MNumOfYears")
        let mI = defaults.string(forKey: "Minterest")
        let mLA = defaults.string(forKey: "MLoanAmount")
        let mPMT = defaults.string(forKey: "MPMT")
        let mLAL = defaults.string(forKey: "MLoanAmountLabel")
        let mPMTL = defaults.string(forKey: "MPMTLabel")
        let mTPL = defaults.string(forKey: "MTotalPaymentLabel")
        let mNOYL = defaults.string(forKey: "MNumOfYearsLabel")
        
        //set the texts to the restored values that were previously saved 
        self.numberOfYears.text = mNOY
        self.Interest.text = mI
        self.LoanAmount.text = mLA
        self.PMT.text = mPMT
        self.initialAmount.text = mLAL
        self.paymentPerMonth.text = mPMTL
        self.totalPayment.text = mTPL
        self.numberOfYearsLabel.text = mNOYL
    }
    
    //assigns a key to each textfield entry when data is entered and then saves it
    @objc func saveTextFields(){
        defaults.set(self.numberOfYears.text, forKey: "MNumOfYears")
        defaults.set(self.Interest.text, forKey: "Minterest")
        defaults.set(self.LoanAmount.text, forKey: "MLoanAmount")
        defaults.set(self.PMT.text, forKey: "MPMT")
        defaults.set(self.initialAmount.text, forKey: "MLoanAmountLabel")
        defaults.set(self.paymentPerMonth.text, forKey: "MPMTLabel")
        defaults.set(self.totalPayment.text, forKey: "MTotalPaymentLabel")
        defaults.set(self.numberOfYearsLabel.text, forKey: "MNumOfYearsLabel")
    }
    
    //clears all fields
    @IBAction func mortgageClear(_ sender: Any) {
        
        numberOfYears.text = ""
        Interest.text = ""
        LoanAmount.text = ""
        PMT.text = ""
        initialAmount.text = "£0.00"
        paymentPerMonth.text = "£0.00"
        totalPayment.text = "£0.00"
        numberOfYearsLabel.text = "-"
        
    }
    
    //calculate button
    @IBAction func mortgageButton(_ sender: Any) {
        calculatePayment()
    }
    //dismisses keybord when any non functional part of the view is pressed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    //calls on initialiser of the calculations class
    var mortgageCalculator = MortgageCalculations(loanAmount: 0.0, interest: 0.0, numberOfYears: 0.0, payment: 0.0)

    func calculatePayment(){
    
        // asings values enteres to the the initialiser values so they may be calculated
        mortgageCalculator.loanAmount = (LoanAmount.text! as NSString).doubleValue
        mortgageCalculator.interest = (Interest.text! as NSString).doubleValue / 100
        mortgageCalculator.numberOfYears = (numberOfYears.text! as NSString).doubleValue 
        mortgageCalculator.payment = (PMT.text! as NSString).doubleValue
        
        
        // validation to ensure all textfields are entered
        var completed = 0
        let filledTextFields = 4
        
        if LoanAmount.text!.count > 0{
            completed += 1
        }
        
        if Interest.text!.count > 0{
            completed += 1
        }
        
        if numberOfYears.text!.count > 0{
            completed += 1
        }
        
        if PMT.text!.count > 0{
            completed += 1
        }
        if mortgageCalculator.interest == 0.0{
            validationCheck()
        }
        
        if (filledTextFields - completed) == 1 {
        updateUI()
        }
        else {
            validationCheck()
        }
    }
    
    //setting the  labels with the correct values when they button is selected
    func updateUI(){
        if mortgageCalculator.payment == 0 {
            
            initialAmount.text = "£0.00"
            numberOfYearsLabel.text = "-"
            
            mortgageCalculator.calculatePaymentsPerMonth()
            paymentPerMonth.text = String(format: "£%0.2f", mortgageCalculator.payment)
            PMT.text = String(format: "%0.2f", mortgageCalculator.payment)
            
        } else if mortgageCalculator.loanAmount == 0.0 {
            
            paymentPerMonth.text = "£0.00"
            numberOfYearsLabel.text = "-"
            
            mortgageCalculator.calculateLoanAmount()
            initialAmount.text = String(format: "£%0.2f", mortgageCalculator.loanAmount)
            LoanAmount.text = String(format: "%0.2f", mortgageCalculator.loanAmount)
            
        } else if mortgageCalculator.numberOfYears == 0.0 {
            
            initialAmount.text = "£0.00"
            paymentPerMonth.text = "£0.00"
            
            mortgageCalculator.calculateNumberOfYears()
            numberOfYearsLabel.text = String(format: "%0.1f", mortgageCalculator.numberOfYears)
            numberOfYears.text = String(format: "%0.1f", mortgageCalculator.numberOfYears)
            
        }
        
        totalPayment.text = String (format: "£%0.2f", mortgageCalculator.totalMortgage)
        
        //lets text be edited after they have changed
        PMT.allowsEditingTextAttributes = true
        LoanAmount.allowsEditingTextAttributes = true
        numberOfYears.allowsEditingTextAttributes = true
    }
//prevents the user from inputting more that one decimal place and setting the patters to only all values top be up to 2 decimal places.
    func textField(_ loanAmount: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let lAText = (loanAmount.text ?? "") as NSString
        let lANewText = lAText.replacingCharacters(in: range, with: string)
        if let lARegex = try? NSRegularExpression(pattern: "^[0-9]*((.)[0-9]{0,2})?$", options: .caseInsensitive) {
            loanAmount.allowsEditingTextAttributes = true
            return lARegex.numberOfMatches(in: lANewText, options: .reportProgress, range: NSRange(location: 0, length: (lANewText as NSString).length)) > 0
        }
        return false
    }

    //pop up on the phone to inform user of any errors when completeing calculations
    func validationCheck() {
        let popup = UIAlertController(title: "Oops!", message: "Makes sure at least 3 fields(including 'Interest') are filled in!", preferredStyle: UIAlertController.Style.alert)
        popup.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
        self.present(popup, animated: true, completion: nil)
        return
    }

}
