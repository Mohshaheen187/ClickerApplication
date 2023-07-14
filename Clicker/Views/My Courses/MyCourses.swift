//
//  MyCourses.swift
//  Clicker
//
//  Created by MacV on 25/05/22.
//

import SwiftUI
import FirebaseFirestore
struct MyCourses : View {
    @ObservedObject var viewModel: MyCourseList
    @ObservedObject var attendanceVM: AttendanceVM
    @State var isPrivate = ""
    let loginAs = UserDefaults.standard.object(forKey: "loginAs") as? String ?? ""
    var body: some View{
        if loginAs == "student" {
            loginAsStudent
        } else{
            loginAsInstructor}
    }
    var loginAsStudent : some View{
        NavigationView {
            Form {
                var publicCourseList = viewModel.courseList.filter { $0.Private == false }
                Section(header: Text("Public Courses"), footer: Text("\(publicCourseList.count) Courses")) {
                    ForEach(publicCourseList, id: \.self) { course in
                        NavigationLink(destination: StudentAttendanceDetail( attendanceVM: attendanceVM, courseField: course, viewModel: viewModel)) {
                        Text(course.courseName)
                        }
                    }
                    .onDelete {
                        self.isPrivate = "Public"
                        deleteLineItems(at: $0, arr: publicCourseList)
                        publicCourseList.remove(atOffsets: $0) }
                    .onMove { publicCourseList.move(fromOffsets: $0, toOffset: $1) }
                }
                var privateCourseList = viewModel.courseList.filter { $0.Private == true }
                if privateCourseList.count > 0{
                Section(header: Text("Private Courses"), footer: Text("\(privateCourseList.count) Courses")) {
                    ForEach(privateCourseList, id: \.self) { course in
                        NavigationLink(destination: StudentAttendanceDetail( attendanceVM: attendanceVM, courseField: course, viewModel: viewModel)) {
                        Text(course.courseName)
                        }
                    }
                    .onDelete {
                        self.isPrivate = "Private"
                        deleteLineItems(at: $0, arr: privateCourseList)
                        privateCourseList.remove(atOffsets: $0)
                        //deleteCourse(course: privateCourseList[$0])
                    }
                    .onMove { privateCourseList.move(fromOffsets: $0, toOffset: $1) }
                }
                }
            }
            .navigationTitle(Text("My Courses"))
            .navigationBarItems(
                trailing: Button(action: {
                    print("Course added")
                    viewModel.bottomSheetShown = true
                }) {
                    Text("Add")
                }
            )
        }
    }
    var loginAsInstructor : some View{
        NavigationView {
            Form {
                var publicCourseList = viewModel.courseList.filter { $0.Private == false }
                Section(header: Text("Public Courses"), footer: Text("\(publicCourseList.count) Courses")) {
                    ForEach(publicCourseList, id: \.self) { course in
                        NavigationLink(destination: StudentAttendanceDetail( attendanceVM: attendanceVM, courseField: course, viewModel: viewModel)) {
                        Text(course.courseName)
                        }
                    }
                    .onDelete {
                        self.isPrivate = "Public"
                        deleteLineItems(at: $0, arr: publicCourseList)
                        publicCourseList.remove(atOffsets: $0) }
                    .onMove { publicCourseList.move(fromOffsets: $0, toOffset: $1) }
                }
                var privateCourseList = viewModel.courseList.filter { $0.Private == true }
                if privateCourseList.count > 0{
                Section(header: Text("Private Courses"), footer: Text("\(privateCourseList.count) Courses")) {
                    ForEach(privateCourseList, id: \.self) { course in
                        NavigationLink(destination: StudentAttendanceDetail( attendanceVM: attendanceVM, courseField: course, viewModel: viewModel)) {
                        Text(course.courseName)
                        }
                    }
                    .onDelete {
                        self.isPrivate = "Private"
                        deleteLineItems(at: $0, arr: privateCourseList)
                        privateCourseList.remove(atOffsets: $0)
                        //deleteCourse(course: privateCourseList[$0])
                    }
                    .onMove { privateCourseList.move(fromOffsets: $0, toOffset: $1) }
                }
                }
            }
            .navigationTitle(Text("My Courses"))
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    print("Course added")
                    viewModel.bottomSheetShown = true
                }) {
                    Text("Add")
                }
            )
        }
    }
    func deleteLineItems(at offsets: IndexSet , arr : [Course]) {
        let tableName = (loginAs == "instructor") ? "Instructor" : "Student"
        let itemsToDelete = offsets.lazy.map { arr[$0] }
        itemsToDelete.forEach { lineItem in
         // if let id = lineItem.uid {
            print(lineItem.courseName)
            viewModel.db.collection(tableName).document(viewModel.studentInfo.uid ).collection("Cources").whereField("courseCode", isEqualTo: "\(lineItem.courseCode)").getDocuments { (snapshot, err) in

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
            }
        }
      }
  
    func deleteCourse(course: Course) {
        viewModel.db.collection("Student").document(viewModel.studentInfo.uid).collection("Cources").document("course.id ").delete(){ err in
        if let err = err {
          print("Error removing document: \(err)")
        }
        else {
          print("Document successfully removed!")
        }
      }
    }
}
