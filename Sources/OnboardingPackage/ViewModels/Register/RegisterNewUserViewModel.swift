//
//  RegisterNewUserViewModel.swift
//  
//
//  Created by Div Khare on 7/31/24.
//

import Foundation
import Combine

public class RegisterNewUserViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var emailAddress: String = ""
    @Published var password: String = ""
    @Published var confirmedPassword: String = ""
    @Published var isEmailValid: Bool = true
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var registrationInfo: RegistrationInfo?
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
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
    
    var isFormValid: Bool {
        !name.isEmpty &&
        isEmailValid &&
        !password.isEmpty &&
        password == confirmedPassword
    }
    
    func attemptSignup() {
        guard isFormValid else {
            showErrorAlert = true
            errorMessage = "Please check your information and try again."
            return
        }
        
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.registrationInfo = RegistrationInfo(
                name: self.name,
                email: self.emailAddress,
                password: self.password
            )
            self.isLoading = false
        }
    }
}
