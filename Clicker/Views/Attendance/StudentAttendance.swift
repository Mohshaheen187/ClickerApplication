

import SwiftUI

struct StudentAttendance : View {
    @ObservedObject var attendanceVM: AttendanceVM
    let loginAs = UserDefaults.standard.object(forKey: "loginAs") as? String ?? ""
    
    var body: some View{
        NavigationView {
            if (loginAs == "instructor"){
                InstructorView
                    .navigationTitle(Text("Attendance"))
            }else{
                studentView
                    .navigationTitle(Text("Attendance"))
            }
        }
    }
    var studentView: some View{
        Form {
            let publicCourseList = attendanceVM.attendenceList.filter { $0.Private == false }
            Section(header: Text("Public Courses"), footer: Text("\(publicCourseList.count) Courses")) {
                ForEach(publicCourseList, id: \.self) { course in
                    Text(course.courseName)
                }
            }
            let privateCourseList = attendanceVM.attendenceList.filter { $0.Private == true }
            if privateCourseList.count > 0{
            Section(header: Text("Private Courses"), footer: Text("\(privateCourseList.count) Courses")) {
                ForEach(privateCourseList, id: \.self) { course in
                    Text(course.courseName)
                }
            }
            }
        }
    }
    var InstructorView: some View{
        Form {
            Section(header: Text("Attended Students"), footer: Text("\(attendanceVM.attendedStudent.count) Students")) {
                ForEach(attendanceVM.attendedStudent, id: \.self) { student in
                    Text(student.firstName + " " + student.lastName)
                }
            }
        }
    }
}
