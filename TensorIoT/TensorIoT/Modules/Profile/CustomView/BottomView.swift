//
//  BottomView.swift
//  TensorIoT
//
//  Created by Riddhi Makwana on 04/10/23.
//

import UIKit

class BottomView: UIView {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    func getSelectedTitle() -> String {
        let index = segmentedControl.selectedSegmentIndex
        let title = segmentedControl.titleForSegment(at: index) ?? ""
        
        return title
        
    }
    
}
