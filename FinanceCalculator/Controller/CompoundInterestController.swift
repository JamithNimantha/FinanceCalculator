import UIKit

class CompoundInterestController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var presentValueTextField: UITextField!
    @IBOutlet weak var futureValueTextField: UITextField!
    @IBOutlet weak var interestRateTextField: UITextField!
    @IBOutlet weak var noOfPaymentsTextField: UITextField!
    @IBOutlet weak var keyboardView: KeyboardController!
    
    var compoundInterest: CompoundInterest = CompoundInterest(presentValue: 0.0, futureValue: 0.0, interestRate: 0.0, noOfPayments: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignDelegates()
        loadDefaultsData("CompoundInterestHistory")
        loadInputWhenAppOpen()
    }
    
    func loadDefaultsData(_ historyKey: String) {
        let defaults = UserDefaults.standard
        compoundInterest.historyStringArray = defaults.object(forKey: historyKey) as? [String] ?? [String]()
    }
    
    func assignDelegates() {
        presentValueTextField.delegate = self
        presentValueTextField.inputView = UIView()
        futureValueTextField.delegate = self
        futureValueTextField.inputView = UIView()
        interestRateTextField.delegate = self
        interestRateTextField.inputView = UIView()
        noOfPaymentsTextField.delegate = self
        noOfPaymentsTextField.inputView = UIView()
    }
    
    // Save typed data in textbox to relevant key
    @IBAction func editPresentSaveDefault(_ sender: UITextField) {
        UserDefaults.standard.set(presentValueTextField.text, forKey: "compound_present")
    }
    
    @IBAction func editFutureSaveDefault(_ sender: UITextField) {
        UserDefaults.standard.set(futureValueTextField.text, forKey: "compound_future")
    }
    
    @IBAction func editInterestRateSaveDefault(_ sender: UITextField) {
        UserDefaults.standard.set(interestRateTextField.text, forKey: "compound_interest")
    }
    
    @IBAction func editNoOfPaymentsSaveDefault(_ sender: UITextField) {
        UserDefaults.standard.set(noOfPaymentsTextField.text, forKey: "compound_noOfPayment")
    }
    
    func loadInputWhenAppOpen() {
        let defaultValue = UserDefaults.standard
        presentValueTextField.text = defaultValue.string(forKey: "compound_present")
        futureValueTextField.text = defaultValue.string(forKey: "compound_future")
        interestRateTextField.text = defaultValue.string(forKey: "compound_interest")
        noOfPaymentsTextField.text = defaultValue.string(forKey: "compound_noOfPayment")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardView.activeTextField = textField
    }
    
    @IBAction func onClear(_ sender: UIButton) {
        presentValueTextField.text = ""
        futureValueTextField.text = ""
        interestRateTextField.text = ""
        noOfPaymentsTextField.text = ""
    }
    
    /*
       Formula Attribute Naming
       P = present/principal/amount value
       F = future value
       r = interest rate
       t = (time) number of payments
       n = compound per year
       PMT = payment
    */
    
    @IBAction func onCalculate(_ sender: UIButton) {
        guard let presentText = presentValueTextField.text,
              let futureText = futureValueTextField.text,
              let interestText = interestRateTextField.text,
              let noOfPaymentsText = noOfPaymentsTextField.text,
              !presentText.isEmpty || !futureText.isEmpty || !interestText.isEmpty || !noOfPaymentsText.isEmpty
        else {
            let alertController = UIAlertController(title: "Alert", message: "Please enter value(s) to calculate", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
            return
        }
        
        let presentValue = Double(presentText) ?? 0.0
        let futureValue = Double(futureText) ?? 0.0
        let interestRate = Double(interestText) ?? 0.0
        let noOfPayments = Double(noOfPaymentsText) ?? 0.0
        let interestDivided = interestRate / 100
        
        if presentText.isEmpty {
            /// present value formula - P =  A/(1+rn)nt
            let presentValueCalculate = futureValue / pow(1 + (interestDivided / 12), 12 * noOfPayments)
            presentValueTextField.text = String(format: "%.2f", presentValueCalculate)
        } else if futureText.isEmpty {
            ///future value formula - A = P(1+(r/n)nt)
            let futureValueCalculate = presentValue * pow(1 + (interestDivided / 12), 12 * noOfPayments)
            futureValueTextField.text = String(format: "%.2f", futureValueCalculate)
        } else if interestText.isEmpty {
            /// interest rate formula - r = n[(A/P)1/nt-1]
            let interestRateCalculate = 12 * (pow((futureValue / presentValue), 1 / (12 * noOfPayments)) - 1)
            interestRateTextField.text = String(format: "%.2f", interestRateCalculate * 100)
        } else if noOfPaymentsText.isEmpty {
            /// number of payments formula - t = log(A/P) /n [log(1+r/n)]
            let noOfPaymentsCalculate = log(futureValue / presentValue) / (12 * log(1 + interestDivided / 12))
            noOfPaymentsTextField.text = String(format: "%.2f", noOfPaymentsCalculate)
        } else {
            let alertController = UIAlertController(title: "Warning", message: "Need one empty field.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        }
    }
    
    @IBAction func onSave(_ sender: UIButton) {
        if let presentText = presentValueTextField.text, let futureText = futureValueTextField.text,
           let interestText = interestRateTextField.text, let noOfPaymentsText = noOfPaymentsTextField.text,
           !presentText.isEmpty, !futureText.isEmpty, !interestText.isEmpty, !noOfPaymentsText.isEmpty {
            let defaults = UserDefaults.standard
            let historyString = "Present Value is \(presentText), Future Value is \(futureText), Interest Rate is \(interestText)%,  No. of Payment is \(noOfPaymentsText)"
            compoundInterest.historyStringArray.append(historyString)
            defaults.set(compoundInterest.historyStringArray, forKey: "CompoundInterestHistory")
            let alertController = UIAlertController(title: "Success Alert", message: "Successfully Saved.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: "Warning Alert", message: "One or More Input are Empty", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        }
    }
}
