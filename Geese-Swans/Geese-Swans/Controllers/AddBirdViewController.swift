//
//  AddBirdViewController.swift
//  Geese-Swans
//
//  Created by Neestackich on 06.10.2020.
//

import UIKit

class AddBirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    // MARK: -Properties
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var form: UIStackView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var squareViewButton: UIView!
    @IBOutlet weak var squareImage: UIImageView!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var triangleImage: UIImageView!
    @IBOutlet weak var triangleViewButton: UIView!
    @IBOutlet weak var colorTableView: UITableView!
    
    var skyView: UIView?
    var figureType: Figure?
    var delegate: ViewControllerDelegate?
    var colors: [UIColor] = [.red, .blue, .orange, .green, .black, .brown, .darkGray, .purple, .cyan, .yellow, .gray]
        
    
    // MARK: -Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        colorTableView.delegate = self
        colorTableView.dataSource = self
        
        sizeTextField.delegate = self
        
        form.layer.cornerRadius = 15
        backButton.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 28
        squareImage.layer.cornerRadius = 20
        clearButton.layer.cornerRadius = 10
        triangleImage.layer.cornerRadius = 20
        sizeTextField.layer.cornerRadius = 10
        nameTextField.layer.cornerRadius = 10
        colorTableView.layer.cornerRadius = 25
        navigationBarView.layer.cornerRadius = 15
        
        colorTableView.isHidden = true
        
        sizeTextField.text = String(Int.random(in: 35...65))
        
        colorView.backgroundColor = colors[Int.random(in: 0..<colors.count)]
        colorView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showHideColorTable)))
        triangleViewButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseTriangle)))
        squareViewButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseSquare)))
        
        randomFigure()
    }
    
    override func viewDidLayoutSubviews() {
        colorView.layer.cornerRadius = colorView.bounds.height / 2
    }
    
    func randomFigure() {
        if Int.random(in: 0...1) == 0 {
            chooseSquare()
        } else {
            chooseTriangle()
        }
    }
    
    func checkFields() -> TextFieldsStatus {
        guard let unwrappedSize = sizeTextField.text else {
            return .invalidSize
        }
        
        let size = unwrappedSize.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let size = Float(size) {
            if size >= 35 && size <= 65 {
                return .allValid
            } else {
                return .invalidSize
            }
        } else {
            return .invalidSize
        }
    }
    
    
    // MARK: -buttons' handlers
    
    @IBAction func increaseSizeButtonClick(_ sender: Any) {
        guard let size = sizeTextField.text else {
            return
        }
        
        if let size = Int(size) {
            if size < 65 {
                sizeTextField.text = String(size + 1)
            }
        }
    }
    
    @IBAction func decreaseSizeButtonClick(_ sender: Any) {
        guard let size = sizeTextField.text else {
            return
        }
        
        if let size = Int(size) {
            if size > 35 {
                sizeTextField.text = String(size - 1)
            }
        }
    }
    
    @IBAction func clearButtonClick(_ sender: Any) {
        sizeTextField.text?.removeAll()
        nameTextField.text?.removeAll()
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate!.updateInterface()
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        let textFIeldsStatus = checkFields()
        
        switch textFIeldsStatus {
        case .invalidSize:
            UIView.animate(withDuration: 2) {
                self.sizeTextField.textColor = .red
            }
        case .allValid:
            let size = Float(sizeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let size = size, let figureType = figureType, let skyView = skyView {
                DatabaseManager.shared.addBirdToCoreData(
                    size: size,
                    color: colorView.backgroundColor ?? .black,
                    name: name,
                    type: figureType.rawValue,
                    x: Float.random(in: size...Float(skyView.bounds.width) - size),
                    y: Float(skyView.bounds.height) - size - 16,
                    lastMovementX: Float.random(in: size...Float(skyView.bounds.width) - size),
                    lastMovementY: Float(skyView.bounds.height) - size - 16,
                    isFlying: false)
                
                dismiss(animated: true, completion: nil)
                delegate!.updateInterface()
            }
        }
    }
    
    @objc func showHideColorTable() {
        if colorTableView.isHidden {
            colorTableView.isHidden = false
        } else {
            colorTableView.isHidden = true
        }
    }
    
    @objc func chooseTriangle() {
        figureType = .triangle
        
        triangleImage.backgroundColor = UIColor(red: 197/255, green: 141/255, blue: 139/255, alpha: 1)
        squareImage.backgroundColor = UIColor(red: 237/255, green: 168/255, blue: 165/255, alpha: 1)
    }
    
    @objc func chooseSquare() {
        figureType = .square
        
        squareImage.backgroundColor = UIColor(red: 197/255, green: 141/255, blue: 139/255, alpha: 1)
        triangleImage.backgroundColor = UIColor(red: 237/255, green: 168/255, blue: 165/255, alpha: 1)
    }
    
    
    // MARK: -tableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let colorCell = tableView.dequeueReusableCell(withIdentifier: "ColorCell") as! ColorCell
        colorCell.colorView.backgroundColor = colors[indexPath.row]
        
        return colorCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        colorView.backgroundColor = colors[indexPath.row]
        showHideColorTable()
    }
    
    
    // MARK: -textField methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        sizeTextField.textColor = .systemGray
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        sizeTextField.textColor = .systemGray
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        sizeTextField.textColor = .systemGray
    }
}
