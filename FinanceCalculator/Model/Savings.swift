//
//  Savings.swift
//  FinanceCalculator
//
//  Created by Jamith Nimantha on 2023-07-29.
//

import Foundation

class Savings {
    var presentValue : Double
    var futureValue : Double
    var interestRate : Double
    var noOfPayments : Double
    var historyStringArray : [String]
    
    init(presentValue: Double, futureValue : Double, interestRate: Double, noOfPayments: Double) {
        self.presentValue = presentValue
        self.futureValue = futureValue
        self.interestRate = interestRate
        self.noOfPayments = noOfPayments
        self.historyStringArray = [String]()
    }
}
