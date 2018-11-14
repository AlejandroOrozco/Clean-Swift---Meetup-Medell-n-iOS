//
//  Extensions.swift
//  Meetup-CleanSwift
//
//  Created by Alejandro Orozco Builes on 11/10/18.
//  Copyright © 2018 Alejandro Orozco Builes. All rights reserved.
//

import UIKit

extension UIApplication {
  
  var statusBarView: UIView? {
    return value(forKey: "statusBar") as? UIView
  }
  
}

extension UIImageView {
  public func imageFromServerURL(urlString: String?) {
    
    guard let urlString = urlString else {
      image = #imageLiteral(resourceName: "NotFound")
      return
    }

    URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
      if error != nil { return }
      DispatchQueue.main.async(execute: { () -> Void in
        let image = UIImage(data: data!)
        self.image = image
      })
    }).resume()
  }
}

@IBDesignable
extension UIView {
  
  @IBInspectable
  var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
    }
  }
  
  @IBInspectable
  var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  @IBInspectable
  var borderColor: UIColor? {
    get {
      if let color = layer.borderColor {
        return UIColor(cgColor: color)
      }
      return nil
    }
    set {
      if let color = newValue {
        layer.borderColor = color.cgColor
      } else {
        layer.borderColor = nil
      }
    }
  }
  
  @IBInspectable
  var shadowRadius: CGFloat {
    get {
      return layer.shadowRadius
    }
    set {
      layer.shadowRadius = newValue
    }
  }
  
  @IBInspectable
  var shadowOpacity: Float {
    get {
      return layer.shadowOpacity
    }
    set {
      layer.shadowOpacity = newValue
    }
  }
  
  @IBInspectable
  var shadowOffset: CGSize {
    get {
      return layer.shadowOffset
    }
    set {
      layer.shadowOffset = newValue
    }
  }
  
  @IBInspectable
  var shadowColor: UIColor? {
    get {
      if let color = layer.shadowColor {
        return UIColor(cgColor: color)
      }
      return nil
    }
    set {
      if let color = newValue {
        layer.shadowColor = color.cgColor
      } else {
        layer.shadowColor = nil
      }
    }
  }
}

extension String {
  var htmlToAttributedString: NSAttributedString? {
    guard let data = data(using: .utf8) else { return NSAttributedString() }
    do {
      return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    } catch {
      return NSAttributedString()
    }
  }
  
  var htmlToString: String {
    return htmlToAttributedString?.string ?? String()
  }
}

extension String {
  
  func localized(withLocalizable localizable: String = "Localizable",
                 withComment comment: String = "") -> String {
    var bundle = Bundle.main
    var localizedValue = NSLocalizedString(self, tableName: localizable, bundle: bundle, comment: comment)
    if localizedValue == self {
      bundle = Bundle.main
      localizedValue = NSLocalizedString(self, tableName: localizable, bundle: bundle, comment: comment)
    }
    return localizedValue
  }
  
  func localizedWithArgs(withLocalizable localizable: String = "Localizable",
                         withComment comment: String = String(),
                         args: CVarArg...) -> String {
    let localizedValue = localized( withLocalizable: localizable, withComment: comment)
    return String(format: localizedValue, arguments: args)
  }
}
