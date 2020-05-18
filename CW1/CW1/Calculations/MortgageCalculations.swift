//
//  Calculations.swift
//  CW1
//
//  Created by Adam Ayub on 26/02/2020.
//  Copyright © 2020 Adam Ayub. All rights reserved.
//

import Foundation

class MortgageCalculations{

    var loanAmount: Double = 0.0 //principle amount
    var interest: Double = 0.0 //original intrest rate
    var payment: Double = 0.0 //monthly payment amount (PMT)
    let compoundInterestperYear: Double = 12.0 //12 payments per year
    var numberOfYears: Double = 0.0 //mortgage length in years
    var totalMortgage: Double = 0.0 // total morgage payment after x amount of years
    
    //initialise values
    init(loanAmount: Double, interest: Double, numberOfYears: Double, payment: Double){
        self.loanAmount = loanAmount
        self.interest = interest
        self.numberOfYears = numberOfYears
        self.payment = payment
    }
    
    //calculating PMT
    func calculatePaymentsPerMonth() {
        payment = ((loanAmount * (interest/12)) * (pow(1 + (interest/12),(12 * numberOfYears)))) / ((pow((1 + (interest/12)), Double(12 * numberOfYears))) - 1)
        
        totalMortgage = (payment * 12) * numberOfYears
        
    }
    //calculating initial Amount
    func calculateLoanAmount(){
        loanAmount = (payment/(interest/12)) * (1 - (1/(pow((1+(interest/12)), (12 * numberOfYears)))))
        
        totalMortgage = (payment * 12) * numberOfYears
    }
    // calculate number of years 
    func calculateNumberOfYears(){
        numberOfYears = (log((-12 * payment) / ((loanAmount * interest) - (12 * payment)))) / (12 * log((interest + 12) / 12))
        
        totalMortgage = (payment * 12) * numberOfYears
    }
}
