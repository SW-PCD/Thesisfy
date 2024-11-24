//
//  TipsViewController.swift
//  Thesisfy
//
//  Created by KKM on 10/27/24.
//

import SwiftUI

struct FirstTipsViewController: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("1. Use the search bar to find the most relevant information.")
                    Text("2. Use the sidebar to explore different categories.")
                    Text("3. Use the filters to refine your search results.")
                    Text("4. Use the bookmarks to save your favorite information.")
                }
                .padding(.vertical, 16)
                
                Spacer()
                
                NavigationLink(destination: SecondTipsViewController()) {
                    NextButtonView()
                }
            }
            .navigationTitle(Text("First Tips"))
            .padding(.horizontal, 24)
        }
        .navigationBarBackButtonHidden()
    }
}

struct PreviousButtonView: View {
    var body: some View {
        Text("이전으로")
            .font(.system(size: Constants.fontSizeM, weight: Constants.fontWeightBold))
            .foregroundColor(Constants.GrayColorWhite)
            .padding(.horizontal, Constants.fontSizeXs)
            .padding(.vertical, Constants.fontSizeM)
            .frame(maxWidth: .infinity)
            .background(Constants.PrimaryColorPrimary100)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Constants.BorderColorBorder1, lineWidth: 1)
            )
    }
}


#Preview {
    FirstTipsViewController()
}
