//
//  BirdsListViewController.swift
//  Geese-Swans
//
//  Created by Neestackich on 06.10.2020.
//

import UIKit

class BirdsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewControllerDelegate {

    
    // MARK: -Properties
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBirdButton: UIButton!
    @IBOutlet weak var deleteAllBirds: UIButton!
    
    var birdsList: [Bird] = []
    
    
    // MARK: -Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        birdsList = DatabaseManager.shared.getCoreDataBirds()
    }
    
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 30
        backButton.layer.cornerRadius = 10
        addBirdButton.layer.cornerRadius = 10
        deleteAllBirds.layer.cornerRadius = 10
    }
    
    
    // MARK: -buttons' handlers
    
    @IBAction func backButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBirdButtonClick(_ sender: Any) {
        let addBirdViewController = storyboard?.instantiateViewController(withIdentifier: "AddBirdViewController") as! AddBirdViewController
        addBirdViewController.modalPresentationStyle = .fullScreen
        addBirdViewController.delegate = self
        
        present(addBirdViewController, animated: true)
    }
    
    @IBAction func deleteButtonClick(_ sender: Any) {
        DatabaseManager.shared.coreDataCleanUp(birds: birdsList)
        updateInterface()
    }
    
    
    // MARK: -delegate pattern
    
    func updateInterface() {
        birdsList = DatabaseManager.shared.getCoreDataBirds()
        tableView.reloadData()
    }
    
    
    // MARK: -tableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birdsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let birdTableViewCell = tableView.dequeueReusableCell(withIdentifier: "BirdTableViewCell") as! BirdTableViewCell
        
        birdTableViewCell.configure(bird: birdsList[indexPath.row])
        
        if indexPath.row % 2 == 0 {
            // green cell
            birdTableViewCell.cellMainView.backgroundColor = UIColor(red: 161/255, green: 204/255, blue: 188/255, alpha: 1)
        } else {
            // pink cell
            birdTableViewCell.cellMainView.backgroundColor = UIColor(red: 222/255, green: 241/255, blue: 255/255, alpha: 1)
        }
        
        return birdTableViewCell
    }
}
