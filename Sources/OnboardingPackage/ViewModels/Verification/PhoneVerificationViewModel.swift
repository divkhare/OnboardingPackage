//
//  File.swift
//  
//
//  Created by Div Khare on 7/29/24.
//

import Foundation
import SwiftUI
import Combine

// TODO: Remove hardcoded urls, make these injectable
private extension String {
    static let validatePhoneNumberAPI = "https://www.empathdash.com/api/clients/validateVerificationSMS"
    static let sendPhoneNumberAPI = "https://www.empathdash.com/api/clients/sendVerificationSMS"
}

enum VerificationResult {
    case success
    case failure(String)
}

class PhoneVerificationViewModel: ObservableObject {
    @Published var phoneNumber = ""
    @Published var selectedCountry: Country
    @Published var isVerifying = false
    @Published var isSending = false
    @Published var messageSent = false
    @Published var verificationResult: VerificationResult?
    @Published var verificationCode = ""

    let countries: [Country] = [
        Country(name: "United States", code: "+1", flag: "🇺🇸"),
        // TODO: add more countries
    ]
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.selectedCountry = countries[0]
    }

    func sendVerificationCode() {
        isSending = true
        messageSent = false
        verificationResult = nil

        let url = URL(string: .sendPhoneNumberAPI)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "phoneNumber": phoneNumber,
            "countryCode": selectedCountry.code
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: SendVerificationResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.isSending = false
                    self.messageSent = false
                }
            } receiveValue: { response in
                self.isSending = false
                self.messageSent = true
            }
            .store(in: &cancellables)
    }

    func validateVerificationCode() {
        isSending = true
        verificationResult = nil

        let url = URL(string: .validatePhoneNumberAPI)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "phoneNumber": phoneNumber,
            "countryCode": selectedCountry.code,
            "code": verificationCode
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: ValidateVerificationResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.verificationResult = .failure(error.localizedDescription)
                    self.resetVerificationResultAfterDelay()
                }
                self.isSending = false
            } receiveValue: { response in
                if response.isValid {
                    self.verificationResult = .success
                } else {
                    self.verificationResult = .failure("Invalid verification code")
                    self.resetVerificationResultAfterDelay()
                }
            }
            .store(in: &cancellables)
    }

    private func resetVerificationResultAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.verificationResult = nil
        }
    }
}

// These structs should match your API response structure
struct SendVerificationResponse: Codable {
    // Add properties as needed
}

struct ValidateVerificationResponse: Codable {
    let isValid: Bool
}
