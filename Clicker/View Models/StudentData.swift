

import SwiftUI
import Firebase
import FirebaseFirestore

class StudentData: ObservableObject {
    
    @Published var studentData = [Student]()
    @Published var courseList = [Course]()
    private var db = Firestore.firestore()
    let loginAs = UserDefaults.standard.object(forKey: "loginAs") as? String ?? ""
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
                let firstName = data[RegistrationKeys.firstName.rawValue] as? String ?? ""
                ServiceManager.shared.userNameInfo = firstName
                let lastName = data[RegistrationKeys.lastName.rawValue] as? String ?? ""
                let email = data[RegistrationKeys.email.rawValue] as? String ?? ""
                let password = data[RegistrationKeys.password.rawValue] as? String ?? ""
                let studentID = data[RegistrationKeys.studentID.rawValue] as? String ?? ""
                let phoneNum = data[RegistrationKeys.phoneNumber.rawValue] as? String ?? ""
                let uid = data[RegistrationKeys.uid.rawValue] as? String ?? ""
                self.fetchAllCourse(uid: uid)
                return Student(firstName: firstName, lastName: lastName, email: email, password: password, studentID: studentID, phoneNumber: phoneNum, uid: uid)
            }
        }
    }
    func fetchAllCourse(uid : String) {
        let loginAs = UserDefaults.standard.object(forKey: "loginAs") as? String ?? ""
        let tableName = (loginAs == "instructor") ? "Instructor" : "Student"
       
        db.collection(tableName).document(uid).collection("Cources").getDocuments() { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.courseList = documents.map { (queryDocumentSnapshot) -> Course in
                let data = queryDocumentSnapshot.data()
                print(data)
                
                let courseName = data[CourseKeys.courseName.rawValue] as? String ?? ""
                let courseCode = data[CourseKeys.courseCode.rawValue] as? String ?? ""
                let courseDescription = data[CourseKeys.courseDescription.rawValue] as? String ?? ""
                let Private = data[CourseKeys.Private.rawValue] as? Bool ?? false
                let courseProgress = data[CourseKeys.courseProgress.rawValue] as?
                Float ?? 0
                let courseScore = data[CourseKeys.Score.rawValue] as? Int ?? 0
                let totalScore = data[CourseKeys.totalScore.rawValue] as? Int ?? 0
                let lectureTime = data[CourseKeys.lectureTime.rawValue] as? String ?? ""
                return Course(courseProgress: courseProgress, courseName: courseName, courseCode: courseCode, courseDescription: courseDescription, Private: Private, MCQ: [],Score: courseScore, totalScore: totalScore, lectureTime: lectureTime)
            }
            print(self.courseList)
            ServiceManager.shared.setCourseList = self.courseList
        }
    }
}
