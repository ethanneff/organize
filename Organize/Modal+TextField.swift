//
//  Modal+TextField.swift
//  Organize
//
//  Created by Ethan Neff on 6/3/16.
//  Copyright © 2016 Ethan Neff. All rights reserved.
//

import UIKit

class ModalTextField: Modal, UITextFieldDelegate {
  // MARK: - properties
  var text: String? {
    didSet {
      textField.text = text
    }
  }
  var keyboardType: UIKeyboardType? {
    didSet {
      if let keyboardType = keyboardType {
        textField.keyboardType = keyboardType
      }
    }
  }
  var secureEntry: Bool = false {
    didSet {
      textField.secureTextEntry = secureEntry
    }
  }
  var placeholder: String? {
    didSet {
      if let placeholder = placeholder {
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes:[NSForegroundColorAttributeName: Constant.Color.border])
      }
    }
  }
  var limit: Int?
  
  private var textField: UITextField!
  private var yes: UIButton!
  private var no: UIButton!
  private var topSeparator: UIView!
  private var midSeparator: UIView!
  private var modalCenterYConstraint: NSLayoutConstraint!
  
  enum OutputKeys: String {
    case Text
  }
  
  // MARK: - init
  override init() {
    super.init()
    createViews()
    createConstraints()
    createKeyboard()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init coder not implemented")
  }
  
  // MARK: - deinit
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
  }
  
  // MARK: - load
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    textField.becomeFirstResponder()
    UINavigationBar.appearance().barStyle = .Black
    self.setNeedsStatusBarAppearanceUpdate()
  }
  
  // MARK: - create
  private func createViews() {
    textField = createTextField()
    topSeparator = createSeparator()
    midSeparator = createSeparator()
    yes = createButton(title: nil, confirm: true)
    no = createButton(title: nil, confirm: false)
    
    modal.addSubview(textField)
    modal.addSubview(topSeparator)
    modal.addSubview(midSeparator)
    modal.addSubview(yes)
    modal.addSubview(no)
    
    yes.addTarget(self, action: #selector(buttonPressed(_:)), forControlEvents: .TouchUpInside)
    no.addTarget(self, action: #selector(buttonPressed(_:)), forControlEvents: .TouchUpInside)
  }
  
  private func createKeyboard() {
    // return
    textField.delegate = self
    // scroll
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardNotification(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    // dismiss
    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  
  private func createConstraints() {
    modalCenterYConstraint = NSLayoutConstraint(item: modal, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0)
    
    NSLayoutConstraint.activateConstraints([
      NSLayoutConstraint(item: modal, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: Constant.Button.height*2+separatorHeight+Constant.Button.padding*3/2),
      NSLayoutConstraint(item: modal, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: Constant.Button.height*6),
      NSLayoutConstraint(item: modal, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0),
      modalCenterYConstraint,
      ])
    
    NSLayoutConstraint.activateConstraints([
      NSLayoutConstraint(item: textField, attribute: .Top, relatedBy: .Equal, toItem: modal, attribute: .Top, multiplier: 1, constant: Constant.Button.padding),
      NSLayoutConstraint(item: textField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: Constant.Button.height),
      NSLayoutConstraint(item: textField, attribute: .Leading, relatedBy: .Equal, toItem: modal, attribute: .Leading, multiplier: 1, constant: Constant.Button.padding),
      NSLayoutConstraint(item: textField, attribute: .Trailing, relatedBy: .Equal, toItem: modal, attribute: .Trailing, multiplier: 1, constant: -Constant.Button.padding),
      ])
    constraintButtonDoubleBottom(topSeparator: topSeparator, midSeparator: midSeparator, left: no, right: yes)
  }
  
  // MARK: - buttons
  func buttonPressed(button: UIButton) {
    Util.animateButtonPress(button: button)
    
    hide() {
      if button.tag == 1 {
        if let completion = self.completion, let text = self.textField?.text?.trim where text.length > 0 {
          completion(output: [OutputKeys.Text.rawValue: text])
        }
      }
    }
  }
  
  // MARK: - keyboard
  internal func textFieldShouldReturn(textField: UITextField) -> Bool {
    buttonPressed(yes)
    return true
  }
  
  internal func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text, let limit = limit else {
      return true
    }
    let newLength = text.characters.count + string.characters.count - range.length
    return newLength <= limit
  }
  
  internal func keyboardNotification(notification: NSNotification) {
    Util.handleKeyboardScrollView(keyboardNotification: notification, scrollViewBottomConstraint: modalCenterYConstraint, view: view, constant: view.center.y/2)
  }
  
  internal func dismissKeyboard() {
    view.endEditing(true)
  }
}