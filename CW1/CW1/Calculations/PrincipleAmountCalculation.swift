//
//  PrincipleAmountCalculation.swift
//  CW1
//
//  Created by Adam Ayub on 28/02/2020.
//  Copyright © 2020 Adam Ayub. All rights reserved.
//

import Foundation

class PrincipleAmountCalculation {
    
    var principleAmount: Double = 0.0  //principle amount
    var numberOfYears: Double = 0.0  //length in years
    var futureAmount: Double = 0.0 //amount after interest
    var interestRate: Double = 0.0 //original interet rate
    var compoundsPerYear: Double = 12.0 // 12 payments a year
    
    init(futureAmount: Double, interestRate: Double, numberOfYears: Double){
        self.futureAmount = futureAmount
        self.interestRate = interestRate
        self.numberOfYears = numberOfYears
    }
    
    func calculatePrincipleAmount(){
        principleAmount = futureAmount / pow(1 + (interestRate/compoundsPerYear), (compoundsPerYear * numberOfYears))
    }
    
}
