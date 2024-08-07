//
//  RegisterNewUserViewModel.swift
//  
//
//  Created by Div Khare on 7/31/24.
//

import Foundation
import Combine

public class RegisterNewUserViewModel: ObservableObject {
    @Published public var name: String = ""
    @Published public var emailAddress: String = ""
    @Published public var password: String = ""
    @Published public var confirmedPassword: String = ""
    @Published public var isEmailValid: Bool = true
    @Published public var showErrorAlert: Bool = false
    @Published public var errorMessage: String = ""
    @Published public var isLoading: Bool = false
    @Published public var registrationInfo: RegistrationInfo?
    private var cancellables = Set<AnyCancellable>()

    // Callback property for signup
    private var signupCallback: ((RegistrationInfo) -> Void)?

    public init(signupCallback: @escaping (RegistrationInfo) -> Void) {
        self.signupCallback = signupCallback
        setupValidation()
    }

    private func setupValidation() {
        $emailAddress
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { self.validate(email: $0) }
            .assign(to: \.isEmailValid, on: self)
            .store(in: &cancellables)
    }

    private func validate(email: String) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        return emailPred.evaluate(with: email)
    }

    public var isFormValid: Bool {
        !name.isEmpty &&
        isEmailValid &&
        !password.isEmpty &&
        password == confirmedPassword
    }

    // Method to set the signup callback
    public func setSignupCallback(_ callback: @escaping (RegistrationInfo) -> Void) {
        self.signupCallback = callback
    }

    public func attemptSignup() {
        guard isFormValid else {
            showErrorAlert = true
            errorMessage = "Please check your information and try again."
            return
        }
        
        isLoading = true
        
        let registrationInfo = RegistrationInfo(
            name: self.name,
            email: self.emailAddress,
            password: self.password
        )
        
        // Call the signup callback if it's set
        signupCallback?(registrationInfo)
        
        // Reset loading state
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}
