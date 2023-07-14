

import SwiftUI

class ServiceManager {
    static let shared = ServiceManager()
    @Published private(set) var userName: String = ""
    @Published var userNameInfo: String = ""{
        didSet {
            self.userName = userNameInfo
        }
    }
    @Published private(set) var courseDetail: Course = Course(courseProgress: 0.0, courseName: "", courseCode: "", courseDescription: "", Private: false, MCQ: [], Score: 0, totalScore: 0, lectureTime: "")
    @Published var courseDetailInfo: Course = Course(courseProgress: 0.0, courseName: "", courseCode: "", courseDescription: "", Private: false, MCQ: [], Score: 0, totalScore: 0, lectureTime: ""){
        didSet {
            self.courseDetail = courseDetailInfo
        }
    }
    @Published private(set) var courseList: [Course] = []
    @Published var setCourseList : [Course] = []{
        didSet {
            self.courseList = setCourseList
        }
    }
}
