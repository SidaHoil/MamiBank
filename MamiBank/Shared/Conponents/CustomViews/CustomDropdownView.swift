//
//  CustomDropdownView.swift
//  MamiBank
//
//  Created by Hoil Sida on 11/11/25.
//
import UIKit
import SwiftHelperInit

class CustomDropdownView<T>: CustomBaseView, UIPickerViewDelegate, UIPickerViewDataSource {
    private let pickerView = UIPickerView()
    
    // for dynamic generic type of items
    var configure: (_ value: T) -> String
    lazy var selectedItem: T? = nil
    // callback when an item has been selected
    // var onSelected: ((_ item: T) -> Void)?
    // dopdown list of items
    var items: [T] = [] {
        didSet {
            pickerView.reloadAllComponents()
        }
    }

    init(title: String, placeHolder: String, items: [T], configure: @escaping ((_ item: T) -> String)) {
        self.items = items
        self.configure = configure
        super.init(title: title, placeHolder: placeHolder, rightView: nil)
        setupUI()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // title label
        label.text = title
        
        // right dropdown icon
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"), contentMode: .scaleAspectFit)
        imageView.tintColor = .secondaryLabel
        
        // textfield set up
        textField.placeholder = placeHolder
        textField.rightView = imageView
        textField.rightViewMode = .always
        textField.borderStyle = .none
        textField.tintColor = .clear
        
        // picker setup
        pickerView.delegate = self
        pickerView.dataSource = self
        textField.inputView = pickerView
        
        // toolbar -- done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([flexSpace, doneButton], animated: true)
        textField.inputAccessoryView = toolbar
        
        // background view
        let textFieldBgView = UIView(style: .init(radius: 8, color: .lightGray, width: 0.2))
        textFieldBgView.backgroundColor = .secondarySystemBackground
        textFieldBgView.clipsToBounds = true
        
        // stackview setup
        let stackView = UIStackView(subViews: [
            label,
            textFieldBgView
        ], distribution: .fillProportionally, alignment: .fill, axis: .vertical, spacing: 4)
        
        addSubViewToFill(stackView)
        textFieldBgView.addSubViewToFill(textField, padding: .init(horizontal: 8))
        textField.setSize(width: 0, height: 45)
        imageView.setSize(width: 20, height: 20)
    }
    
    @objc private func donePressed() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        guard items.indices.contains(selectedRow) else { return }
        
        let selectedItem = items[selectedRow]
        textField.text = configure(selectedItem)
        self.selectedItem = selectedItem
        // onSelected?(selectedItem)
        
        textField.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return configure(items[row])
    }
}
