

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Test: View {
    
//    @ObservedObject var data = DataManager()
//    @State var firstName = ""
//    @State var lastName = ""
//    @State var email = ""
//    @State var password = ""
//    @State var phoneNum = ""
//    @State var studentID = ""
//    @State var coursesNum = ""
    @ObservedObject var studentModel = StudentData()
    
    var body: some View {
        NavigationView {
//            List(studentModel.studentData) { student in
//                Text(student.email)
//            }
            //.listStyle(GroupedListStyle())
            //.navigationTitle(Text("Emails"))
        }
    }
    
    init() {
        studentModel.getData()
    }
}
//        VStack{
//            TextField("First name", text: $firstName)
//            TextField("Last name", text: $lastName)
//            TextField("Email", text: $email)
//            TextField("Password", text: $password)
//            TextField("Phone Number", text: $phoneNum)
//            TextField("Student ID", text: $studentID)
//            TextField("Courses Number", text: $coursesNum)
//
//            Button(action: {
//                data.addData(firstName: firstName, lastName: lastName, email: email, password: password, phoneNum: phoneNum, studentID: studentID, coursesNum: coursesNum)
//                firstName = ""
//                lastName = ""
//                email = ""
//                password = ""
//                phoneNum = ""
//                studentID = ""
//                coursesNum = ""
//            }) {
//                Text("Register")
//            }
//        }
    

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
            //.environmentObject()//DataManager()
    }
}
