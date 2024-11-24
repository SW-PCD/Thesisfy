import SwiftUI
import PopupView

struct TestView: View {
    @State private var showPopup = false

    var body: some View {
        VStack {
            Button("Show Popup") {
                showPopup = true
            }
        }
        .popup(isPresented: $showPopup, alignment: .bottom) {
            VStack {
                Text("This is a popup sheet!")
                    .font(.headline)
                    .padding()
                Button("Close") {
                    showPopup = false
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
