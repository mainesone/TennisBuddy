//
//  AuthenticationViewModel.swift
//  tennislike
//
//  Created by Maik Nestler on 06.12.20.
//

import UIKit

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false &&
            password?.isEmpty == false 
    }
}

struct SignUpViewModel: AuthenticationViewModel {
    var fullname: String?
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return fullname?.isEmpty == false &&
            email?.isEmpty == false &&
            password?.isEmpty == false
    }
}
