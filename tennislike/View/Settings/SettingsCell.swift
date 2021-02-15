//
//  SettingsCell.swift
//  tennislike
//
//  Created by Maik Nestler on 08.12.20.
//

import UIKit

protocol SettingsCellDelegate: class {
    func settingsCellUpdate(_ cell: SettingsCell, wantsToUpdateUserWith value: String, for section: SettingsSections)
    
    func settingsCell(_ cell: SettingsCell, wantsToUpdateAgeRangeWith sender: UISlider)
}

class SettingsCell: UITableViewCell {
    
    //MARK: - Properties
    
    var viewModel: SettingsViewModel! {
        didSet { configure() }
    }
    
    weak var delegate: SettingsCellDelegate?
    
    lazy var inputField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.tintColor = .black
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 50, width: 20)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        
        tf.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
        return tf
    }()
    
//    private let skillSegmentedControl: UISegmentedControl = {
//        let sc = UISegmentedControl(items: ["Anfänger", "Fortgeschritten", "Profi"])
//        sc.backgroundColor = .black
//        sc.tintColor = UIColor(white: 1, alpha: 0.87)
//        sc.selectedSegmentIndex = 0
//        return sc
//    }()
    
    var sliderStack = UIStackView()
    
    let minAgeLabel = UILabel()
    let maxAgeLabel = UILabel()

    lazy var minAgeSlider = createAgeRangeSlider()
    lazy var maxAgeSlider = createAgeRangeSlider()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(inputField)
        inputField.fillSuperview()
        
        let minStack = UIStackView(arrangedSubviews: [minAgeLabel, minAgeSlider])
        minStack.spacing = 24
        
        let maxStack = UIStackView(arrangedSubviews: [maxAgeLabel, maxAgeSlider])
        maxStack.spacing = 24
        
        sliderStack = UIStackView(arrangedSubviews: [minStack, maxStack])
        sliderStack.axis = .vertical
        sliderStack.spacing = 16
        
        addSubview(sliderStack)
        sliderStack.centerY(inView: self)
        sliderStack.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 24, paddingRight: 24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleUpdateUserInfo(sender: UITextField) {
        guard let value = sender.text else { return }
        delegate?.settingsCellUpdate(self, wantsToUpdateUserWith: value, for: viewModel.section)
    }
    
    @objc func handleAgeRangeChanged(sender: UISlider) {
        if sender == minAgeSlider {
            minAgeLabel.text = viewModel.minAgeLabelText(forValue: sender.value)
        } else {
            maxAgeLabel.text = viewModel.maxAgeLabelText(forValue: sender.value)
        }
        
        delegate?.settingsCell(self, wantsToUpdateAgeRangeWith: sender)
    }
    
    //MARK: - Helper Functions
    
    func configure() {
        inputField.isHidden = viewModel.shouldHideInputField
        sliderStack.isHidden = viewModel.shouldHideSlider
        
        inputField.placeholder = viewModel.placeholderText
        inputField.text = viewModel.value
        
        minAgeLabel.text = viewModel.minAgeLabelText(forValue: viewModel.minAgeSliderValue)
        maxAgeLabel.text = viewModel.maxAgeLabelText(forValue: viewModel.maxAgeSliderValue)
        
        minAgeSlider.setValue(viewModel.minAgeSliderValue, animated: true)
        maxAgeSlider.setValue(viewModel.maxAgeSliderValue, animated: true)
    }
    
    func createAgeRangeSlider() -> UISlider {
        let slider = UISlider()
        slider.tintColor = .black
        slider.minimumValue = 16
        slider.maximumValue = 60
        slider.addTarget(self, action: #selector(handleAgeRangeChanged), for: .valueChanged)
        return slider
    }
}
