//
//  StudentPage.swift
//  Clicker
//
//  Created by Mohammed Shaheen on 16/04/2022.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import simd
import Combine
struct StudentPage: View {
    
    @State var color = Color.black.opacity(0.7)
    @State var selectedTab : Int = 0
    @ObservedObject var viewModel: MyCourseList = MyCourseList()
    @ObservedObject var attendanceVM: AttendanceVM = AttendanceVM()
    @ObservedObject var profileVM: ProfileVM = ProfileVM()
    @State var visible = false
    @State var passwordStatus = ""
    @State var dropDownList = ["MCQ","Polls","Essay"]
    @State var value = "MCQ"
    @State var placeholder = "Question Type"
    @State var quizDuration = "30:00"
    @State var numOfQuestions = 1
    @State var selectedBank = Question.testBank.rawValue
    let loginAs = UserDefaults.standard.object(forKey: "loginAs") as? String ?? ""
    @State var error: ErrorView?
    @State var studentData = [Student]()
    @State var selectedName: String? = nil
    @State var selectedCourse: String? = nil
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeRedirectPage()
                .tabItem{
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            MyCourses(viewModel: self.viewModel, attendanceVM: attendanceVM)
                .tabItem{
                    Image(systemName: "newspaper.fill")
                    Text("My Courses")
                }
                .tag(1)
            
            StudentAttendance(attendanceVM: attendanceVM)
                .tabItem{
                    Image(systemName: "person.circle.fill")
                    Text("Attendance")
                }
                .tag(2)
            
            Settings(viewModel: profileVM)
                .tabItem{
                    Image(systemName: "gear.circle.fill")
                    Text("Settings")
                }
                .tag(3)
        } .bottomSheet(
            isPresented: $viewModel.bottomSheetShown,
            height: UIScreen.main.bounds.height,
            topBarHeight: 15,
            topBarCornerRadius: 20,
            showTopIndicator: false
        ) {
            let loginAs = UserDefaults.standard.object(forKey: "loginAs") as? String ?? ""
            if (loginAs == "instructor") {
                AddMyCourseView
            }else{
                AddPublicCourseToStudent
            }
        }
        .bottomSheet(
            isPresented: $profileVM.editProfile,
            height: UIScreen.main.bounds.height,
            topBarHeight: 15,
            topBarCornerRadius: 20,
            showTopIndicator: false
        ) {
            EditProfileView
        }
        .bottomSheet(
            isPresented: $attendanceVM.bottomSheetShown,
            height: UIScreen.main.bounds.height,
            topBarHeight: 15,
            topBarCornerRadius: 20,
            showTopIndicator: false
        ) {
            if attendanceVM.isQuiz{
                CreateQuizView
            }else{
                AddStudent
            }
        }
        .onAppear{
            viewModel.getData()
            viewModel.getAllStudents()
            attendanceVM.getData()
            attendanceVM.getAllStudents()
        }
        .alert(item: $error, content: { error in
            Alert(
                title: Text(error.title),
                message: Text(error.description))
        })
    }
    var AddPublicCourseToStudent: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                Spacer()
                Text("Add Public Course")
                    .foregroundColor(Color("Color"))
                    .fontWeight(.bold)
                    .font(.system(size: 22))
                Spacer()
            }.overlay(
                Button{
                    selectedCourse = ""
                    viewModel.bottomSheetShown = false
                    self.endEditing(true)
                }label:{
                    Image(systemName: "multiply")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .padding(.trailing,15)
                },alignment: .trailing
            ).padding(.bottom,5)
            Divider()
            List {
                ForEach(viewModel.publicCourseList, id: \.self) { course in
                    Button {
                        selectedCourse = course.courseName
                        self.viewModel.checkCourseAddedORNot(uid: self.viewModel.studentInfo.uid, course: course)
                    } label: {
                        HStack {
                            Text(course.courseName)
                            Spacer()
                            if course.courseName == selectedCourse {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                    .foregroundColor(Color.black)
                    .alert("Course is already added. are you delete course", isPresented: $viewModel.isCourseAdded) {
                        Button("YES") {self.viewModel.deleteCourse(uid: self.viewModel.studentInfo.uid) }
                        Button("NO") { }
                    }
                }
            }
            Spacer()
        }.padding(.bottom)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut(duration: 0.16))
    }
    var AddStudent: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                Spacer()
                Text("Add Student")
                    .foregroundColor(Color("Color"))
                    .fontWeight(.bold)
                    .font(.system(size: 22))
                Spacer()
            }.overlay(
                Button{
                    selectedName = ""
                    attendanceVM.bottomSheetShown = false
                    self.endEditing(true)
                }label:{
                    Image(systemName: "multiply")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .padding(.trailing,15)
                },alignment: .trailing
            ).padding(.bottom,5)
            Divider()
            List {
                ForEach(viewModel.studentAllData, id: \.self) { student in
                     
                    Button {
                        self.attendanceVM.studentUid = student.uid
                        self.selectedName = student.firstName + " " + student.lastName
                        self.attendanceVM.checkCourseAddedORNot(uid: student.uid, courseName: self.attendanceVM.courseField.courseName, student: student)
                    
                    } label: {
                        HStack {
                            Text(student.firstName + " " + student.lastName)
                            Spacer()
                            if student.firstName + " " + student.lastName == selectedName {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                    .foregroundColor(Color.black)
                    .alert("Course is already added for this student. are you delete course for this student?", isPresented: $attendanceVM.isCourseAdded) {
                        Button("YES") {self.attendanceVM.deleteCourse(uid: self.attendanceVM.studentUid) }
                        Button("NO") { }
                    }
                }
            }
            Spacer()
        }.padding(.bottom)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut(duration: 0.16))
    }
    var AddMyCourseView: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                Spacer()
                Text("Course Detail")
                    .fontWeight(.bold)
                    .font(.system(size: 22))
                Spacer()
            }.overlay(
                Button{
                    viewModel.bottomSheetShown = false
                    self.endEditing(true)
                }label:{
                    Image(systemName: "multiply")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .padding(.trailing,15)
                },alignment: .trailing
            ).padding(.bottom,5)
            Divider()
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading, spacing: 12){
                    TextField("Course Name", text: $viewModel.courseName)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.viewModel.courseName != "" ? Color("Color") : self.color, lineWidth: 2))
                        .autocapitalization(.none)
                    
                    TextField("Course Code", text: $viewModel.courseCode)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.viewModel.courseCode != "" ? Color("Color") : self.color, lineWidth: 2))
                        .autocapitalization(.none)
                    TextField("Course Description", text: $viewModel.courseDescription)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.viewModel.courseDescription != "" ? Color("Color") : self.color, lineWidth: 2))
                        .autocapitalization(.none)
                    TextField("Lecture Time", text: $viewModel.lectureTime)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.viewModel.lectureTime != "" ? Color("Color") : self.color, lineWidth: 2))
                        .autocapitalization(.none)
                    Toggle(isOn: $viewModel.isPrivate) {
                        Text("Private")
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                    }
                    .toggleStyle(SwitchToggleStyle(tint: Color("Color")))
                    .padding(.trailing,5)
                    HStack{
                        Spacer()
                        Button(action: {
                            print("Course added")
                            storeCourseInformation()
                            viewModel.bottomSheetShown = false
                            viewModel.getData()
                            
                        }) {
                            Text("Add Course")
                                .foregroundColor(Color("Color"))
                                .fontWeight(.bold)
                                .font(.system(size: 22))
                        }
                        Spacer()
                    }
                }.padding(20)
                
                Spacer()
            }.padding(.bottom,10)
        }.padding(.bottom)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut(duration: 0.16))
    }
    var EditProfileView: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                Spacer()
                Text("Edit Your Information")
                    .foregroundColor(Color("Color"))
                    .fontWeight(.bold)
                    .font(.system(size: 22))
                Spacer()
            }.overlay(
                Button{
                    profileVM.editProfile = false
                    self.endEditing(true)
                }label:{
                    Image(systemName: "multiply")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .padding(.trailing,15)
                },alignment: .trailing
            ).padding(.bottom,5)
            Divider()
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading, spacing: 12){
                    TextField("First Name", text: $profileVM.firstName)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.profileVM.firstName != "" ? Color("Color") : self.color, lineWidth: 2))
                        .autocapitalization(.none)
                    
                    TextField("Last Name", text: $profileVM.lastName)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.profileVM.lastName != "" ? Color("Color") : self.color, lineWidth: 2))
                        .autocapitalization(.none)
                    ZStack(alignment: .trailing){
                        VStack(alignment: .leading){
                            if self.visible {
                                TextField("Enter your password", text: $profileVM.password)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.profileVM.password != "" ? Color("Color") : self.color, lineWidth: 2))
                                    .autocapitalization(.none)
                            } else {
                                SecureField("Enter your password", text: $profileVM.password)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.profileVM.password != "" ? Color("Color") : self.color, lineWidth: 2))
                                    .autocapitalization(.none)
                            }
                            if passwordStatus == "Strong" {
                                Text("\(passwordStatus)")
                                    .foregroundColor(Color.green)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            } else {
                                Text("\(passwordStatus)")
                                    .foregroundColor(Color.red)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            }
                        }
                        Button(action: {
                            self.visible.toggle()
                        }) {
                            Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                        }
                        .padding()
                        .foregroundColor(self.color)
                    }
                    HStack{
                        Spacer()
                        Button(action: {
                            let tableName = (loginAs == "instructor") ? "Instructor" : "Student"
                            Firestore.firestore().collection(tableName).document(viewModel.studentInfo.uid).updateData(["firstName":profileVM.firstName,"lastName" : profileVM.lastName,"password" : profileVM.password]){err in
                                if let err = err {
                                    print(err)
                                    return
                                }else{
                                    print("update")
                                }
                            }
                            checkStrength()
                            if passwordStatus == "Strong" {
                                profileVM.editProfile = false
                            }
                        }) {
                            Text("Submit")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .padding(.vertical,8)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Color"))
                        )
                        Spacer()
                    }
                    .padding(.top)
                }.padding(20)
                
                Spacer()
            }.padding(.bottom,10)
        }.padding(.bottom)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut(duration: 0.16))
    }
    func checkStrength() {
        
        var containsSymbol = false
        var containsUpperCase = false
        
        for character in self.profileVM.password {
            if "ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(character) {
                containsUpperCase = true
            }
            
            if "!@#$%^&*-_.".contains(character) {
                containsSymbol = true
            }
        }
        if profileVM.password.count > 8 && containsSymbol && containsUpperCase {
            passwordStatus = "Strong"
        } else {
            passwordStatus = "Weak"
        }
    }
    //Save data to Firestore
    func storeCourseInformation() {
        let loginAs = UserDefaults.standard.object(forKey: "loginAs") as? String ?? ""
        let tableName = (loginAs == "instructor") ? "Instructor" : "Student"
        let userData = ["courseName": self.viewModel.courseName, "courseCode": self.viewModel.courseCode, "courseDescription" : self.viewModel.courseDescription,"Private" : self.viewModel.isPrivate, "lectureTime" : self.viewModel.lectureTime] as [String : Any]
        Firestore.firestore().collection(tableName).document(viewModel.studentInfo.uid).collection("Cources").document().setData(userData){err in
            if let err = err {
                print(err)
                return
            }
            let isPrivate = self.viewModel.isPrivate ? "Private" : "Public"
            Firestore.firestore().collection(isPrivate)
                .document().setData(userData) { err in
                    if let err = err {
                        print(err)
                        return
                    }
                }
        }
    }
    var CreateQuizView: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                Spacer()
                Text("Create a Quiz")
                    .foregroundColor(Color("Color"))
                    .fontWeight(.bold)
                    .font(.system(size: 22))
                Spacer()
            }.overlay(
                Button{
                    attendanceVM.bottomSheetShown = false
                    self.endEditing(true)
                }label:{
                    Image(systemName: "multiply")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .padding(.trailing,15)
                },alignment: .trailing
            ).padding(.bottom,5)
            Divider()
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading, spacing: 20){
                    HStack{
                        Text("Quiz Type:")
                            .fontWeight(.bold)
                        Spacer()
                        dropdownListHeader
                    }
                    HStack{
                        Text("Quiz Duration:")
                            .fontWeight(.bold)
                        Spacer()
                            TextField("00:00:00", text: $quizDuration)
                            .font(Font.system(size: 20, weight: .bold, design: .rounded))
                            /*.onChange(of: quizDuration) {
                                print($0)
                                if $0.count == 2{
                                    quizDuration = quizDuration + ":"
                                }else if $0.count == 5{
                                    quizDuration = quizDuration + ":"
                                }
                            }*/
                            .onReceive(Just(quizDuration)) { _ in limitText(&quizDuration, 8) }
                            .multilineTextAlignment(.trailing)
                    }
                    HStack{
                        Text("Number of Questions:")
                            .fontWeight(.bold)
                        Spacer()
                        HStack{
                            Button {
                                numOfQuestions = numOfQuestions + 1
                            } label: {
                                Text("+")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(5)
                            }.background(.blue)
                            
                            Text("\(numOfQuestions)")
                                .fontWeight(.bold)
                            
                            Button {
                                if numOfQuestions > 1{
                                    numOfQuestions = numOfQuestions - 1
                                }
                            } label: {
                                Text("-")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(5)
                            }.background(.blue)
                            
                        }
                    }
                    HStack{
                        Text("Total Grade:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(numOfQuestions)")
                            .fontWeight(.bold)
                    }
                    Text("Please Select Test Bank or New Quetions:")
                        .font(Font.headline)
                    RadioButtonGroups { selected in
                        selectedBank = selected
                    }
                    HStack{
                        Spacer()
                        Button(action: {
                            print("Start")
                            if quizDuration.count > 0{
                                setData()
                            }else{
                                error = ErrorView(id: 5, title: "", description: "Please Add time duration")
                                
                            }
                        }) {
                            Text("Start")
                                .foregroundColor(Color("Color"))
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .padding(.vertical,8)
                        }
                        Spacer()
                    }
                    .padding(.top)
                }.padding(20)
                
                Spacer()
            }.padding(.bottom,10)
        }.padding(.bottom)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut(duration: 0.16))
    }
    func setData() {
        let isPrivate = ServiceManager.shared.courseDetail.Private ? "Private" : "Public"
        let loginAs = UserDefaults.standard.object(forKey: "loginAs") as? String ?? ""
        let tableName = (loginAs == "instructor") ? "Instructor" : "Student"
        
        Firestore.firestore().collection(isPrivate).whereField("courseCode", isEqualTo: ServiceManager.shared.courseDetail.courseCode).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    let documentid = document.documentID
                    let userData = ["quizType": value, "quizDuration": quizDuration, "Questions" : numOfQuestions,"grades" : numOfQuestions, "bankType" : selectedBank, "currentTime" : Date()] as [String : Any]
                    Firestore.firestore().collection(isPrivate).document(documentid).collection("quizeCreated").document().setData(userData){err in
                        if let err = err {
                            print(err)
                            return
                        }else{
                            print("sdfdsf")
                        }
                    }
                }
            }
        }
        Firestore.firestore().collection(tableName).document(viewModel.studentInfo.uid).collection("Cources").whereField("courseCode", isEqualTo: ServiceManager.shared.courseDetail.courseCode).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    let documentid = document.documentID
                    let userData = ["quizType": value, "quizDuration": quizDuration, "Questions" : numOfQuestions,"grades" : numOfQuestions, "bankType" : selectedBank, "currentTime" : Date()] as [String : Any]
                    Firestore.firestore().collection(tableName).document(viewModel.studentInfo.uid).collection("Cources").document(documentid).collection("quizeCreated").document().setData(userData){err in
                        if let err = err {
                            print(err)
                            return
                        }else{
                            print("sdfdsf")
                        }
                    }
                }
            }
        }
    }
    private var dropdownListHeader: some View {
        HStack(spacing: 10){
            Menu {
                ForEach(dropDownList, id: \.self){ client in
                    Button(client) {
                        self.value = client
                    }
                }
            } label: {
                VStack{
                    HStack(spacing: 15){
                        Text(value.isEmpty ? placeholder : value)
                            .foregroundColor(value.isEmpty ? .gray : .black)
                            .fontWeight(.medium)
                       
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color.black.opacity(0.6))
                            .font(Font.system(size: 15, weight: .bold))
                    }
                    .padding(.horizontal,5)
                }
                .padding(10)
            }
        }.border(.gray)
        .pickerStyle(.menu)
    }
}

struct StudentPage_Previews: PreviewProvider {
    static var previews: some View {
        StudentPage()
    }
}

var publicCourses = ["CS116", "CS316", "CS415"]
var privateCourses = ["ENE201", "ARB100", "MLS101"]
func limitText(_ stringvar: inout String, _ limit: Int) {
    if (stringvar.count > limit) {
        stringvar = String(stringvar.prefix(limit))
    }
}
