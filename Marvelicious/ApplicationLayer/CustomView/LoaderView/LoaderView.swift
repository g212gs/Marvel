//
//  LoaderView.swift
//  Marvelicious
//
//  Created by Gaurang Lathiya on 17/05/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import UIKit

class LoaderView: UIView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var iconFail: UIImageView!
    @IBOutlet weak var lblInstruction: UILabel!
    
    func startAnimating() {
        self.activityIndicator.startAnimating()
        self.iconFail.isHidden = true
        self.lblInstruction.text = "Loading ..."
        self.lblInstruction.isUserInteractionEnabled = false
    }
    
    func stopAnimating() {
        self.activityIndicator.stopAnimating()
        self.iconFail.isHidden = true
        self.lblInstruction.text = nil
        self.lblInstruction.isUserInteractionEnabled = false
    }
    
    func showFailure(withError error: String) {
        self.activityIndicator.stopAnimating()
        self.iconFail.isHidden = false
        self.lblInstruction.text = error
        self.lblInstruction.isUserInteractionEnabled = true
    }
    
}
