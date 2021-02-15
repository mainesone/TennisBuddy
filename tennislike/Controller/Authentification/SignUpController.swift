//
//  SignupController.swift
//  tennislike
//
//  Created by Maik Nestler on 05.12.20.
//

import UIKit
import JGProgressHUD

class SignUpController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel = SignUpViewModel()
    
    weak var delegate: AuthenticationDelegate?
    
    private var profileImage: UIImage?
    
    private let imagePicker = UIImagePickerController()
    
    private let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "addPhoto"), for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(image: SFSymbols.mail!, textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().inputContainerView(image: SFSymbols.password!, textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let view = UIView().inputContainerView(image: SFSymbols.fullName!, textField: fullNameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "E-Mail", isSecureTextEntry: false, keyboardType: .emailAddress)
    }()
    
    private let passwordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Passwort", isSecureTextEntry: true, keyboardType: .default)
      
    }()
    
    private let fullNameTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Vor- und Nachname", isSecureTextEntry: false, keyboardType: .default)
      
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Anmelden", for: .normal)
        button.tintColor = .brandingColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Du hast bereits einen Account?  ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Jetzt anmelden", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black]))
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        dismissKeyboardTapGesture()
        configureTextFieldObservers()
    }
    
    //MARK: - Selectors
    @objc func handleAddPhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleSignup() {
        guard let email = emailTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let profileImage = profileImage else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: view)
        
        let credentials = AuthCredentials(email: email, password: password,
                                          fullname: fullname, profileImage: profileImage)

        AuthService.registerUser(withCredentials: credentials) { error in
            if let error = error {
                print("DEBUG: Error signing user up \(error.localizedDescription)")
                hud.dismiss()
                return
            }
            
            hud.dismiss()
            self.delegate?.authenticationComplete()
        }
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == fullNameTextField {
            viewModel.fullname = sender.text
        } else if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
    
    //MARK: - Functions
    
    func configureUI() {
        configureGradientLayer()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
         
        view.addSubview(addPhotoButton)
        addPhotoButton.centerXView(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0)
        addPhotoButton.setDimensions(height: 200, width: 200)
         
        view.addSubview(signUpButton)
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
         
         
        let stackView = UIStackView(arrangedSubviews: [fullNameContainerView, emailContainerView, passwordContainerView, signUpButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 24
         
        view.addSubview(stackView)
        stackView.anchor(top: addPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
         
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
     }
    
    func configureTextFieldObservers() {
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .white
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = .clear
        }
    }
}

//MARK: - ImagePicker Delegate

extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.originalImage] as? UIImage else { return }
        self.profileImage = profileImage
        addPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        addPhotoButton.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        addPhotoButton.layer.borderWidth = 3
        addPhotoButton.layer.cornerRadius = 10
        addPhotoButton.imageView?.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
}
