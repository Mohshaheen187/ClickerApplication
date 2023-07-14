

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
class AttendanceVM: ObservableObject {
    @ObservedObject var keyboard = KeyboardResponder()
    @Published var bottomSheetShown = false
    @Published var courseField : Course = Course(courseProgress: 0.0, courseName: "", courseCode: "", courseDescription: "", Private: false, MCQ: [], Score: 0, totalScore: 0, lectureTime: "")
    @Published var studentData = [Student]()
    @Published var attendenceList = [Course]()
    @Published var isQuiz: Bool = false
    @Published var db = Firestore.firestore()
    @Published var allCourseList = [Course]()
    @Published var isCourseAdded : Bool = false
    @Published var documentID = ""
    @Published var studentUid = ""
    @Published var attendedStudent = [Student]()
    @Published var studentAllData = [Student]()
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
                let lastName = data[RegistrationKeys.lastName.rawValue] as? String ?? ""
                let email = data[RegistrationKeys.email.rawValue] as? String ?? ""
                let password = data[RegistrationKeys.password.rawValue] as? String ?? ""
                let studentID = data[RegistrationKeys.studentID.rawValue] as? String ?? ""
                let phoneNum = data[RegistrationKeys.phoneNumber.rawValue] as? String ?? ""
                let uid = data[RegistrationKeys.uid.rawValue] as? String ?? ""
                self.fetchAllAttendence(uid: uid)
                return Student(firstName: firstName, lastName: lastName, email: email, password: password, studentID: studentID, phoneNumber: phoneNum, uid: uid)
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
                let lectureTime = data[CourseKeys.lectureTime.rawValue] as? String ?? ""
                return Course(courseProgress: courseProgress, courseName: courseName, courseCode: courseCode, courseDescription: courseDescription, Private: Private, MCQ: quizQuestion ?? [], Score: courseScore, totalScore: totalScore, lectureTime: lectureTime)
            }
        }
    }
    func checkCourseAddedORNot(uid: String, courseName : String, student : Student) {
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
                if document.courseName == courseName{
                    self.isCourseAdded = true
                    Firestore.firestore().collection("Student").document(uid).collection("Cources").whereField("courseCode", isEqualTo: "\(self.courseField.courseCode)").getDocuments { (snapshot, err) in
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
                self.addStudentCourseInformation(uid: uid, courseName: courseName, student: student)
            }
        }
    }
    func addStudentCourseInformation(uid: String, courseName : String, student : Student){
        let userData = ["courseName": courseField.courseName, "courseCode": courseField.courseCode, "courseDescription" : courseField.courseDescription,"Private" : courseField.Private, "Score" : courseField.Score,"totalScore" : courseField.totalScore] as [String : Any]
        Firestore.firestore().collection("Student").document(uid).collection("Cources").document().setData(userData){err in
            if let err = err {
                print(err)
                return
            }
            else{
                print("success")
            }
        }
       /* viewModel.db.collection(tableName).document(viewModel.studentInfo.uid ).collection("Cources").whereField("courseCode", isEqualTo: "\(lineItem.courseCode)").getDocuments { (snapshot, err) in

            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in snapshot!.documents {
                    let documentid = document.documentID
                    viewModel.db.collection(tableName).document(viewModel.studentInfo.uid).collection("Cources").document(documentid).delete(){ err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                            viewModel.getData()
                        }
                    }
                }
                viewModel.db.collection(self.isPrivate).whereField("courseCode", isEqualTo: "\(lineItem.courseCode)").getDocuments { (snapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        
                        for document in snapshot!.documents {
                            let documentid = document.documentID
                            print(self.isPrivate)
                            viewModel.db.collection(self.isPrivate).document(documentid).delete(){ err in
                                if let err = err {
                                    print("Error removing document: \(err)")
                                } else {
                                    print("Document successfully removed!")
                                   // viewModel.getData()
                                }
                            }
                        }
                    }
                }
            }
        }*/
    }
    func deleteCourse(uid : String){
        Firestore.firestore().collection("Student").document(uid).collection("Cources").document(documentID).delete(){ err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
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
            self.attendedStudent = []
            for student in self.studentAllData{
                //attendedStudent
                Firestore.firestore().collection("Student").document(student.uid).collection("Attendence").getDocuments(){(querySnapshot, err) in
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        return
                    }
                    
                    let studentCourse = documents.map { (queryDocumentSnapshot) -> Course in
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
                    if studentCourse.count > 0{
                    self.attendedStudent.append(student)
                    }
                }
            }
        }
    }
}
