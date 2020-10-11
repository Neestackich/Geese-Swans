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
    var birdsInFlight: [UIView: Timer] = [:]
    
    
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
                
                let birdMovementTimer = Timer.scheduledTimer(
                    timeInterval: 1,
                    target: self,
                    selector: #selector(timerHandler),
                    userInfo: gesture.view!,
                    repeats: true)
                birdsInFlight[gesture.view!] = birdMovementTimer
            }
        }
        
        DatabaseManager.shared.updateCoreDataBird()
    }
    
    @objc func timerHandler(timer: Timer) {
        guard let birdView = timer.userInfo as? UIView else {
            return
        }
        
        if birdView.center.x > self.skyView.bounds.minX + birdView.bounds.width  {
            let randomLength = CGFloat.random(in: 50...100)
            print(randomLength)
            
            let movementAnimation = CABasicAnimation(keyPath: "position")
            movementAnimation.duration = 1.0
            movementAnimation.fromValue = [birdView.center.x, birdView.center.y]
            movementAnimation.toValue = [birdView.center.x - randomLength, birdView.center.y]
            
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2
            rotationAnimation.duration = 1
            rotationAnimation.repeatCount = 1
            
            birdView.layer.add(movementAnimation, forKey: "position")
            birdView.layer.add(rotationAnimation, forKey: "transform.rotation")
            birdView.center.x -= randomLength
            
            self.birdsOnPlayground[birdView]?.x = Float(birdView.center.x - birdView.bounds.width / 2)
        } else {
            // останавливаем таймер
            // спускаем и ведем по земле вьюшку
            timer.invalidate()
            birdView.layer.removeAllAnimations()

            while birdView.center.y < self.skyView.bounds.maxY - 16 - birdView.bounds.height / 2 {
                let randomLength = CGFloat.random(in: 1...2)
                print(birdView.center.y)

                UIView.animate(
                    withDuration: 1,
                    animations: {
                        birdView.center.y += randomLength
                    },
                        completion: {_ in
                            let randomLength = CGFloat.random(in: 50...self.skyView.bounds.maxX - birdView.bounds.width)

                            UIView.animate(
                                withDuration: 1,
                                animations: {
                                    birdView.center.x = randomLength
                                },
                                completion: {_ in
                                    self.birdsOnPlayground[birdView]?.y = Float(birdView.center.y - birdView.bounds.height / 2)
                                    self.birdsOnPlayground[birdView]?.x = Float(birdView.center.x - birdView.bounds.width / 2)
                                    self.birdsOnPlayground[birdView]?.isFlying = false

                                    DatabaseManager.shared.updateCoreDataBird()
                                })
                        })
            }
        }
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
                $0.layer.removeAllAnimations()
                
                birdsInFlight[$0]?.invalidate()
                
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
