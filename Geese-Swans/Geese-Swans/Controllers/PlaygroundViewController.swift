//
//  PlaygroundViewController.swift
//  Geese-Swans
//
//  Created by Neestackich on 06.10.2020.
//

import UIKit

class PlaygroundViewController: UIViewController, ViewControllerDelegate {
    
    
    // MARK: -Properties
    
    @IBOutlet weak var skyView: UIView!
    @IBOutlet weak var landView: UIView!
    @IBOutlet weak var addNewBird: UIButton!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var landAllBirdsButton: UIButton!
    @IBOutlet weak var showBirdsListButton: UIButton!
    
    var birdsList: [Bird] = []
    var birdsOnPlayground: [UIView : Bird] = [:]
    
    
    // MARK: -Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        addBirdsToPlayground()
    }
    
    func setup() {
        addNewBird.layer.cornerRadius = 10
        navigationBarView.layer.cornerRadius = 15
        landAllBirdsButton.layer.cornerRadius = 10
        showBirdsListButton.layer.cornerRadius = 10
        
        skyView.layer.cornerRadius = 35
        skyView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        landView.layer.cornerRadius = 10
        landView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        birdsList = DatabaseManager.shared.getCoreDataBirds()
        
        skyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(skyTapHandler)))
        landView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(landTapHandler)))
    }
    
    func addBirdsToPlayground() {
        for bird in birdsList {
            if let newBird = BirdsCreator.shared.createBird(type: bird.type, bird: bird) {
                newBird.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler)))
                skyView.addSubview(newBird)
                
                birdsOnPlayground[newBird] = bird
            }
        }
    }
    
    
    // MARK: -buttons' handlers
    
    @IBAction func birdsListButtonClick(_ sender: Any) {
        let birdsListViewController = storyboard?.instantiateViewController(withIdentifier: "BirdsListViewController") as! BirdsListViewController
        birdsListViewController.modalPresentationStyle = .fullScreen
        birdsListViewController.delegate = self
        birdsListViewController.skyView = skyView
        
        present(birdsListViewController, animated: true)
    }
    
    @IBAction func addBirdButtonClick(_ sender: Any) {
        let addBirdViewController = storyboard?.instantiateViewController(withIdentifier: "AddBirdViewController") as! AddBirdViewController
        addBirdViewController.modalPresentationStyle = .fullScreen
        addBirdViewController.delegate = self
        addBirdViewController.skyView = skyView
        
        present(addBirdViewController, animated: true)
    }
    
    @IBAction func deleteBirdsButtonClick(_ sender: Any) {
        DatabaseManager.shared.coreDataCleanUp(birds: birdsList)
        skyView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    @objc func panGestureHandler(gesture: UIPanGestureRecognizer, viewToMove: UIView) {
        if let isFlying = birdsOnPlayground[gesture.view!]?.isFlying, isFlying == false {
            if gesture.state == .began {
                print("began")
            } else if gesture.state == .changed {
                let translation = gesture.translation(in: self.skyView)
                let viewHalfHeight = gesture.view!.bounds.height / 2
                let viewHalfWidth = gesture.view!.bounds.width / 2
                
                if (gesture.view!.center.x + viewHalfWidth + translation.x) < skyView.bounds.maxX
                    && (gesture.view!.center.x - viewHalfWidth + translation.x) > skyView.bounds.minX {
                    gesture.view!.center.x = gesture.view!.center.x + translation.x
                    gesture.setTranslation(CGPoint.zero, in: skyView)
                }
                
                if (gesture.view!.center.y + viewHalfHeight + translation.y) < skyView.bounds.maxY - 16
                    && (gesture.view!.center.y - viewHalfHeight + translation.y) > skyView.bounds.minY {
                    gesture.view!.center.y = gesture.view!.center.y + translation.y
                    gesture.setTranslation(CGPoint.zero, in: skyView)
                }
                
                birdsOnPlayground[gesture.view!]?.x = Float(gesture.view!.center.x - viewHalfWidth)
                birdsOnPlayground[gesture.view!]?.y = Float(gesture.view!.center.y - viewHalfHeight)
            } else if gesture.state == .ended {
                print("ended")
                birdsOnPlayground[gesture.view!]?.isFlying = true
                
                let queue = DispatchQueue.global(qos: .default)
                queue.async {
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 5.0
                    
                    DispatchQueue.main.async {
                        animation.fromValue = [gesture.view!.center.x, gesture.view!.center.y]
                        animation.toValue = [(self.skyView.bounds.minX + gesture.view!.bounds.width / 2), gesture.view!.center.y]
                        gesture.view!.layer.add(animation, forKey: "position")
                        
                        gesture.view!.center.x = self.skyView.bounds.minX + gesture.view!.bounds.width / 2
                        self.birdsOnPlayground[gesture.view!]?.x = Float(self.skyView.bounds.minX)
                        DatabaseManager.shared.updateCoreDataBird()
                    }
                }
            }
        }
        
        DatabaseManager.shared.updateCoreDataBird()
    }
    
    @objc func skyTapHandler() {
        
    }
    
    @objc func landTapHandler() {
        skyView.subviews.forEach {
            if let isFlying = birdsOnPlayground[$0]?.isFlying, isFlying {
                let viewHeight = $0.bounds.height
                let viewWidth = $0.bounds.width
                let landedCoordinateX = CGFloat.random(in: viewWidth...(skyView.bounds.width - viewWidth))
                let landedCoordinateY = skyView.bounds.height - (viewHeight / 2) - 16
                
                $0.center.x = landedCoordinateX
                $0.center.y = landedCoordinateY
                
                birdsOnPlayground[$0]?.x = Float(landedCoordinateX - viewWidth / 2)
                birdsOnPlayground[$0]?.y = Float(landedCoordinateY - viewHeight / 2)
                birdsOnPlayground[$0]?.isFlying = false
                
                DatabaseManager.shared.updateCoreDataBird()
            }
        }
    }
    
    
    // MARK: -delegate pattern
    
    func updateInterface() {
        skyView.subviews.forEach {
            $0.removeFromSuperview()
        }
        birdsList = DatabaseManager.shared.getCoreDataBirds()
        addBirdsToPlayground()
    }
}
