//
//  Savings.swift
//  CW1
//
//  Created by Adam Ayub on 03/03/2020.
//  Copyright © 2020 Adam Ayub. All rights reserved.
//

import Foundation

class SavingsCalculation {
    
    var initialAmount: Double = 0.0 //principle amount
    var futureAmount: Double = 0.0 // future value
    var interest: Double = 0.0 //originial interest rate
    var PMT : Double = 0.0 //payments per month
    var numberOfYears: Double = 0.0 //length in years
 
    //initialise values
    init(initialAmount: Double ,futureAmount: Double, interest: Double, PMT: Double, numberOfYears: Double) {
        self.initialAmount = initialAmount
        self.futureAmount = futureAmount
        self.interest = interest
        self.PMT = PMT
        self.numberOfYears = numberOfYears
    }
    //calculate initial value
    func calculateInitialAmount(){
       initialAmount = (futureAmount - (PMT * ((pow(1 + (interest/12), (12 * numberOfYears)) - 1.0) / (interest/12)))) / (pow((1 + (interest/12)), (12 * numberOfYears)))
    }
    //calculate future value
    func calculateFutureAmount(){
        futureAmount =  (PMT * ((pow(1 + (interest/12), (12 * numberOfYears)) - 1.0) / (interest/12))) + (initialAmount * (pow((1 + (interest/12)), (12 * numberOfYears))))
    }
    // calculate payments per month
    func calculatePMT(){
        PMT = (futureAmount - (initialAmount * (pow((1 + (interest/12)), (12 * numberOfYears))))) / ((pow(1 + (interest/12), (12 * numberOfYears)) - 1.0) / (interest/12))
    }
    //calculate time in years 
    func calculateNumberOfYears(){
         numberOfYears = ((log(((futureAmount * interest) + (12*PMT))/(12 * PMT)))/(12 * log((interest+12)/12)))
    }
    
}
