

import SwiftUI
import Firebase
import FirebaseFirestore

struct InstructorPage: View {
    
    //    @FirestoreQuery(
    //        collectionPath: "Instructor/Instructor1",
    //        predicates: [.where("First Name", isEqualTo: false)]
    //    ) var instructors: [instructorData]
    
    
    @State var color = Color.black.opacity(0.7)
    
    @State var selectedTab : Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Home()
                .tabItem{
                    Image(systemName: "house.fill")
                }
                .tag(0)
            
            myCourses()
                .tabItem{
                    Image(systemName: "newspaper.fill")
                }
                .tag(1)
            
            Home()
                .tabItem{
                    Image(systemName: "person.circle.fill")
                }
                .tag(2)
            
            Home()
                .tabItem{
                    Image(systemName: "gear.circle.fill")
                }
                .tag(3)
        }
    }
}

struct InstructorPage_Previews: PreviewProvider {
    static var previews: some View {
        StudentPage()
    }
}

//Tag 0
struct Home : View {
    
    var numOfCourses = 5
    var name = "Mohammed"
    
    var body: some View {
        NavigationView{
            VStack {
                Text("Number of courses")
                    .font(.largeTitle)
                    .padding()
                
                Text("\(numOfCourses)")
                    .foregroundColor(Color("Color"))
                    .font(.title)
                    .fontWeight(.bold)
                Divider()
                ScrollView(.horizontal){
                    //coursesProgress()
                    Text("Hello")
                }
                .frame(height: 150)
                Divider()
                //lastQuiz()
                Spacer()
            }
            .padding()
            .navigationBarTitle(Text("Hello, \(name)!"), displayMode: .inline)
            
        }
    }
}

var Public = ["CS116", "CS316", "CS415"]
var Private = ["ENE201", "ARB100", "MLS101"]

