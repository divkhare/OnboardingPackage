//
//  PhoneNumberVerificationView.swift
//
//
//  Created by Div Khare on 7/29/24.
//

import SwiftUI

struct PhoneNumberVerificationView: View {
    @StateObject private var viewModel = PhoneVerificationViewModel()
    @State private var isShowingCountryPicker = false
    @State private var shouldShiver = false
    @State private var isPhoneNumberValid = true
    @State private var sendCount = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("Verify Your Phone Number")
                .font(.largeTitle)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .fontWeight(.bold)
                .padding(.top, 10)

            VStack(spacing: 10) {
                if sendCount < 5 {
                    Text("We'll send you a code to verify your phone number")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                } else {
                    Text("You have reached the maximum limit, Complete a verification lifecycle to proceed")
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                HStack {
                    Button(action: {
                        isShowingCountryPicker = true
                    }) {
                        HStack {
                            Text(viewModel.selectedCountry.flag)
                                .font(.title)
                            Text(viewModel.selectedCountry.code)
                                .fontWeight(.medium)
                        }
                        .padding(10)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .opacity(viewModel.messageSent ? 0 : 1)
                        .frame(width: viewModel.messageSent ? 0 : .infinity)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.3), value: viewModel.messageSent)
                    }
                    .disabled(viewModel.messageSent)
                    CustomTextField(text: viewModel.messageSent ? $viewModel.verificationCode : $viewModel.phoneNumber,
                                    placeholder: viewModel.messageSent ? "Enter code" : "Enter phone number",
                                    contentType: viewModel.messageSent ? .oneTimeCode : .telephoneNumber,
                                    isValid: $isPhoneNumberValid)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.3), value: viewModel.messageSent)
                }
                .padding(.horizontal)
            }
            
            VStack(spacing: 10) {
                Text("Want to keep a journal but can't find the time? Call-to-Journal lets you record your thoughts anytime, anywhere. Your recorded entries are a treasure trove of insights, helping you track your personal growth and recognize patterns over time.")
            }
            .font(.subheadline)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            if let result = viewModel.verificationResult {
                    Button(action: {}) {
                        switch result {
                        case .success:
                            Text("Verification successful!")
                                .foregroundColor(.green)
                        case .failure:
                            Text("Incorrect Code")
                        }
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.5))
                    .cornerRadius(15)
                    .disabled(true)
                    .padding(.horizontal)
                    .offset(x: shouldShiver ? -5 : 0)
                    .animation(
                        Animation.linear(duration: 0.05)
                            .repeatCount(5, autoreverses: true),
                        value: shouldShiver
                    )
                    .onAppear {
                        shouldShiver = true
                    }
            } else {
                Button(action: {
                    if viewModel.messageSent {
                        viewModel.validateVerificationCode()
                        return
                    }

                    if validatePhoneNumber() && sendCount < 5 {
                        sendCount += 1
                        viewModel.sendVerificationCode()
                    } else {
                        isPhoneNumberValid = false
                        shouldShiver = !shouldShiver
                    }
                }) {
                    if viewModel.isSending {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else if !viewModel.isSending && viewModel.messageSent {
                        Text("Enter verification code")
                    } else {
                        Text("Send verification SMS")
                    }
                }
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.brightness(0.1))
                .cornerRadius(15)
                .disabled(viewModel.isVerifying || sendCount >= 5)
                .padding(.horizontal)
                .offset(x: !shouldShiver ? 0 : -5)
                .animation(
                    Animation.linear(duration: 0.05)
                        .repeatCount(5, autoreverses: true),
                    value: !shouldShiver
                )
            }

            if viewModel.messageSent {
                Text("Message sent to \(viewModel.selectedCountry.code)\(viewModel.phoneNumber)")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Text("We value your privacy and trust. Please be assured that no calls are recorded or sold, and no data is collected from your interactions.")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom, 10)
        }
        .background(.black.opacity(0.2))
        .cornerRadius(10)
        .padding(5)
        .animation(.easeInOut, value: viewModel.messageSent)
        .sheet(isPresented: $isShowingCountryPicker) {
            CountryPickerView(countries: viewModel.countries, selectedCountry: $viewModel.selectedCountry)
        }
        .onChange(of: viewModel.phoneNumber) { _ in
            isPhoneNumberValid = true
        }
    }

    private func validatePhoneNumber() -> Bool {
        let phoneNumber = "\(viewModel.selectedCountry.code)\(viewModel.phoneNumber)"
        let phoneNumberRegex = "^[+][0-9]{10,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
}

struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String
    var contentType: UITextContentType = .telephoneNumber
    @Binding var isValid: Bool
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isValid ? Color.gray.opacity(0.3) : Color.red, lineWidth: 2)
            )
            .textContentType(contentType)
            .scrollDismissesKeyboard(.immediately)
            .keyboardType(.namePhonePad)
    }
}

struct CountryPickerView: View {
    let countries: [Country]
    @Binding var selectedCountry: Country
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List(countries) { country in
                Button(action: {
                    selectedCountry = country
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text(country.flag)
                        Text(country.name)
                        Spacer()
                        Text(country.code)
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationTitle("Select Country")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct Country: Identifiable {
    let id = UUID()
    let name: String
    let code: String
    let flag: String
}

struct PhoneNumberVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
            PhoneNumberVerificationView()
        }
    }
}
