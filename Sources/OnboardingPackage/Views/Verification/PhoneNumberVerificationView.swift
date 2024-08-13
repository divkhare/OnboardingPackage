//
//  PhoneNumberVerificationView.swift
//
//
//  Created by Div Khare on 7/29/24.
//

import SwiftUI

public struct PhoneNumberVerificationView: View {
    @ObservedObject private var viewModel: PhoneVerificationViewModel
    @State private var isShowingCountryPicker = false
    @State private var shouldShiver = false
    @State private var isPhoneNumberValid = true
    @State private var sendCount = 0
    @State private var isAnimating = false
    @FocusState private var isFocused: Bool

    @Environment(\.currentPage) var currentPage
    private let thisViewIndex: Int
    
    // Add a callback property
    private let onVerificationSuccess: (() -> Void)?

    public init(viewModel: PhoneVerificationViewModel, thisViewIndex: Int, onVerificationSuccess: (() -> Void)? = nil) {
        _viewModel = ObservedObject(initialValue: viewModel)
        self.thisViewIndex = thisViewIndex
        self.onVerificationSuccess = onVerificationSuccess
    }

    public var body: some View {
        VStack(spacing: 20) {
            headerView
            messageView
            phoneInputView
            informationView
            actionButton
            privacyText
        }
        .cornerRadius(10)
        .animation(.easeInOut, value: viewModel.messageSent)
        .sheet(isPresented: $isShowingCountryPicker) {
            CountryPickerView(countries: viewModel.countries, selectedCountry: $viewModel.selectedCountry)
        }
        .onChange(of: viewModel.phoneNumber) { _ in
            isPhoneNumberValid = true
        }
        .onChange(of: currentPage) { newPage in
            isAnimating = newPage == thisViewIndex
        }
        .onTapGesture {
            isFocused = false
        }
    }

    private var headerView: some View {
        Text("Verify Your Phone Number")
            .font(.largeTitle)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .fontWeight(.bold)
            .padding(.top, 50)
            .padding()
    }

    private var messageView: some View {
        Group {
            if sendCount < 5 {
                Text("We'll send you a code to verify your phone number")
            } else {
                Text("You have reached the maximum limit. Complete a verification lifecycle to proceed")
                    .foregroundStyle(.red)
            }
        }
        .font(.subheadline)
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
    }

    private var phoneInputView: some View {
        HStack {
            countryCodeButton
            phoneOrCodeTextField
        }
        .padding(.horizontal)
    }

    private var countryCodeButton: some View {
        Button(action: { isShowingCountryPicker = true }) {
            HStack {
                Text(viewModel.selectedCountry.flag)
                    .font(.title)
                Text(viewModel.selectedCountry.code)
                    .fontWeight(.medium)
            }
            .padding(10)
            .background(Color(UIColor.white))
            .cornerRadius(10)
            .opacity(viewModel.messageSent ? 0 : 1)
            .frame(width: viewModel.messageSent ? 0 : 70)
        }
        .disabled(viewModel.messageSent)
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.3), value: viewModel.messageSent)
    }

    private var phoneOrCodeTextField: some View {
        Group {
            if viewModel.messageSent {
                CustomTextField(text: $viewModel.verificationCode,
                                placeholder: "Enter code",
                                contentType: .oneTimeCode,
                                isValid: $isPhoneNumberValid)
                .focused($isFocused)
            } else {
                CustomPhoneTextField(text: $viewModel.phoneNumber,
                                     placeholder: "Enter phone number",
                                     isValid: $isPhoneNumberValid,
                                     countryCode: viewModel.selectedCountry.code)
                .focused($isFocused)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.3), value: viewModel.messageSent)
    }

    private var informationView: some View {
        VStack(spacing: 10) {
            Text("Want to keep a journal but can't find the time? Call-to-Journal lets you record your thoughts anytime, anywhere. Your recorded entries are a treasure trove of insights, helping you track your personal growth.")
                .opacity(isAnimating ? 1 : 0)
                .animation(.easeIn.delay(0.1), value: isAnimating)
            
            Text("This simple step will weave journaling seamlessly into your routine")
                .opacity(isAnimating ? 1 : 0)
                .animation(.easeIn.delay(0.3), value: isAnimating)
        }
        .font(.title2).fontWeight(.semibold)
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
    }

    private var actionButton: some View {
        Group {
            if let result = viewModel.verificationResult {
                verificationResultButton(result: result)
            } else {
                sendOrVerifyButton
            }
        }
        .fontWeight(.semibold)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding()
        .background(content: {
            switch viewModel.verificationResult {
            case .success:
                Color.green
            case .failure:
                Color.red
            case .none:
                Color.blue
            }
        })
        .cornerRadius(15)
        .padding(.horizontal)
        .offset(x: shouldShiver ? -5 : 0)
        .animation(Animation.linear(duration: 0.05).repeatCount(5, autoreverses: true), value: shouldShiver)
    }

    private func verificationResultButton(result: VerificationResult) -> some View {
        Button(action: {}) {
            switch result {
            case .success:
                Text("Verification successful!")
            case .failure(let string):
                Text("Incorrect Code: \(string)")
            }
        }
        .disabled(true)
    }

    private var sendOrVerifyButton: some View {
        Button(action: handleSendOrVerify) {
            if viewModel.isSending {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                Text(viewModel.messageSent ? "Enter Verification code" : "Send Verification SMS")
            }
        }
        .disabled(viewModel.isVerifying || sendCount >= 5)
    }

    private func handleSendOrVerify() {
        if viewModel.messageSent {
            viewModel.validateVerificationCode()
            if let _ = viewModel.verificationResult {
                onVerificationSuccess?() // Trigger the callback on success
            }
        } else if validatePhoneNumber() && sendCount < 5 {
            sendCount += 1
            viewModel.sendVerificationCode()
        } else {
            isPhoneNumberValid = false
            shouldShiver.toggle()
        }
    }

    private var privacyText: some View {
        Text("We value your privacy and trust. Please be assured that no calls are recorded or sold, and no data is collected from your interactions.")
            .font(.callout)
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .padding(.bottom, 50)
    }

    private func validatePhoneNumber() -> Bool {
        let phoneNumber = "\(viewModel.selectedCountry.code)\(viewModel.phoneNumber)"
        let phoneNumberRegex = "^[+][0-9]{10,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
}

#Preview {
    @StateObject var stateManager = OnboardingStateManager.shared

    return ZStack {
        Color.blue
        PhoneNumberVerificationView(viewModel: PhoneVerificationViewModel(), thisViewIndex: 1) {
            print("Phone number verified successfully!")
            // Add any additional logic you want to execute on verification success
        }
        .environmentObject(stateManager)
    }
}
