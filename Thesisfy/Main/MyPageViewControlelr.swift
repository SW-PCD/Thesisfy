//
//  MyPageViewControlelr.swift
//  Thesisfy
//
//  Created by KKM on 11/20/24.
//

import SwiftUI

struct MyPageViewController: View {
    var body: some View {
        VStack {
            Text("My Page Screen")
                .font(.title)
                .foregroundColor(Constants.PrimaryColorPrimary500)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    MyPageViewController()
}
