//
//  WelcomeView.swift
//
//
//  Created by Div Khare on 7/29/24.
//

import Foundation
import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("murmurLogo", bundle: .module)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.white)
                .frame(width: 100, height: 100)
            Text("Welcome to MyEmpath")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
            Text("Capture, Reflect, Connect")
                .font(.title2)
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)
            Spacer()
            FeatureCardView(
                title: "Effortless Journaling",
                description: "Speak your thoughts, type them, or snap a picture. Transcriptions make journaling a breeze!",
                backgroundColor: .green, 
                iconImage: Image(systemName: "pencil.and.scribble")
            )
            .padding(.bottom, 5)
            FeatureCardView(
                title: "Mood Analysis",
                description: "Track your mood with our insightful mood charts. Understand your emotional patterns better.",
                backgroundColor: .blue, 
                iconImage: Image(systemName: "chart.xyaxis.line")
            )
            .padding(.bottom, 5)
            FeatureCardView(
                title: "Call to Journal",
                description: "Simply call to journal your day. It's quick, easy, and perfect for capturing spontaneous thoughts.",
                backgroundColor: .red, 
                iconImage: Image(systemName: "phone.fill")
            )
            .padding(.bottom)
            Spacer()
        }
        .padding([.leading, .trailing], 10)
    }
}

struct FeatureCardView: View {
    let title: String
    let description: String
    let backgroundColor: Color
    let iconImage: Image
    
    var body: some View {
        ZStack {
            HStack(spacing: 2) {
                iconImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .padding(.leading)
                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            .frame(width: .infinity)
            .background(Color.white.opacity(0.9))
            .cornerRadius(10)
            .shadow(radius: 5)
            .overlay {
                backgroundColor.opacity(0.2)
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue
            WelcomeView()
        }
    }
}
