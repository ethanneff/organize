import UIKit

class AccessBusinessLogic {
  enum ErrorMessage {
    case Success
    case FirstNameInvalid
    case LastNameInvalid
    case EmailInvalid
    case EmailMissing
    case EmailExists
    case PasswordInvalid
    case PasswordIncorrect
    case PasswordMissing
    
    var message: String {
      switch self {
      case .Success: return "Success"
      case .FirstNameInvalid: return "Invalid first name"
      case .LastNameInvalid: return "Invalid last name"
      case .EmailInvalid: return "Invalid email"
      case .EmailExists: return "Email already in use"
      case .EmailMissing: return "Email does not exist"
      case .PasswordInvalid: return "Passwords must be longer than 6 with uppercase, lowercase, and numbers"
      case .PasswordIncorrect: return "Incorrect password"
      case .PasswordMissing: return "Invalid password"
      }
    }
  }
  
  class func displayErrorAlert(controller controller: UIViewController, message: String, textField: UITextField?) {
    let modal = ModalError()
    modal.message = message
    modal.show(controller: controller, dismissible: true) { (output) in
      if let textField = textField {
        textField.becomeFirstResponder()
      }
    }
  }
}