import UIKit

extension UIColor {
  // add hex to UIColor function to UIColor
  convenience init(hex: String) {
    let hex = hex.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
    var int = UInt32()
    NSScanner(string: hex).scanHexInt(&int)
    let a, r, g, b: UInt32
    switch hex.characters.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (1, 1, 1, 0)
    }
    self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
  }
  
  var image: UIImage {
    let rect:CGRect = CGRectMake(0.0, 0.0, 1.0, 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context:CGContextRef = UIGraphicsGetCurrentContext()!
    CGContextSetFillColorWithColor(context, self.CGColor)
    CGContextFillRect(context, rect)
    let image:UIImage = UIGraphicsGetImageFromCurrentImageContext();
    return image
  }
}