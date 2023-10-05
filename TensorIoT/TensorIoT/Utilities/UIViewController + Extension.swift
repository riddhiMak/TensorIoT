//
//  UIViewController + Extension.swift
//  TensorIoT
//
//  Created by Riddhi Makwana on 04/10/23.
//

import Foundation
import UIKit
import MBProgressHUD
extension UIViewController {
   func showIndicator(withTitle title: String, and Description:String) {
      let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
      Indicator.label.text = title
      Indicator.isUserInteractionEnabled = false
      Indicator.detailsLabel.text = Description
      Indicator.show(animated: true)
   }
   func hideIndicator() {
      MBProgressHUD.hide(for: self.view, animated: true)
   }
}

