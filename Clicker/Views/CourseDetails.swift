

import SwiftUI
import Firebase
import FirebaseFirestore

struct CourseDetails: View {
    
    var body: some View {
        VStack {
            Text("Hello")//course.courseName
                .foregroundColor(Color("Color"))
                .font(.system(size: 30))
                .fontWeight(.bold)
//            ProgressView(value: course.courseProgress)
//                .frame(width: 290)
//            Text(String(format: "%.0f %%", min(course.courseProgress, 1.0)*100.0))
//                .foregroundColor(Color("Color"))
//                .font(.system(size: 25))
//            Spacer()
        }
        .padding()
    }
}

struct CourseDetails_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetails()
    }
}
