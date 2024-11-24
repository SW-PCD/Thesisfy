.popup(isPresented: $IsShowEditPopup) {
            editView(IsShowEditPopup: $IsShowEditPopup)
        } customize: {
            $0
                .type(.default)
                .position(.center)
                .animation(.easeInOut)
                .autohideIn(nil)
                .dragToDismiss(false)
                .closeOnTap(false) //내부 터치 방지
                .closeOnTapOutside(false) // 바깥 터치 방지
                .backgroundColor(.black.opacity(0.5))
                .isOpaque(true)
        }