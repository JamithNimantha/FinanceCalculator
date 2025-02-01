//
//  KeyboardController.swift
//  FinanceCalculator
//
//  Created by Jamith Nimantha on 2023-07-29.
//

import UIKit

// Enum representing the various buttons on the custom keyboard
enum KeyboardButton: Int {
    case zero, one, two, three, four, five, six, seven, eight, nine, period, delete, negation
}

class KeyboardController: UIView {
    let nibName = "Keyboard"
    var contentView: UIView?
    
    // Required initializer for UIView subclass from a storyboard or nib
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Load the view from the nib and add it as a subview
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    
    // Load the view from the nib file
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    // The active text field that will receive input from the custom keyboard
    var activeTextField = UITextField()
    
    // Action triggered when a button on the custom keyboard is pressed
    @IBAction func onBtnPressed(_ sender: UIButton) {
        let cursorPosition = getCursorPosition()
        
        if let currentText = self.activeTextField.text {
            switch KeyboardButton(rawValue: sender.tag)! {
            case .period:
                // Allow inserting a period if it doesn't exist and the text is not empty
                if !currentText.contains("."), currentText.count != 0 {
                    activeTextField.insertText(".")
                    setCursorPosition(from: cursorPosition)
                }
            case .delete:
                // Delete the character before the cursor position if the text is not empty
                if currentText.count != 0 {
                    self.activeTextField.text?.remove(at: currentText.index(currentText.startIndex, offsetBy: cursorPosition - 1))
                    
                    // If the deleted character is not a period, trigger the editingChanged event
                    if String(currentText[currentText.index(currentText.startIndex, offsetBy: cursorPosition - 1)]) != "." {
                        activeTextField.sendActions(for: UIControl.Event.editingChanged)
                    }
                    
                    // Move the cursor back one position
                    setCursorPosition(from: cursorPosition, offset: -1)
                }
            case .negation:
                // Allow inserting a negation sign if it doesn't exist and the text is not empty
                if !currentText.contains("-"), currentText.count != 0 {
                    activeTextField.text?.insert("-", at: currentText.index(currentText.startIndex, offsetBy: 0))
                    activeTextField.sendActions(for: UIControl.Event.editingChanged)
                    setCursorPosition(from: cursorPosition)
                }
            default:
                // Insert the corresponding number from the button tag
                activeTextField.insertText(String(sender.tag))
                setCursorPosition(from: cursorPosition)
            }
        }
    }
    
    // Get the current cursor position in the active text field
    func getCursorPosition() -> Int {
        guard let selectedRange = activeTextField.selectedTextRange else { return 0 }
        return activeTextField.offset(from: activeTextField.beginningOfDocument, to: selectedRange.start)
    }
    
    // Set the cursor position in the active text field
    func setCursorPosition(from: Int, offset: Int = 1) {
        if let newPosition = activeTextField.position(from: activeTextField.beginningOfDocument, offset: from + offset) {
            activeTextField.selectedTextRange = activeTextField.textRange(from: newPosition, to: newPosition)
        }
    }
}
