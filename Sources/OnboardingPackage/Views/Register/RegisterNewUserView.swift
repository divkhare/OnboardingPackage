//
//  RegisterNewUserView.swift
//
//
//  Created by Div Khare on 7/31/24.
//

import SwiftUI

public struct RegisterNewUserView: View {
    @ObservedObject var viewModel: RegisterNewUserViewModel
    @FocusState private var focusedField: Bool
    private let thisViewIndex: Int

    public init(viewModel: RegisterNewUserViewModel, thisViewIndex: Int) {
        _viewModel = ObservedObject(initialValue: viewModel)
        self.thisViewIndex = thisViewIndex
    }

    public var body: some View {
            VStack(spacing: 10) {
                headerView
                ScrollView {
                    VStack(spacing: 5) {
                        customTextField(title: "Name", text: $viewModel.name, placeholder: "Enter your name")
                            .focused($focusedField)
                        
                        customTextField(title: "Email", text: $viewModel.emailAddress, placeholder: "Enter your email")
                            .keyboardType(.emailAddress)
                            .focused($focusedField)
                        if !viewModel.isEmailValid && !viewModel.emailAddress.isEmpty {
                            Text("Please enter a valid email address")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        customSecureField(title: "Password", text: $viewModel.password, placeholder: "Enter your password")
                            .focused($focusedField)
                        
                        customSecureField(title: "Confirm Password", text: $viewModel.confirmedPassword, placeholder: "Confirm your password")
                            .focused($focusedField)
                        if viewModel.password != viewModel.confirmedPassword {
                            Text("Passwords do not match")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                }
                signupButton
                Spacer()
            }
            .padding()
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
        .onTapGesture {
            focusedField = false
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = false
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack {
            Text("Create Account")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 50)
            Text("Join us and start your journey")
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
        .padding()
    }
    
    private func customTextField(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline).bold()
                .foregroundColor(.white)
            TextField(placeholder, text: text)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .foregroundColor(.black)
                .submitLabel(.next)
        }
    }
    
    private func customSecureField(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            SecureField(placeholder, text: text)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .foregroundColor(.black)
                .submitLabel(.next)
        }
    }
    
    private var signupButton: some View {
        Button(action: viewModel.attemptSignup) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(viewModel.isFormValid ? Color.blue : Color.gray)
                    .frame(height: 50)
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                } else {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }
            .padding()
            .padding(.bottom, 10)
        }
        .disabled(!viewModel.isFormValid || viewModel.isLoading)
    }
}

struct RegisterNewUserView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
//            RegisterNewUserView(viewModel: RegisterNewUserViewModel(signupCallback: ))
        }
        .ignoresSafeArea()
    }
}
