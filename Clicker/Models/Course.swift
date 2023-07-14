

import Foundation
import SwiftUI
import FirebaseFirestoreSwift
struct Course:  Codable , Hashable, Identifiable{
    @DocumentID var id: String? = UUID().uuidString
    var courseProgress: Float
    var courseName : String
    var courseCode : String
    var courseDescription : String
    var Private : Bool
    var MCQ : [quizQuestion]
    var Score : Int
    var totalScore : Int
    var lectureTime : String
}
struct quizQuestion:  Codable , Hashable{
    var question: String
    var ans1 : String
    var ans2 : String
    var ans3 : String
    var ans4 : String
    var finalAnswer : String
}
