//
//  LoanCalculation.swift
//  CW1
//
//  Created by Adam Ayub on 27/02/2020.
//  Copyright © 2020 Adam Ayub. All rights reserved.
//

import Foundation

class LoanCalculation{
    
    var timeInYears: Double = 0.0 //Original calculation is given in Years
    var initialLoan: Double = 0.0 //Original Loan
    var interest: Double = 0.0 //intrest rate
    var PMT: Double = 0.0 //monthly payment amount (PMT)
    var timeInMonths: Double = 0.0 //final result as the time must be in months
    var totalRepayment: Double = 0.0 //total load to be repaid
    
    //initialise values
    init(initalLoan: Double, interest: Double, PMT: Double, timeInYears: Double){
        self.initialLoan = initalLoan
        self.interest = interest
        self.PMT = PMT
        self.timeInYears = timeInYears
    }
    
    //length of each loan repayment
    func loanPaymentLength(){
       timeInMonths = ((log((-12.0 * PMT) / ((initialLoan * interest) - (12.0 * PMT)))) / (12 * log((interest + 12)/12))) * 12
    }
    //amount of initial value
    func calculateInitialLoan(){
        timeInMonths = timeInYears * 12
        initialLoan = (PMT/(interest/12)) * (1 - (1/(pow((1+(interest/12)), timeInMonths))))
    }
    // payment per month amount calculation 
    func calculatePMT(){
        PMT = ((initialLoan * (interest/12)) * (pow(1 + (interest/12),(timeInYears * 12)))) / ((pow((1 + (interest/12)), Double(timeInYears * 12))) - 1)
    }
}
