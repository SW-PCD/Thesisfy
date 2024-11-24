//
//  TermsAgreementViewController.swift
//  Thesisfy
//
//  Created by KKM on 10/27/24.
//

import SwiftUI

struct TermsAgreementViewController: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showModal = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    Text("회원가입")
                        .font(.system(size: Constants.fontSizeXl, weight: Constants.fontWeightSemibold))
                        .foregroundColor(Constants.GrayColorGray900)
                    
                    Spacer()
                    
                    Image("")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                
                Spacer()
                
                Text("약관 동의 추후 제작")
                
                Spacer()
                
                Button {
                    showModal = true
                } label: {
                    NextButtonView()
                }
                .sheet(isPresented: $showModal) {
                    FirstTipsViewController()
                }
            }
            .padding(.horizontal, 24)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    TermsAgreementViewController()
}
