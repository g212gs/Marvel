//
//  ParallaxHeader.swift
//  Marvelicious
//
//  Created by Gaurang Lathiya on 17/05/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import UIKit

class ParallaxHeader: UIView {

    @IBOutlet weak var imgViewCharacter: UIImageView!
    
    @IBOutlet weak var heightCoverConstraint: NSLayoutConstraint!
    @IBOutlet weak var topCoverConstraint: NSLayoutConstraint!
    
    var charactersObj: Characters! {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgViewCharacter.image = nil
    }
    
    func updateUI() {
        
        if let thumbNail =  self.charactersObj.thumbnail, let strURL = thumbNail.path, let strExtension = thumbNail.xtension {
            let imgURL = strURL + "." + strExtension
            
            let imgWidth = Constants.SCREEN_SIZE.width
            let imgHeight = imgWidth * (9*16)
            let imgSize: CGSize = CGSize(width: imgWidth, height: imgHeight)
            
            if let urlImg = URL(string: imgURL) {
                self.imgViewCharacter.setImageKingFisher(forImgURL: urlImg, placeHolder: nil, imgSize: imgSize)
            }
        } else {
            self.imgViewCharacter.image = nil
        }
    }
    
    func layoutHeaderView(forScrollViewOffset offset: CGPoint, inset: UIEdgeInsets) {
        let offsetY = -(offset.y + inset.top);
        self.clipsToBounds = offsetY <= 0
        topCoverConstraint.constant =  -offsetY // to stuck header always on top
        //        topCoverConstraint.constant = offsetY >= 0 ? -offsetY : 0 // to stuck when scroll to down
        heightCoverConstraint.constant = max(offsetY + inset.top, inset.top)
        //        heightCoverConstraint.constant = max(50, inset.top)  // min(offsetY + inset.top, inset.top)
    }
}
