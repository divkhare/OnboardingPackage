//
//  CountryPickerView.swift
//
//
//  Created by Div Khare on 8/2/24.
//

import Foundation
import SwiftUI

struct Country: Identifiable {
    let id = UUID()
    let name: String
    let code: String
    let flag: String
}

struct CountryPickerView: View {
    let countries: [Country]
    @Binding var selectedCountry: Country
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
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
