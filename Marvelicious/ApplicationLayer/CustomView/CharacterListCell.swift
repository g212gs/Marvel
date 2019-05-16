//
//  CharacterListCell.swift
//  Marvelicious
//
//  Created by Gaurang Lathiya on 17/05/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import UIKit

class CharacterListCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgViewCharacter: UIImageView!
    
    var charactersObj: Characters! {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.resetUI()
        
        self.imgViewCharacter.layer.cornerRadius = 10.0
        self.imgViewCharacter.layer.masksToBounds = true
        
        self.containerView.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        self.lblName.textColor = UIColor.white
        self.lblName.font = Constants.AppRegularFontWithSize(size: 24.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func resetUI() {
        self.containerView.backgroundColor = UIColor.clear
        self.lblName.text = nil
        self.imgViewCharacter.image = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.resetUI()
    }
    
    func updateUI() {

        
        self.lblName.text = self.charactersObj.name ?? "N/A"
        
        if let thumbNail =  self.charactersObj.thumbnail, let strURL = thumbNail.path, let strExtension = thumbNail.xtension {
            let imgURL = strURL + "." + strExtension
            
            let imgWidth = Constants.SCREEN_SIZE.width - 8
            let imgHeight = imgWidth * (9*16)
            let imgSize: CGSize = CGSize(width: imgWidth, height: imgHeight)
            
            if let urlImg = URL(string: imgURL) {
                self.imgViewCharacter.setImageKingFisher(forImgURL: urlImg, placeHolder: nil, imgSize: imgSize)
            }
        } else {
            self.imgViewCharacter.image = nil
        }
    }

}
