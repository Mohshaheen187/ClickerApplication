

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
enum CourseKeys: String {
    case courseProgress
    case courseName
    case courseCode
    case courseDescription
    case Private
    case uid
    case Score
    case totalScore
    case lectureTime
}
class MyCourseList: ObservableObject {
    @ObservedObject var keyboard = KeyboardResponder()
    @Published var bottomSheetShown = false
    //Information
    @Published var courseName = ""
    @Published var courseCode = ""
    @Published var courseDescription = ""
    @Published var isPrivate: Bool = false
    @Published var lectureTime = ""
    @Published var studentData = [Student]()
    @Published var courseList = [Course]()
    @Published var attendenceList = [Course]()
    @Published var studentAllData = [Student]()
    @Published var publicCourseList = [Course]()
    @Published var studentInfo : Student = Student(firstName: "", lastName: "", email: "", password: "", studentID: "", phoneNumber: "", uid: "")
    @Published var db = Firestore.firestore()
    @Published var allCourseList = [Course]()
    @Published var isCourseAdded : Bool = false
    @Published var documentID = ""
    @Published var attendedStudent = [Student]()
    func getData() {
        let email = UserDefaults.standard.object(forKey: "email") as? String ?? ""
        let loginAs = UserDefaults.standard.object(forKey: "loginAs") as? String ?? ""
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
                self.fetchAllPublicCourse(uid: uid)
                self.studentInfo = Student(firstName: firstName, lastName: lastName, email: email, password: password, studentID: studentID, phoneNumber: phoneNum, uid: uid)
                return Student(firstName: firstName, lastName: lastName, email: email, password: password, studentID: studentID, phoneNumber: phoneNum, uid: uid)
            }
            
        }
    }
    func fetchAllCourse(uid : String) {
        let loginAs = UserDefaults.standard.object(forKey: "loginAs") as? String ?? ""
        let tableName = (loginAs == "instructor") ? "Instructor" : "Student"
        //let isPrivate = (loginAs == "instructor") ? db.collection(tableName).document(uid).collection("Cources") : db.collection("Public")
        db.collection(tableName).document(uid).collection("Cources").getDocuments() { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.courseList = documents.map { (queryDocumentSnapshot) -> Course in
                let data = queryDocumentSnapshot.data()
               // print(data)
                let courseName = data[CourseKeys.courseName.rawValue] as? String ?? ""
                print(courseName)
                let courseCode = data[CourseKeys.courseCode.rawValue] as? String ?? ""
                let courseDescription = data[CourseKeys.courseDescription.rawValue] as? String ?? ""
                let Private = data[CourseKeys.Private.rawValue] as? Bool ?? false
                let courseProgress = data[CourseKeys.courseProgress.rawValue] as?
                Float ?? 0
            
                let quizQuestion = data["MCQ"] as? [quizQuestion]
                let courseScore = data[CourseKeys.Score.rawValue] as? Int ?? 0
                let totalScore = data[CourseKeys.totalScore.rawValue] as? Int ?? 0
                let lectureTime = data[CourseKeys.lectureTime.rawValue] as? String ?? ""
                return Course(courseProgress: courseProgress, courseName: courseName, courseCode: courseCode, courseDescription: courseDescription, Private: Private, MCQ: quizQuestion ?? [], Score: courseScore, totalScore: totalScore, lectureTime: lectureTime)
            }
        }
    }
    func fetchAllPublicCourse(uid : String) {
       
        db.collection("Public").getDocuments() { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.publicCourseList = documents.map { (queryDocumentSnapshot) -> Course in
                let data = queryDocumentSnapshot.data()
                let courseName = data[CourseKeys.courseName.rawValue] as? String ?? ""
                let courseCode = data[CourseKeys.courseCode.rawValue] as? String ?? ""
                let courseDescription = data[CourseKeys.courseDescription.rawValue] as? String ?? ""
                let Private = data[CourseKeys.Private.rawValue] as? Bool ?? false
                let courseProgress = data[CourseKeys.courseProgress.rawValue] as?
                Float ?? 0
            
                let quizQuestion = data["MCQ"] as? [quizQuestion]
                let courseScore = data[CourseKeys.Score.rawValue] as? Int ?? 0
                let totalScore = data[CourseKeys.totalScore.rawValue] as? Int ?? 0
                let lectureTime = data[CourseKeys.lectureTime.rawValue] as? String ?? ""
                return Course(courseProgress: courseProgress, courseName: courseName, courseCode: courseCode, courseDescription: courseDescription, Private: Private, MCQ: quizQuestion ?? [], Score: courseScore, totalScore: totalScore, lectureTime: lectureTime)
            }
        }
    }
    func fetchAllAttendence(uid : String) {
        let loginAs = UserDefaults.standard.object(forKey: "loginAs") as? String ?? ""
        let tableName = (loginAs == "instructor") ? "Instructor" : "Student"
        let isAttendence = db.collection(tableName).document(uid).collection("Attendence")
        isAttendence.getDocuments() { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.attendenceList = documents.map { (queryDocumentSnapshot) -> Course in
                let data = queryDocumentSnapshot.data()
               // print(data)
                let courseName = data[CourseKeys.courseName.rawValue] as? String ?? ""
                let courseCode = data[CourseKeys.courseCode.rawValue] as? String ?? ""
                let courseDescription = data[CourseKeys.courseDescription.rawValue] as? String ?? ""
                let Private = data[CourseKeys.Private.rawValue] as? Bool ?? false
                let courseProgress = data[CourseKeys.courseProgress.rawValue] as?
                Float ?? 0
            
                let quizQuestion = data["MCQ"] as? [quizQuestion]
                let courseScore = data[CourseKeys.Score.rawValue] as? Int ?? 0
                let totalScore = data[CourseKeys.totalScore.rawValue] as? Int ?? 0
                return Course(courseProgress: courseProgress, courseName: courseName, courseCode: courseCode, courseDescription: courseDescription, Private: Private, MCQ: quizQuestion ?? [], Score: courseScore, totalScore: totalScore, lectureTime: "")
            }
        }
    }
    func getAllStudents(){
        Firestore.firestore().collection("Student").getDocuments() { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.studentAllData = documents.map { (queryDocumentSnapshot) -> Student in
                let data = queryDocumentSnapshot.data()
                print(data)
                let firstName = data[RegistrationKeys.firstName.rawValue] as? String ?? ""
                let lastName = data[RegistrationKeys.lastName.rawValue] as? String ?? ""
                let email = data[RegistrationKeys.email.rawValue] as? String ?? ""
                let password = data[RegistrationKeys.password.rawValue] as? String ?? ""
                let studentID = data[RegistrationKeys.studentID.rawValue] as? String ?? ""
                let phoneNum = data[RegistrationKeys.phoneNumber.rawValue] as? String ?? ""
                let uid = data[RegistrationKeys.uid.rawValue] as? String ?? ""
                return Student(firstName: firstName, lastName: lastName, email: email, password: password, studentID: studentID, phoneNumber: phoneNum, uid: uid)
            }
        }
    }
    func checkCourseAddedORNot(uid: String, course : Course) {
        Firestore.firestore().collection("Student").document(uid).collection("Cources").getDocuments() { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.allCourseList = documents.map { (queryDocumentSnapshot) -> Course in
                let data = queryDocumentSnapshot.data()
               // print(data)
                let courseName = data[CourseKeys.courseName.rawValue] as? String ?? ""
                print(courseName)
                let courseCode = data[CourseKeys.courseCode.rawValue] as? String ?? ""
                let courseDescription = data[CourseKeys.courseDescription.rawValue] as? String ?? ""
                let Private = data[CourseKeys.Private.rawValue] as? Bool ?? false
                let courseProgress = data[CourseKeys.courseProgress.rawValue] as?
                Float ?? 0
                let quizQuestion = data["MCQ"] as? [quizQuestion]
                let courseScore = data[CourseKeys.Score.rawValue] as? Int ?? 0
                let totalScore = data[CourseKeys.totalScore.rawValue] as? Int ?? 0
                let lectureTime = data[CourseKeys.lectureTime.rawValue] as? String ?? ""
                return Course(courseProgress: courseProgress, courseName: courseName, courseCode: courseCode, courseDescription: courseDescription, Private: Private, MCQ: quizQuestion ?? [], Score: courseScore, totalScore: totalScore, lectureTime: lectureTime)
            }
            for document in self.allCourseList {
                if document.courseName == course.courseName{
                    self.isCourseAdded = true
                    Firestore.firestore().collection("Student").document(uid).collection("Cources").whereField("courseCode", isEqualTo: "\(course.courseCode)").getDocuments { (snapshot, err) in
                         if let err = err {
                             print("Error getting documents: \(err)")
                         } else {
                             for document in snapshot!.documents {
                                 self.documentID = document.documentID
                             }
                         }
                    }
                }
            }
            if !self.isCourseAdded{
                self.addStudentCourseInformation(uid: uid, courseField: course)
            }
        }
    }
    func addStudentCourseInformation(uid: String, courseField : Course){
        let userData = ["courseName": courseField.courseName, "courseCode": courseField.courseCode, "courseDescription" : courseField.courseDescription,"Private" : courseField.Private, "Score" : courseField.Score,"totalScore" : courseField.totalScore] as [String : Any]
        Firestore.firestore().collection("Student").document(uid).collection("Cources").document().setData(userData){err in
            if let err = err {
                print(err)
                return
            }
            else{
                print("success")
                self.getData()
            }
        }
      
    }
    func deleteCourse(uid : String){
        Firestore.firestore().collection("Student").document(uid).collection("Cources").document(documentID).delete(){ err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.getData()
            }
        }
    }
}
