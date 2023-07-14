

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
class ProfileVM: ObservableObject {
    @ObservedObject var keyboard = KeyboardResponder()
    @Published var editProfile = false
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var password = ""
    @Published var studentData = [Student]()
    let loginAs = UserDefaults.standard.object(forKey: "loginAs") as? String ?? ""
    private var db = Firestore.firestore()
    func getData() {
        let email = UserDefaults.standard.object(forKey: "email") as? String ?? ""
        let tableName = (loginAs == "instructor") ? "Instructor" : "Student"
        db.collection(tableName).whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.studentData = documents.map { (queryDocumentSnapshot) -> Student in
                let data = queryDocumentSnapshot.data()
                self.firstName = data[RegistrationKeys.firstName.rawValue] as? String ?? ""
                self.lastName = data[RegistrationKeys.lastName.rawValue] as? String ?? ""
                let email = data[RegistrationKeys.email.rawValue] as? String ?? ""
                self.password = data[RegistrationKeys.password.rawValue] as? String ?? ""
                let studentID = data[RegistrationKeys.studentID.rawValue] as? String ?? ""
                let phoneNum = data[RegistrationKeys.phoneNumber.rawValue] as? String ?? ""
                let uid = data[RegistrationKeys.uid.rawValue] as? String ?? ""
                return Student(firstName: self.firstName, lastName: self.lastName, email: email, password: self.password, studentID: studentID, phoneNumber: phoneNum, uid: uid)
            }
        }
    }
}

