//
//  BirdTableViewCell.swift
//  Geese-Swans
//
//  Created by Neestackich on 07.10.2020.
//

import UIKit

class BirdTableViewCell: UITableViewCell {

    
    // MARK: -Properties
    
    @IBOutlet weak var cellMainView: UIView!
    @IBOutlet weak var birdColor: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var xCoordinateLabel: UILabel!
    @IBOutlet weak var yCoordinateLabel: UILabel!
    @IBOutlet weak var birdImage: UIImageView!
    
    
    // MARK: -Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        cellMainView.layer.cornerRadius = 25
        birdImage.layer.cornerRadius = 40
    }
    
    func configure(bird: Bird) {
        nameLabel.text = bird.name
        sizeLabel.text = String(bird.size)
        xCoordinateLabel.text = String(bird.x)
        yCoordinateLabel.text = String(bird.y)
        
        birdImage.tintColor = bird.color
        
        if bird.isFlying {
            statusLabel.text = "Flying now"
        } else {
            statusLabel.text = "Not flying"
        }
        
        if bird.type == Figure.square.rawValue {
            birdImage.image = UIImage(systemName: "square.fill")
        } else {
            birdImage.image = UIImage(systemName: "triangle.fill")
        }
    }
}
