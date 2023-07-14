

import SwiftUI
import Firebase
import FirebaseFirestore
struct StudentAttendanceDetail : View {
    @State var errorView: ErrorsHandling?
    @State private var showingAlert = false
    @ObservedObject var attendanceVM: AttendanceVM
    @State var isNavigate : Bool = false
    var courseField : Course
    let loginAs = UserDefaults.standard.object(forKey: "loginAs") as? String ?? ""
    @State var isTestBank = false
    @State var testBankData = [QuizModel]()
    @State var score = 0
    @State var scoreOutOf = ""
    @ObservedObject var viewModel: MyCourseList
    @State var quizCreatedList = [QuizCreatedModel]()
    var body: some View{
        ScrollView(.vertical){
            VStack{
                Text(courseField.courseName)
                Text(courseField.courseCode)
                Text(courseField.courseDescription)
                VStack(spacing: 20){
                    if loginAs == "student"{
                        HStack{
                            Button(action: {
                                errorView = ErrorsHandling(id: 0, title: "Grades", message: scoreOutOf)
                                print("Grade")
                            }) {
                                Text("Grades")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                    .padding(.vertical,8)
                                    .onAppear(){ //refresh score
                                        self.score = LoadScore(quiz: "myQuiz1")
                                    }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("Color"))
                            ).alert(item: $errorView, content: { error in
                                Alert(
                                    title: Text(error.title),
                                    message: Text(error.message)
                                )
                            })
                            Spacer()
                            Button(action: {
                                print("Attendance")
                                showingAlert = true
                            }) {
                                Text("Attendance")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                    .padding(.vertical,8)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("Color"))
                            )
                            .alert(isPresented:$showingAlert) {
                                Alert(
                                    title: Text("Attendance"),
                                    message: Text("Attendance"),
                                    primaryButton: .default(Text("Here")) {
                                        
                                        let startTime = courseField.lectureTime.components(separatedBy: "-").first
                                        let endTime = courseField.lectureTime.components(separatedBy: "-").last
                                        
                                        if CheckTimeExist(startTime: dateTimeDifference(time: startTime ?? ""), endTime: dateTimeDifference(time: endTime ?? "")){
                                            addAttendanceItems()
                                        }else{
                                            errorView = ErrorsHandling(id: 0, title: "Attendence", message: "You can not attend this course because it time is \(courseField.lectureTime)")
                                        }
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                        }.padding(.vertical)}
                    if loginAs == "instructor"{
                        Button(action: {
                            attendanceVM.isQuiz = true
                            attendanceVM.bottomSheetShown = true
                        }) {
                            Text(loginAs == "instructor" ? "Create Quiz" : "Quizes")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .padding(.vertical,8)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("Color"))
                        )
                    }else{
                        NavigationLink(destination: Quiz1(testBankData: self.testBankData, courseField: courseField, viewModel: viewModel), isActive: $isNavigate) {
                            Button(action: {
                                if self.quizCreatedList.count > 0{
                                isNavigate = true
                                }else{
                                    errorView = ErrorsHandling(id: 0, title: "Quiz", message: "Quiz not created by instructor")
                                }
                            }) {
                                Text("Quizes")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                    .padding(.vertical,8)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("Color"))
                            )
                        }
                    }
                }
                .padding(.top)
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(action: {
                    attendanceVM.isCourseAdded = false
                    attendanceVM.courseField = courseField
                    attendanceVM.isQuiz = false
                    attendanceVM.bottomSheetShown = true
                }) {
                    Text(loginAs == "instructor" ? "Add Student" : "")
                        .opacity(loginAs == "instructor" ? 1 : 0)
                        .disabled(loginAs == "instructor" ? false : true)
                }
            )
        }
        .onAppear{
            checkQuizeCreated()
            getData()
            ServiceManager.shared.courseDetailInfo = courseField
            scoreOutOf = ""
            for number in 0..<ServiceManager.shared.courseList.count {
                scoreOutOf = scoreOutOf + "Quiz : \(ServiceManager.shared.courseList[number].Score) out of \(ServiceManager.shared.courseList[number].totalScore)\n"
            }
        }
    }
    func dateTimeDifference(time : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"

        let date = dateFormatter.date(from: time )
        dateFormatter.dateFormat = "HH:mm"

        let Date24 = dateFormatter.string(from: date ?? Date())
        print("24 hour formatted Date:",Date24)
        return Date24
    }
    func CheckTimeExist(startTime : String , endTime : String)->Bool{

    var timeExist:Bool
    let calendar = Calendar.current
        let startTimeComponent = DateComponents(calendar: calendar, hour:Int(startTime.components(separatedBy: ":").first ?? "00"), minute: Int(startTime.components(separatedBy: ":").last ?? "00"))
    let endTimeComponent   = DateComponents(calendar: calendar, hour: Int(endTime.components(separatedBy: ":").first ?? "00"), minute: Int(endTime.components(separatedBy: ":").last ?? "00"))

    let now = Date()
    let startOfToday = calendar.startOfDay(for: now)
    let startTime    = calendar.date(byAdding: startTimeComponent, to:
    startOfToday)!
    let endTime      = calendar.date(byAdding: endTimeComponent, to:
    startOfToday)!

     if startTime <= now && now <= endTime {
        timeExist = true
     } else {
        timeExist = false
     }
       return timeExist
    }
    func getCourseAndTotal(score : Int , totalScore : Int){
        scoreOutOf = scoreOutOf + "\n\(score) out of \(totalScore)"
    }
    func checkQuizeCreated() {
        viewModel.db.collection("Public").whereField("courseCode", isEqualTo: "\(courseField.courseCode)").getDocuments { (snapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in snapshot!.documents {
                    let documentid = document.documentID
                    //print(documentid)
                    
                    viewModel.db.collection("Public").document(documentid).collection("quizeCreated").getDocuments() { (querySnapshot, err) in
                        guard let documents = querySnapshot?.documents else {
                            print("No documents")
                            return
                        }
                        
                        self.quizCreatedList = documents.map { (queryDocumentSnapshot) -> QuizCreatedModel in
                            let data = queryDocumentSnapshot.data()
                            //print(data)
                            
                            let quizType = data["quizType"] as? String ?? ""
                            let quizDuration = data["quizDuration"] as? String ?? ""
                            let Questions = data["Questions"] as? String ?? ""
                            let grades = data["grades"] as? String ?? ""
                            let bankType = data["bankType"] as? String ?? ""
                            let currentTime = data["currentTime"] as? Date ?? Date()
                            
                            return QuizCreatedModel(quizType: quizType, quizDuration: quizDuration, Questions: Questions, grades: grades, bankType: bankType, currentTime: currentTime)
                        }
                        print(self.quizCreatedList.count)
                    }
                    
                }
                
            }
        }
    }
    func getData(){
        Firestore.firestore().collection("Test Bank").document("Science").collection("MCQ").getDocuments() { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.testBankData = documents.map { (queryDocumentSnapshot) -> QuizModel in
                let data = queryDocumentSnapshot.data()
                print(data)
                let question = data["question"] as? String ?? ""
                
                let answer = data["answer"] as? [String]  ?? []
                let finalAnswer = data["finalAnswer"] as? String ?? ""
                return QuizModel(question: question, answer: answer, finalAnswer: finalAnswer)
            }
        }
    }
    func addAttendanceItems() {
        let userData = ["courseName": courseField.courseName, "courseCode": courseField.courseCode, "courseDescription" : courseField.courseDescription,"Private" : courseField.Private, "Score" : self.score,"totalScore" : self.testBankData.count, "lectureTime" : courseField.lectureTime] as [String : Any]
        
        viewModel.db.collection("Student").document(viewModel.studentInfo.uid ).collection("Attendence").whereField("courseCode", isEqualTo: "\(courseField.courseCode)").getDocuments { (snapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    let documentid = document.documentID
                   
                    viewModel.db.collection("Student").document(viewModel.studentInfo.uid).collection("Attendence").document(documentid).setData(userData){ err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully")
                            //viewModel.getData()
                        }
                    }
                }
                if snapshot!.documents.count == 0{
                    Firestore.firestore().collection("Student").document(viewModel.studentInfo.uid).collection("Attendence").document().setData(userData){err in
                        if let err = err {
                            print(err)
                            return
                        }else{
                            print("success")
                        }
                    }
                }
            }
        }
    }
}