//Tag 1
struct myCourses : View {
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("Public Courses"), footer: Text("\(Public.count) Courses")) {
                    ForEach(Public, id: \.self) { course in
                        Text(course)
                    }
                    .onDelete { Public.remove(atOffsets: $0) }
                    .onMove { Public.move(fromOffsets: $0, toOffset: $1) }
                }
                
                Section(header: Text("Private Courses"), footer: Text("\(Private.count) Courses")) {
                    ForEach(Private, id: \.self) { course in
                        Text(course)
                    }
                    .onDelete { Private.remove(atOffsets: $0) }
                    .onMove { Private.move(fromOffsets: $0, toOffset: $1) }
                }
            }
            .navigationTitle(Text("My Courses"))
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    print("Course added")
                }) {
                    Text("Add")
                }
            )
        }
    }
    //Tag 2
    struct InstructorAttendance : View {
        
        @State var name = "Mohammed"
        
        var body: some View{
            NavigationView{
                VStack{
                    Text("Hello")
                }
                //            List(courses) {course in
                //                NavigationLink(destination: CourseDetails(course: course)) {
                //                    InstructorExtractedAttendance(course: course)
                //                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Attendance")
            .navigationBarItems(leading: EditButton())
        }
        
    }
    //    func delete(at offsets: IndexSet) {
    //        if let first = offsets.first {
    //            courses.remove(at: first)
    //        }
    //    }
    //
    //     func move(indices: IndexSet, newOffset: Int) {
    //     courses.move(fromOffsets: indices, toOffset: newOffset)
    //     }
    
    
    
    //Tag 3
    struct MySettings : View {
        
        @Environment(\.openURL) var openURL
        @State var needHelp : Bool = false
        @State var editProfile = false
        @State var backToLogin = false
        
        var body: some View{
            VStack{
                
                Text("How can we help?")
                    .foregroundColor(Color("Color"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Button("Edit profile") {
                    self.editProfile.toggle()
                }
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("Color"))
                .clipShape(Capsule())
                /*.popover(isPresented: $editProfile){
                 EditProfile()
                 }*/
                
                
                Button("E-Learning") {
                    openURL(URL(string: "https://e-learning.gju.edu.jo/login/index.php")!)
                }
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("Color"))
                .clipShape(Capsule())
                
                Button("MyGJU") {
                    openURL(URL(string: "https://mygju.gju.edu.jo/faces/index.xhtml")!)
                }
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("Color"))
                .clipShape(Capsule())
                
                Button("Help") {
                    needHelp = true
                }
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("Color"))
                .clipShape(Capsule())
                .alert(isPresented: $needHelp) {
                    Alert(title: Text("Need Help?"), message: Text("Please contact: M.shaheen1@gju.edu.jo"), dismissButton: .default(Text("Got it!")))
                }
                
                Button("Log out") {
                    try? Auth.auth().signOut()
                    self.backToLogin.toggle()
                }
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("Color"))
                .clipShape(Capsule())
                .fullScreenCover(isPresented: $backToLogin) {
                    FirstPage()
                }
            }
        }
    }
    
    struct coursesProgress : View {
        
        @State var isLoading = false
        var color : Color = Color.green
        @State var course : Course
        var body: some View{
//            VStack{
//                Text("Hello")
//            }
            
                    HStack {
                        VStack {
                            ZStack{
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(min(course.courseProgress, 1.0)))
                                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                    .frame(width: 100, height: 100, alignment: .center)
                                    .foregroundColor(.green)
                                    .rotationEffect(Angle(degrees: 270))
                                    .animation(.easeInOut, value: 2.0)
                                Text(String(format: "%.0f %%", min(course.courseProgress, 1.0)*100.0))
                            }
                            .padding()
                            Text("Hello")//course.courseName
                                .foregroundColor(Color("Color"))
                                .font(.title2)
                                .padding(.bottom)
                        }
                        VStack {
                            ZStack{
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(min(course.courseProgress, 1.0)))
                                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                    .frame(width: 100, height: 100, alignment: .center)
                                    .foregroundColor(.green)
                                    .rotationEffect(Angle(degrees: 270))
                                    .animation(.easeInOut, value: 2.0)
                                Text(String(format: "%.0f %%", min(course.courseProgress, 1.0)*100.0))
                            }
                            .padding()
                            Text("Hello")//course.courseName
                                .foregroundColor(Color("Color"))
                                .font(.title2)
                                .padding(.bottom)
                        }
                        VStack {
                            ZStack{
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(min(course.courseProgress, 1.0)))
                                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                    .frame(width: 100, height: 100, alignment: .center)
                                    .foregroundColor(.green)
                                    .rotationEffect(Angle(degrees: 270))
                                    .animation(.easeInOut, value: 2.0)
                                Text(String(format: "%.0f %%", min(course.courseProgress, 1.0)*100.0))
                            }
                            .padding()
                            Text("Hello")//course.courseName
                                .foregroundColor(Color("Color"))
                                .font(.title2)
                                .padding(.bottom)
                        }
                        VStack {
                            ZStack{
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(min(course.courseProgress, 1.0)))
                                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                    .frame(width: 100, height: 100, alignment: .center)
                                    .foregroundColor(.green)
                                    .rotationEffect(Angle(degrees: 270))
                                    .animation(.easeInOut, value: 2.0)
                                Text(String(format: "%.0f %%", min(course.courseProgress, 1.0)*100.0))
                            }
                            .padding()
                            Text("Hello")//course.courseName
                                .foregroundColor(Color("Color"))
                                .font(.title2)
                                .padding(.bottom)
                        }
                        VStack {
                            ZStack{
                                Circle()
                                    .trim(from: 0.0, to: CGFloat(min(course.courseProgress, 1.0)))
                                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                    .frame(width: 100, height: 100, alignment: .center)
                                    .foregroundColor(.green)
                                    .rotationEffect(Angle(degrees: 270))
                                    .animation(.easeInOut, value: 2.0)
                                Text(String(format: "%.0f %%", min(course.courseProgress, 1.0)*100.0))
                            }
                            .padding()
                            Text("Hello")//course.courseName
                                .foregroundColor(Color("Color"))
                                .font(.title2)
                                .padding(.bottom)
                        }
                    }
                    .padding()
        }
    }
    
    /*
     VStack {
     ZStack{
     Circle()
     .trim(from: 0.0, to: CGFloat(min(course.courseProgress, 1.0)))
     .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
     .frame(width: 100, height: 100, alignment: .center)
     .foregroundColor(.green)
     .rotationEffect(Angle(degrees: 270))
     .animation(.easeInOut, value: 2.0)
     Text(String(format: "%.0f %%", min(course.courseProgress, 1.0)*100.0))
     }
     .padding()
     Text(course.courseName)
     .foregroundColor(Color("Color"))
     .font(.title2)
     .padding(.bottom)
     }
     VStack {
     ZStack{
     Circle()
     .trim(from: 0.0, to: CGFloat(min(course.courseProgress, 1.0)))
     .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
     .frame(width: 100, height: 100, alignment: .center)
     .foregroundColor(.green)
     .rotationEffect(Angle(degrees: 270))
     .animation(.easeInOut, value: 2.0)
     Text(String(format: "%.0f %%", min(course.courseProgress, 1.0)*100.0))
     }
     .padding()
     Text(course.courseName)
     .foregroundColor(Color("Color"))
     .font(.title2)
     .padding(.bottom)
     }
     VStack {
     ZStack{
     Circle()
     .trim(from: 0.0, to: CGFloat(min(course.courseProgress, 1.0)))
     .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
     .frame(width: 100, height: 100, alignment: .center)
     .foregroundColor(.green)
     .rotationEffect(Angle(degrees: 270))
     .animation(.easeInOut, value: 2.0)
     Text(String(format: "%.0f %%", min(course.courseProgress, 1.0)*100.0))
     }
     .padding()
     Text(course.courseName)
     .foregroundColor(Color("Color"))
     .font(.title2)
     .padding(.bottom)
     }
     VStack {
     ZStack{
     Circle()
     .trim(from: 0.0, to: CGFloat(min(course.courseProgress, 1.0)))
     .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
     .frame(width: 100, height: 100, alignment: .center)
     .foregroundColor(.green)
     .rotationEffect(Angle(degrees: 270))
     .animation(.easeInOut, value: 2.0)
     Text(String(format: "%.0f %%", min(course.courseProgress, 1.0)*100.0))
     }
     .padding()
     Text(course.courseName)
     .foregroundColor(Color("Color"))
     .font(.title2)
     .padding(.bottom)
     }
     VStack {
     ZStack{
     Circle()
     .trim(from: 0.0, to: CGFloat(min(course.courseProgress, 1.0)))
     .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
     .frame(width: 100, height: 100, alignment: .center)
     .foregroundColor(.green)
     .rotationEffect(Angle(degrees: 270))
     .animation(.easeInOut, value: 2.0)
     Text(String(format: "%.0f %%", min(course.courseProgress, 1.0)*100.0))
     }
     .padding()
     Text(course.courseName)
     .foregroundColor(Color("Color"))
     .font(.title2)
     .padding(.bottom)
     }
     */
    struct lastQuiz : View {
        
        @State var a = 0.7
        @State var b = 0.4
        @State var c = 0.6
        @State var d = 0.2
        
        var body: some View{
            VStack{
                Text("Last Quiz Results")
                    .font(.title)
                    .foregroundColor(Color("Color"))
                    .fontWeight(.bold)
                    .padding(.top, 35)
                HStack{
                    Text("A")
                        .foregroundColor(Color("Color"))
                        .font(.body)
                        .fontWeight(.bold)
                    ProgressView(value: 0.7)
                    Text(String(format: "%.0f %%", min(self.a, 1.0)*100.0))
                }
                .padding()
                HStack{
                    Text("B")
                        .foregroundColor(Color("Color"))
                        .font(.body)
                        .fontWeight(.bold)
                    ProgressView(value: 0.4)
                    Text(String(format: "%.0f %%", min(self.b, 1.0)*100.0))
                }
                .padding()
                HStack{
                    Text("C")
                        .foregroundColor(Color("Color"))
                        .font(.body)
                        .fontWeight(.bold)
                    ProgressView(value: 0.6)
                    Text(String(format: "%.0f %%", min(self.c, 1.0)*100.0))
                }
                .padding()
                HStack{
                    Text("D")
                        .foregroundColor(Color("Color"))
                        .font(.body)
                        .fontWeight(.bold)
                    ProgressView(value: 0.2)
                    Text(String(format: "%.0f %%", min(self.d, 1.0)*100.0))
                }
                .padding()
            }
        }
    }
    
    struct InstructorExtractedCourses: View {
        
        var body: some View {
            VStack(alignment: .leading){
                Text("Hello")//course.courseName
                Text("Hello")//course.courseCode
            }
        }
    }
    
    struct InstructorExtractedAttendance: View {
        var body: some View {
            VStack(alignment: .leading){
                Text("Hello")//course.courseName
                Text("Hello")//course.courseCode
            }
        }
    }
    
}
