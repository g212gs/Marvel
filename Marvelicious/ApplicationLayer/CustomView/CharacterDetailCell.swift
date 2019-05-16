//
//  CharacterDetailCell.swift
//  Marvelicious
//
//  Created by Gaurang Lathiya on 17/05/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import UIKit


class CharacterDetailCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    
    var cellType: DetailCellFor = DetailCellFor.title {
        didSet {
            self.updateDefaultUI()
        }
    }
    
    var strDetail: String! {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func resetUI() {
        self.lblName.text = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.resetUI()
    }
    
    func updateDefaultUI() {
        self.lblName.font = self.cellType.font
        self.lblName.textColor = self.cellType.color
    }
    
    func updateUI() {
        self.lblName.text = self.strDetail
    }
}
