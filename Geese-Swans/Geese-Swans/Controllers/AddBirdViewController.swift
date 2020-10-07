//
//  AddBirdViewController.swift
//  Geese-Swans
//
//  Created by Neestackich on 06.10.2020.
//

import UIKit

class AddBirdViewController: UIViewController {

    
    // MARK: -Properties
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var form: UIStackView!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    // MARK: -Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        backButton.layer.cornerRadius = 10
        clearButton.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 28
        sizeTextField.layer.cornerRadius = 10
        nameTextField.layer.cornerRadius = 10
        navigationBarView.layer.cornerRadius = 15
        form.layer.cornerRadius = 15
    }
    
    
    // MARK: -buttons' handlers
    
    @IBAction func clearButtonClick(_ sender: Any) {
        
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
    }
}
