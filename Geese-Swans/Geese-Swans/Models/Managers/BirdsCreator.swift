//
//  BirdsCreator.swift
//  Geese-Swans
//
//  Created by Neestackich on 09.10.2020.
//

import UIKit

class BirdsCreator {
    
    
    // MARK: -Properties
    
    static let shared = BirdsCreator()
    
    
    // MARK: -Methods
    
    func createBird(type: String?, bird: Bird) -> UIView? {
        guard let type = type else {
            return nil
        }
        
        switch type {
        case Figure.square.rawValue:
            return createSquare(bird)
        case Figure.triangle.rawValue:
            return createTriangle(bird)
        default:
            return nil
        }
    }
    
    func createSquare(_ bird: Bird) -> UIView {
        let newBird = UIView(frame: CGRect(
                                x: CGFloat(bird.x),
                                y: CGFloat(bird.y),
                                width: CGFloat(bird.size),
                                height: CGFloat(bird.size)))
        newBird.backgroundColor = bird.color
        newBird.layer.cornerRadius = CGFloat(bird.size/6)
        
        let nameLabel = UILabel(frame: CGRect(
                                    x: newBird.bounds.minX,
                                    y: newBird.bounds.minY,
                                    width: CGFloat(bird.size),
                                    height: CGFloat(bird.size)))
        nameLabel.text = bird.name
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "Marker Felt", size: 16)
        
        switch bird.color {
        case UIColor.black:
            nameLabel.textColor = .systemGray3
        case UIColor.gray, UIColor.darkGray:
            nameLabel.textColor = .systemGray5
        case UIColor.orange:
            nameLabel.textColor = .systemGray5
        default:
            nameLabel.textColor = .systemGray2
        }
        
        newBird.addSubview(nameLabel)
        
        return newBird
    }
    
    func createTriangle(_ bird: Bird) -> UIView {
        let newBird = UIView(frame: CGRect(
                                x: CGFloat(bird.x),
                                y: CGFloat(bird.y),
                                width: CGFloat(bird.size),
                                height: CGFloat(bird.size)))
        newBird.layer.cornerRadius = CGFloat(bird.size/6)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: Int(bird.size)))
        path.addLine(to: CGPoint(x: Int(bird.size) / 2, y: 0))
        path.addLine(to: CGPoint(x: Int(bird.size), y: Int(bird.size)))
        path.addLine(to: CGPoint(x: 0, y: Int(bird.size)))

        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = bird.color?.cgColor
        
        newBird.layer.insertSublayer(shape, at: 0)
        
        let nameLabel = UILabel(frame: CGRect(
                                    x: newBird.bounds.minX,
                                    y: newBird.bounds.minY + newBird.bounds.height / 5,
                                    width: CGFloat(bird.size),
                                    height: CGFloat(bird.size)))
        nameLabel.text = bird.name
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "Marker Felt", size: 16)
        
        switch bird.color {
        case UIColor.black:
            nameLabel.textColor = .systemGray3
        case UIColor.gray, UIColor.darkGray:
            nameLabel.textColor = .systemGray5
        case UIColor.orange:
            nameLabel.textColor = .systemGray5
        default:
            nameLabel.textColor = .systemGray2
        }
        
        newBird.addSubview(nameLabel)
        
        return newBird
    }
}
