

import SwiftUI

class HomeVM: ObservableObject {
   
    @Published var courses : [Course]
    init(){
        self.courses = [Course(courseProgress: 0.3, courseName: "CS116", courseCode: "CS22", courseDescription: "desc", Private: false, MCQ: [], Score: 0, totalScore: 0, lectureTime: ""),Course(courseProgress: 0.5, courseName: "CS112", courseCode: "CS22", courseDescription: "desc", Private: false, MCQ: [], Score: 0, totalScore: 0, lectureTime: ""),Course(courseProgress: 0.7, courseName: "CS118", courseCode: "CS22", courseDescription: "desc", Private: false, MCQ: [], Score: 0, totalScore: 0, lectureTime: "")]
    }
}
