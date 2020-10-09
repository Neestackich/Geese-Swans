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

    
    // MARK: -Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        birdsList = DatabaseManager.shared.getCoreDataBirds()
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
    }
    
    func addBirdsToPlayground() {
        for bird in birdsList {
            if let newBird = BirdsCreator.shared.createBird(type: bird.type, bird: bird) {
                skyView.addSubview(newBird)
            }
        }
    }
    
    
    // MARK: -buttons' handlers
    
    @IBAction func birdsListButtonClick(_ sender: Any) {
        let birdsListViewController = storyboard?.instantiateViewController(withIdentifier: "BirdsListViewController") as! BirdsListViewController
        birdsListViewController.modalPresentationStyle = .fullScreen
        
        present(birdsListViewController, animated: true)
    }
    
    @IBAction func addBirdButtonClick(_ sender: Any) {
        let addBirdViewController = storyboard?.instantiateViewController(withIdentifier: "AddBirdViewController") as! AddBirdViewController
        addBirdViewController.modalPresentationStyle = .fullScreen
        addBirdViewController.delegate = self
        
        present(addBirdViewController, animated: true)
    }
    
    @IBAction func deleteBirdsButtonClick(_ sender: Any) {
        DatabaseManager.shared.coreDataCleanUp(birds: birdsList)
        skyView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    
    // MARK: -delegate pattern
    
    func updateInterface() {
        birdsList = DatabaseManager.shared.getCoreDataBirds()
    }
}
