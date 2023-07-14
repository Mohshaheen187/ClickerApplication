

import SwiftUI
import Firebase
import FirebaseFirestore
//view for the quiz game
struct Quiz1 : View {
    @State var testBankData : [QuizModel]
    //number of question
    @State var i : Int = 0
    
    //var for the score
    @State var score = 0
    @State var A = 0
    @State var B = 0
    @State var C = 0
    @State var D = 0
    var courseField : Course
    @ObservedObject var viewModel: MyCourseList
    var body: some View {
        VStack(alignment: .center, spacing: 20){
            
            //if i < of questions --> play question
            if(self.i < testBankData.count){
                
                //text of the question
                Text(testBankData[self.i].question!)
                
                //answer 0
                Button(action:{
                    self.buttonAction(n: testBankData[self.i].answer[0])
                    self.A = self.A + 1
                    SaveLastScore(quiz: "A", score: self.A)
                    print(LoadScore(quiz: "A"))
                },label: {
                    Text(testBankData[self.i].answer[0])
                })
                //answer 1
                Button(action:{
                    self.buttonAction(n: testBankData[self.i].answer[1])
                    self.B = self.B + 1
                    SaveLastScore(quiz: "B", score: self.B)
                    
                },label: {
                    Text(testBankData[self.i].answer[1])
                })
                
                if testBankData[self.i].answer.count > 2{
                //answer 2
                Button(action:{
                    self.buttonAction(n: testBankData[self.i].answer[2])
                    self.C = self.C + 1
                    SaveLastScore(quiz: "C", score: self.C)
                },label: {
                    Text(testBankData[self.i].answer[2])
                })
                
                //answer 3
                Button(action:{
                    self.buttonAction(n: testBankData[self.i].answer[3])
                    self.D = self.D + 1
                    SaveLastScore(quiz: "D", score: self.D)
                },label: {
                    Text(testBankData[self.i].answer[3])
                })
                }

            }
            //after last question --> show final view with score
            else{
                FinalView(score: self.score, courseField: courseField, viewModel: viewModel, testBankData: self.testBankData)
            }
        }
        .onAppear{
            SaveLastScore(quiz: "A", score: 0)
            SaveLastScore(quiz: "B", score: 0)
            SaveLastScore(quiz: "C", score: 0)
            SaveLastScore(quiz: "D", score: 0)
        }
    }
    //action of the buttons
    func buttonAction( n : String){
        if(testBankData[self.i].finalAnswer == n){
            self.score = self.score + 1
        }
        //GO TO NEXT QUESTION
        self.i = self.i + 1
    }
   
}
struct FinalView : View {
    
    var score : Int
    var courseField : Course
    @ObservedObject var viewModel: MyCourseList
    @State var testBankData : [QuizModel]
    var body: some View {
        
        VStack{
            Text("Final Score : \(score)")
            .onAppear(){
                SaveScore(quiz: "myQuiz1", score: self.score)
                SaveLastScore(quiz: "totalScore", score: self.testBankData.count)
                storeCourseInformation()
            }
        }
    }
    func storeCourseInformation() {
    
        let userData = ["courseName": courseField.courseName, "courseCode": courseField.courseCode, "courseDescription" : courseField.courseDescription,"Private" : courseField.Private, "Score" : self.score,"totalScore" : self.testBankData.count,"lectureTime" : courseField.lectureTime] as [String : Any]
        Firestore.firestore().collection("Student").document(viewModel.studentInfo.uid).collection("Cources").document().setData(userData){err in
            if let err = err {
                print(err)
                return
            }
            else{
                print("success")
            }
        }
    }
}
