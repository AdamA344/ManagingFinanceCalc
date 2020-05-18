//
//  LoansViewController.swift
//  CW1
//
//  Created by Adam Ayub on 27/02/2020.
//  Copyright © 2020 Adam Ayub. All rights reserved.
//

import UIKit

class LoansViewController: UIViewController, UITextFieldDelegate {

     //connecting components to the view controller
    @IBOutlet weak var LoanAmount: UITextField!
    @IBOutlet weak var monthlyRepayment: UITextField!
    @IBOutlet weak var LoanInterest: UITextField!
    @IBOutlet weak var numberOfRepayments: UITextField!
    @IBOutlet weak var InstallmentCount: UILabel!
    @IBOutlet weak var BorrowAmount: UILabel!
    @IBOutlet weak var PMTLabel: UILabel!
    
    //calling user defaults class
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //calling user defaults class
        self.LoanAmount.delegate = self
        self.monthlyRepayment.delegate = self
        self.LoanInterest.delegate = self
        self.numberOfRepayments.delegate = self
        
        
        //creating a selector type that is a pointer to a function. can pass functions names to a method more easily.
        
        let saveSelector = #selector(self.saveTextFields)
        let notificationCentre = NotificationCenter.default
        notificationCentre.addObserver(self, selector: saveSelector, name: UIApplication.willResignActiveNotification, object: nil)

        //restore Values
        let lA = defaults.string(forKey: "LoanAmount")
        let mLR = defaults.string(forKey: "monthlyLoanRepayment")
        let lI = defaults.string(forKey: "LoanInterest")
        let nLR = defaults.string(forKey: "numberOfLoanRepayments")
        let iC = defaults.string(forKey: "InstallmentCount")
        let bLA = defaults.string(forKey: "BorrowLoanAmount")
        let PMTL = defaults.string(forKey: "PMTLabel")
        
        //set the texts to the restored values that were previously saved
        self.LoanAmount.text = lA
        self.monthlyRepayment.text = mLR
        self.LoanInterest.text = lI
        self.numberOfRepayments.text = nLR
        self.InstallmentCount.text = iC
        self.BorrowAmount.text = bLA
        self.BorrowAmount.text = PMTL
    }
    
 //assigns a key to each textfield entry when data is entered and then saves it
    @objc func saveTextFields(){
        defaults.set(self.LoanAmount.text, forKey: "LoanAmount")
        defaults.set(self.monthlyRepayment.text, forKey: "monthlyLoanRepayment")
        defaults.set(self.LoanInterest.text, forKey: "LoanInterest")
        defaults.set(self.numberOfRepayments.text, forKey: "numberOfLoanRepayments")
        defaults.set(self.InstallmentCount.text, forKey: "InstallmentCount")
        defaults.set(self.BorrowAmount.text, forKey: "BorrowLoanAmount")
        defaults.set(self.PMTLabel.text, forKey: "PMTLabel")
    }
    
    //clears all fields
    @IBAction func loansClearButton(_ sender: Any) {
        LoanAmount.text = ""
        monthlyRepayment.text = ""
        LoanInterest.text = ""
        numberOfRepayments.text = ""
        InstallmentCount.text = "-"
        BorrowAmount.text = "£0.00"
        PMTLabel.text = "£0.00"
        
    }
    //calculate button
    @IBAction func loanButton(_ sender: Any) {
        calculateLoans()
    }
    //dismisses keybord when any non functional part of the view is pressed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //calls on initialiser of the calculations class
    var loanCalculation = LoanCalculation(initalLoan: 0.0, interest: 0.0, PMT: 0.0, timeInYears: 0.0)
    
      // asings values enteres to the the initialiser values so they may be calculated
    func calculateLoans(){
        loanCalculation.initialLoan = (LoanAmount.text! as NSString).doubleValue
        loanCalculation.interest = (LoanInterest.text! as NSString).doubleValue / 100
        loanCalculation.PMT = (monthlyRepayment.text! as NSString).doubleValue
        loanCalculation.timeInYears = (numberOfRepayments.text! as NSString).doubleValue
        
         // validation to ensure all textfields are entered
        var completed = 0
        let filledTextFields = 4
        
        if LoanAmount.text!.count > 0{
            completed += 1
        }
        if LoanInterest.text!.count > 0{
            completed += 1
        }
        if monthlyRepayment.text!.count > 0{
            completed += 1
        }
        if numberOfRepayments.text!.count > 0{
            completed += 1
        }
        if loanCalculation.interest == 0.0{
            validationCheck()
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
        if loanCalculation.timeInYears == 0.0 {
            
            BorrowAmount.text = "£0.00"
            PMTLabel.text = "£0.00"
            loanCalculation.loanPaymentLength()
            InstallmentCount.text = String( format: "%.0f", loanCalculation.timeInMonths.rounded(.up))
            numberOfRepayments.text = String( format: "%.0f", loanCalculation.timeInMonths.rounded(.up) / 12)
            
            
        } else if loanCalculation.PMT == 0.0 {
            
            BorrowAmount.text = "£0.00"
            InstallmentCount.text = "-"
            loanCalculation.calculatePMT()
            PMTLabel.text = String( format: "£%.2f", loanCalculation.PMT)
            monthlyRepayment.text = String( format: "%.2f", loanCalculation.PMT)
            
        } else if loanCalculation.initialLoan == 0.0 {
            
            InstallmentCount.text = "-"
            PMTLabel.text = "£0.00"
            loanCalculation.calculateInitialLoan()
            BorrowAmount.text = String( format: "£%.2f", loanCalculation.initialLoan)
            LoanAmount.text = String( format: "%.2f", loanCalculation.initialLoan)
        }
        
        //lets text be edited after they have changed
        LoanAmount.allowsEditingTextAttributes = true
        monthlyRepayment.allowsEditingTextAttributes = true
        LoanInterest.allowsEditingTextAttributes = true
        numberOfRepayments.allowsEditingTextAttributes = true
    }
    
     //pop up on the phone to inform user of any errors when completeing calculations
    func validationCheck() {
        let popup = UIAlertController(title: "Oops!", message: "Makes sure only 3 fields(including 'Interest') are filled in!", preferredStyle: UIAlertController.Style.alert)
        popup.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: nil))
        self.present(popup, animated: true, completion: nil)
        return
    }
    //prevents the user from inputting more that one decimal place and setting the patters to only all values top be up to 2 decimal places.
    func textField(_ LoanAmount: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let Text = (LoanAmount.text ?? "") as NSString
        let NewText = Text.replacingCharacters(in: range, with: string)
        if let Regex = try? NSRegularExpression(pattern: "^[0-9]*((.)[0-9]{0,2})?$", options: .caseInsensitive) {
            LoanAmount.allowsEditingTextAttributes = true
            return Regex.numberOfMatches(in: NewText, options: .reportProgress, range: NSRange(location: 0, length: (NewText as NSString).length)) > 0
        }
        return false
    }
}
