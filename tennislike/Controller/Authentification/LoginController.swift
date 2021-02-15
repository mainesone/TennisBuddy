//
//  LoginController.swift
//  tennislike
//
//  Created by Maik Nestler on 05.12.20.
//

import UIKit
import JGProgressHUD

protocol AuthenticationDelegate: class {
    func authenticationComplete()
}

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel = LoginViewModel()
    
    weak var delegate: AuthenticationDelegate?
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "person_1")
        return iv
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
    
    
    private let emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "E-Mail", isSecureTextEntry: false, keyboardType: .emailAddress)
    }()
    
    
    private let passwordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Passwort", isSecureTextEntry: true, keyboardType: .default)
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.tintColor = .brandingColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Du hast noch keinen Account?  ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Melde dich an", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black]))
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGradientLayer()
        dismissKeyboardTapGesture()
        configureNavigationBarHide()
        configureUI()
        configureTextFieldObservers()
    }
    
    //MARK: - Selectors
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        let hud = JGProgressHUD(style: .dark)
        // hud.textLabel.text = "Logging In"
        hud.show(in: view)
        
        AuthService.logUserIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Error logging user in \(error.localizedDescription)")
                hud.dismiss()
                return
            }
            
            hud.dismiss()
            self.delegate?.authenticationComplete()
        }
    }
    
    @objc func handleShowSignUp() {
        let signUpVC = SignUpController()
        signUpVC.delegate = delegate
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
    
    //MARK: - Helper Function
    func configureUI() {
        view.backgroundColor = .brandingColor
        
        view.addSubview(logoImageView)
        logoImageView.centerXView(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0)
        
        view.addSubview(loginButton)
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 24
        
        view.addSubview(stackView)
        stackView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
    }
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .white
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .clear
        }
    }
    
    func configureTextFieldObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}
