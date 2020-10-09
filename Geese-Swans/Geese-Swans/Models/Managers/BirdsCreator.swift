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
                                x: 133,
                                y: CGFloat(bird.y),
                                width: CGFloat(bird.size),
                                height: CGFloat(bird.size)))
        newBird.backgroundColor = bird.color
        newBird.layer.cornerRadius = CGFloat(bird.size/6)
        
        let nameLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: CGFloat(bird.size), height: CGFloat(bird.size/2)))
        nameLabel.center = newBird.center
        nameLabel.text = bird.name
        
        newBird.addSubview(nameLabel)
        
        return newBird
    }
    
    func createTriangle(_ bird: Bird) -> UIView {
        let newBird = UIView(frame: CGRect(
                                x: CGFloat(bird.x),
                                y: CGFloat(bird.y),
                                width: CGFloat(bird.size),
                                height: CGFloat(bird.size)))
        newBird.backgroundColor = bird.color
        newBird.layer.cornerRadius = CGFloat(bird.size/6)
        
        let nameLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: CGFloat(bird.size), height: CGFloat(bird.size/2)))
        nameLabel.center = newBird.center
        nameLabel.text = bird.name
        
        newBird.addSubview(nameLabel)
        
        return newBird
    }
}
