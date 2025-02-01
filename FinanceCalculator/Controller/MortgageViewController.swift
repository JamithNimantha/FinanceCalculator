//
//  MortgageViewController.swift
//  FinanceCalculator
//
//  Created by Jamith Nimantha on 2023-07-29.
//

import UIKit

class MortgageViewController: UIViewController, UITextFieldDelegate {
    
    // Outlets
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var interestRateTextField: UITextField!
    @IBOutlet weak var noOfPayementsTF: UITextField!
    @IBOutlet weak var paymentTextField: UITextField!
    @IBOutlet weak var keyboardView: KeyboardController!
    
    // Data model
    var mortgage: Mortgage = Mortgage(amount: 0.0, interestRate: 0.0, noOfPayments: 0.0, payment: 0.0)
    
    // Additional initialization of view
    override func viewDidLoad() {
        super.viewDidLoad()
        assignDelegates()
        loadDefaultsData("MortgageHistory")
        loadInputWhenAppOpen()
    }
    
    // Load history data to string array
    func loadDefaultsData(_ historyKey: String) {
        let defaults = UserDefaults.standard
        mortgage.historyStringArray = defaults.object(forKey: historyKey) as? [String] ?? [String]()
    }
    
    // Disable system keyboard popup and call view textfields from controller
    func assignDelegates() {
        amountTextField.delegate = self
        amountTextField.inputView = UIView()
        interestRateTextField.delegate = self
        interestRateTextField.inputView = UIView()
        noOfPayementsTF.delegate = self
        noOfPayementsTF.inputView = UIView()
        paymentTextField.delegate = self
        paymentTextField.inputView = UIView()
    }
    
    // Save typed data in textbox to relevant key
    @IBAction func editAmountSaveDefault(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(amountTextField.text, forKey: "mortgage_amount")
    }
    
    @IBAction func editInterestRateSaveDefault(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(interestRateTextField.text, forKey: "mortgage_interest_rate")
    }
    
    @IBAction func editNoOfPaymentsSaveDefault(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(noOfPayementsTF.text, forKey: "mortgage_noOfPayments")
    }
    
    @IBAction func editPaymentSaveDefault(_ sender: UITextField) {
        let defaultValue = UserDefaults.standard
        defaultValue.set(paymentTextField.text, forKey: "mortgage_payment")
    }
    
    // Load data when the app reopens
    func loadInputWhenAppOpen() {
        let defaultValue = UserDefaults.standard
        let amountDefault = defaultValue.string(forKey: "mortgage_amount")
        let interestRateDefault = defaultValue.string(forKey: "mortgage_interest_rate")
        let noOfPayementsDefault = defaultValue.string(forKey: "mortgage_noOfPayments")
        let paymentDefault = defaultValue.string(forKey: "mortgage_payment")
        
        amountTextField.text = amountDefault
        interestRateTextField.text = interestRateDefault
        noOfPayementsTF.text = noOfPayementsDefault
        paymentTextField.text = paymentDefault
    }
    
