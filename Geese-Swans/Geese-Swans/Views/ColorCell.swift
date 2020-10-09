//
//  ColorCell.swift
//  Geese-Swans
//
//  Created by Neestackich on 08.10.2020.
//

import UIKit

class ColorCell: UITableViewCell {
    
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
       colorView.layer.cornerRadius = 25
    }
}
