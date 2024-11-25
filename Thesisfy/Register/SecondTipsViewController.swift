//
//  SecondTipsViewController.swift
//  Thesisfy
//
//  Created by KKM on 10/27/24.
//

import SwiftUI

struct SecondTipsViewController: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("1. Use the search bar to find the most relevant thesisfy entries.")
                    Text("2. Use the filter bar to find the most relevant thesisfy entries.")
                    Text("3. Use the sort bar to find the most relevant thesisfy entries.")
                }
                .padding(.vertical, 16)
                
                Spacer()

                NavigationLink(destination: ThirdTipsViewController()) {
                    NextButtonView()
                }
            }
            .padding(.horizontal, 24)
            .navigationTitle(Text("Second Tips"))
            .navigationBarBackButtonHidden()
        }
    }
}

struct PreviousActivateButtonView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("이전으로")
                .font(.system(size: Constants.fontSizeM, weight: Constants.fontWeightBold))
                .foregroundColor(Constants.GrayColorWhite)
                .padding(.horizontal, Constants.fontSizeXs)
                .padding(.vertical, Constants.fontSizeM)
                .frame(maxWidth: .infinity)
                .background(Constants.PrimaryColorPrimary500)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Constants.BorderColorBorder1, lineWidth: 1)
                )
        }
    }
}

#Preview {
    SecondTipsViewController()
}
