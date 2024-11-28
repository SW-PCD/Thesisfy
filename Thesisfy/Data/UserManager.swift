import Foundation
import Combine

class UserManager: ObservableObject {
    static let shared = UserManager()
    
    @Published var userId: Int?
    @Published var email: String?
    @Published var nickname: String?
    @Published var job: String?
    
    private init() {}
}
