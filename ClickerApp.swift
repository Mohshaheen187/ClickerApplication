

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore

@main
struct ClickerApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            let email = UserDefaults.standard.object(forKey: "email") as? String ?? ""
            if email.count > 0{
                StudentPage()
            }else{
                FirstPage()
            }
        }
    }
}
