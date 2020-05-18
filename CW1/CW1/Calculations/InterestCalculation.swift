//
//  InterestCalculation.swift
//  CW1
//
//  Created by Adam Ayub on 28/02/2020.
//  Copyright © 2020 Adam Ayub. All rights reserved.
//

import Foundation

class InterestCalculation {
    
    var initialAmount: Double = 0.0  //principle amount
    var numberOfYears: Double = 0.0  //length in years
    var futureAmount: Double = 0.0 //amount after interest
    var interestRate: Double = 0.0 //original interet rate
    var compoundsPerYear: Double = 12.0 // 12 payments a year
  
    //initialise variables
    init(initialAmount: Double, futureAmount: Double, numberOfYears: Double, interestRate: Double) {
        self.initialAmount = initialAmount
        self.futureAmount = futureAmount
        self.numberOfYears = numberOfYears
        self.interestRate = interestRate
    }
    // interest calculation
    func calculateInterstRate() {
        interestRate = (compoundsPerYear * (pow((futureAmount/initialAmount), (1/(compoundsPerYear * numberOfYears))) - 1)) * 100
    }
    //calculating initial Amount
    func calculateInitialAmount(){
        initialAmount = futureAmount/(pow((1 + (interestRate/compoundsPerYear)), (compoundsPerYear * numberOfYears)))
    }
    //calculating future Amount
    func caclulateFinalAmount() {
        futureAmount = initialAmount * (pow((1 + (interestRate/compoundsPerYear)), (compoundsPerYear * numberOfYears)))
    }
    // calculate number of years
    func calculateNumberOfYears(){
        numberOfYears = log(futureAmount/initialAmount) / (compoundsPerYear * log((1 + (interestRate/compoundsPerYear))))
    }
    
    
}
