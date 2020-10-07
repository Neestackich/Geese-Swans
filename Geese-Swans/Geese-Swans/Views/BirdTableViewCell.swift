//
//  BirdTableViewCell.swift
//  Geese-Swans
//
//  Created by Neestackich on 07.10.2020.
//

import UIKit

class BirdTableViewCell: UITableViewCell {

    @IBOutlet weak var cellMainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        cellMainView.layer.cornerRadius = 25
    }
}
