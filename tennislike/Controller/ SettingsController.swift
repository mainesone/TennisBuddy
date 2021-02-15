//
//   SettingsController.swift
//  tennislike
//
//  Created by Maik Nestler on 08.12.20.
//

import UIKit
import JGProgressHUD

private let reuseIdentifier = "SettingsCell"

protocol SettingsControllerDelegate: class {
    func settingsController(_ controller: SettingsController, wantsToUpdate user: User)
    func settingsControllerWantsToLogout(_ controller: SettingsController)
}

class SettingsController: UITableViewController {
    
    //MARK: - Properties
    
    private var user: User
    
    weak var delegate: SettingsControllerDelegate?
    
    private lazy var headerView = SettingsHeader(user: user)
    
    private lazy var footerView = SettingsFooter()
    
    private let imagePicker = UIImagePickerController()
    
    private var imageIndex = 0
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    
    //MARK: - API
    
    func uploadImage(image: UIImage) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Bild speichern"
        hud.show(in: view)
        
        Service.uploadImage(image: image) { imageUrl in
            self.user.imageURLs.append(imageUrl)
            hud.dismiss()
        }
    }
    
    
    //MARK: - Selectors
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
        
    @objc func handleSave() {
        view.endEditing(true)
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Deine Daten werden gespeichert"
        hud.show(in: view)
        
        Service.saveUserData(user: user) { error in
            self.delegate?.settingsController(self, wantsToUpdate: self.user)
        }
    }
    
    //MARK: - HelperFunctions
    
    func setHeaderImage(_ image: UIImage?) {
        headerView.buttons[imageIndex].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    func configureUI() {
        headerView.delegate = self
        footerView.delegate = self
        imagePicker.delegate = self
        
        navigationItem.title = "Einstellungen"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleSave))
        
        //TableView
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.tintColor = .brandingColor
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        tableView.backgroundColor = .white
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 80)
        
    }    
}

//MARK: - SettingsHeaderDelegate

extension SettingsController: SettingsHeaderDelegate {
    func settingsHeader(_ header: SettingsHeader, didSelect index: Int) {
        self.imageIndex = index
        present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: - SettingsCellDelegate

extension SettingsController: SettingsCellDelegate {
    func settingsCell(_ cell: SettingsCell, wantsToUpdateAgeRangeWith sender: UISlider) {
        if sender == cell.minAgeSlider {
            user.minSeekingAge = Int(sender.value)
        } else {
            user.maxSeekingAge = Int(sender.value)
        }
    }
    
    func settingsCellUpdate(_ cell: SettingsCell, wantsToUpdateUserWith value: String, for section: SettingsSections) {
        
        switch section {
        
        case .name:
            user.name = value
        case .skill:
            user.skill = value
        case .age:
            user.age = Int(value) ?? user.age
        case .club:
            user.club = value
        case .ageRange:
            break
        }
        
        print("User is \(user)")
    }
}

//MARK: - SettingsFooterDelegate

extension SettingsController: SettingsFooterDelegate {
    func handleLogout() {
        delegate?.settingsControllerWantsToLogout(self)
    }
    
    
}

//MARK: - ImagePickerDelegate

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        uploadImage(image: selectedImage)
        
        setHeaderImage(selectedImage)
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - SettingsController DataSource

extension SettingsController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSections.allCases.count
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        setTableViewBackgroundGradient(sender: self, UIColor.white, UIColor.brandingColor)
        
        guard let section = SettingsSections(rawValue: indexPath.section) else { return cell }
        let viewModel = SettingsViewModel(user: user, section: section)
        cell.viewModel = viewModel
        cell.delegate = self
        return cell
    }
}

//MARK: - SettingsController Delegate

extension SettingsController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SettingsSections(rawValue: section) else { return nil }
        return section.description
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SettingsSections(rawValue: indexPath.section) else { return 0 }
        if section == .ageRange {
            return 96
        } else {
            return 44
        }
    }
}