    // Keyboard user input will display textbox
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardView.activeTextField = textField
    }
    
    // Clear all textbox data
    @IBAction func onClear(_ sender: UIButton) {
        amountTextField.text = ""
        interestRateTextField.text = ""
        noOfPayementsTF.text = ""
        paymentTextField.text = ""
    }
    
    // Calculate formula when the calculate button is clicked
    @IBAction func onCalculate(_ sender: UIButton) {
        // Check whether all textboxes are empty
        if amountTextField.text!.isEmpty && interestRateTextField.text!.isEmpty &&
            paymentTextField.text!.isEmpty && noOfPayementsTF.text!.isEmpty {
            
            let alertController = UIAlertController(title: "Warning Alert", message: "Please enter value(s) to calculate", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        // Check whether all textboxes are filled
        else if !amountTextField.text!.isEmpty && !interestRateTextField.text!.isEmpty &&
                !paymentTextField.text!.isEmpty && !noOfPayementsTF.text!.isEmpty {
            
            let alertController = UIAlertController(title: "Warning Alert", message: "Need one empty field.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        // Payment calculation
        else if paymentTextField.text!.isEmpty && !amountTextField.text!.isEmpty &&
                !interestRateTextField.text!.isEmpty && !noOfPayementsTF.text!.isEmpty {
            
            let amountValue = Double(amountTextField.text!)!
            let interestRateValue = Double(interestRateTextField.text!)!
            let noOfPaymentsValue = Double(noOfPayementsTF.text!)!
            let interestDivided = interestRateValue / 100
            
            // Payment formula - M = P[i(1+i)n] / (1+i)nt
            let payment = amountValue * ((interestDivided / 12 * pow(1 + interestDivided / 12, noOfPaymentsValue)) / (pow(1 + interestDivided / 12, noOfPaymentsValue) - 1))
            paymentTextField.text = String(format: "%.2f", payment)
        }
        // Amount calculation
        else if amountTextField.text!.isEmpty && !noOfPayementsTF.text!.isEmpty &&
                !interestRateTextField.text!.isEmpty && !paymentTextField.text!.isEmpty {
            
            let noOfPaymentsValue = Double(noOfPayementsTF.text!)!
            let interestRateValue = Double(interestRateTextField.text!)!
            let paymentValue = Double(paymentTextField.text!)!
            let interestDivided = interestRateValue / 100
            
            // Mortgage amount formula - P = (M * (pow((1 + R/t), (n*t)) - 1)) / (R/t * pow((1 + R/t), (n*t)))
            let presentValue = (paymentValue * (pow((1 + interestDivided / noOfPaymentsValue), (noOfPaymentsValue)) - 1)) / (interestDivided / noOfPaymentsValue * pow((1 + interestDivided / noOfPaymentsValue), (noOfPaymentsValue)))
            amountTextField.text = String(format: "%.2f", presentValue)
        }
        // Interest rate calculation
        else if interestRateTextField.text!.isEmpty && !amountTextField.text!.isEmpty &&
                !noOfPayementsTF.text!.isEmpty && !paymentTextField.text!.isEmpty {
            
            let alertController = UIAlertController(title: "Warning", message: "Interest rate calculation is not defined.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        // Number of payments calculation
        else if noOfPayementsTF.text!.isEmpty && !interestRateTextField.text!.isEmpty &&
                !amountTextField.text!.isEmpty && !paymentTextField.text!.isEmpty {
            
            let amountValue = Double(amountTextField.text!)!
            let interestRateValue = Double(interestRateTextField.text!)!
            let paymentValue = Double(paymentTextField.text!)!
            let interestDivided = (interestRateValue / 100) / 12
            
            // Number of payments formula - log((PMT / i) / ((PMT / i) - P)) / log(1 + i)
            let calculatedNumOfMonths = log((paymentValue / interestDivided) / ((paymentValue / interestDivided) - amountValue)) / log(1 + interestDivided)
            noOfPayementsTF.text = String(format: "%.2f", calculatedNumOfMonths)
        }
        else {
            let alertController = UIAlertController(title: "Warning", message: "Please enter value(s) to calculate", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // Save data in history view when the save button is clicked
    @IBAction func onSave(_ sender: UIButton) {
        if !amountTextField.text!.isEmpty && !interestRateTextField.text!.isEmpty &&
            !paymentTextField.text!.isEmpty && !noOfPayementsTF.text!.isEmpty {
            
            let defaults = UserDefaults.standard
            // Format of displaying history
            let historyString = "Mortgage Amount is \(amountTextField.text!), Interest Rate is \(interestRateTextField.text!)%, No. of Payment is \(noOfPayementsTF.text!), Payment is \(paymentTextField.text!)"
            mortgage.historyStringArray.append(historyString)
            defaults.set(mortgage.historyStringArray, forKey: "MortgageHistory")
            
            let alertController = UIAlertController(title: "Success Alert", message: "Successfully Saved.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        // Check whether fields are empty before saving nil values
        else if amountTextField.text == "" || interestRateTextField.text == "" ||
                paymentTextField.text == "" || noOfPayementsTF.text == "" {
            
            let alertController = UIAlertController(title: "Warning Alert", message: "One or More Input are Empty", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            let alertController = UIAlertController(title: "Error Alert", message: "Please do calculate. Save Unsuccessful", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

