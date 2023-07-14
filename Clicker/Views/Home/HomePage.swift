

import SwiftUI

struct HomePage : View {
    @ObservedObject var viewModel : StudentData = StudentData()
    init(){
        viewModel.getData()
    }
    var body: some View {
        NavigationView{
            VStack {
                Text("Number of courses")
                    .font(.largeTitle)
                    .padding()
                
                Text("\(ServiceManager.shared.courseList.count)")
                    .foregroundColor(Color("Color"))
                    .font(.title)
                    .fontWeight(.bold)
                Divider()
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(ServiceManager.shared.courseList, id: \.self) { course in
                            VStack{
                                let value = calculatePercentage(value: Double(course.totalScore),percentageVal: Double(course.Score))
                                let percentageVal = value.isNaN ? 0.0 : value
                                let finalValue = (Float(percentageVal.roundTo1f() as String) ?? 0.0)
                                ProgressBar(progress: finalValue == 0.0 ? 0.0 : 1.0 - finalValue)
                                    .padding(.horizontal)
                                Text(course.courseName)
                                    .foregroundColor(Color("Color"))
                                    .font(.system(size: 12))
                            }
                        }
                    }
                }
                .frame(height: 90)
                Divider()
                previousQuiz()
                Spacer()
            }
            .padding()
            .navigationBarTitle(Text(ServiceManager.shared.userName.count > 0 ? "Hello, \(ServiceManager.shared.userName)." : ""), displayMode: .inline)
        }
    }
    public func calculatePercentage(value:Double,percentageVal:Double)->Double{
        let val = value - percentageVal
        return val / value
    }
}
struct HomeRedirectPage : View {
    @ObservedObject var viewModel : StudentData = StudentData()
    init(){
        viewModel.getData()
    }
    var body: some View {
        NavigationView{
            VStack {
                Text("Number of courses")
                    .font(.largeTitle)
                    .padding()
                
                Text("\(ServiceManager.shared.courseList.count)")
                    .foregroundColor(Color("Color"))
                    .font(.title)
                    .fontWeight(.bold)
                Divider()
                List {
                    ForEach(viewModel.courseList, id: \.self) { course in
                        NavigationLink(destination: HomePage()) {
                        HStack {
                            Text(course.courseName)
                        }
                        .foregroundColor(Color.black)
                        }
                    }
                }
            }
            .padding()
            .navigationBarTitle(Text(ServiceManager.shared.userName.count > 0 ? "Hello, \(ServiceManager.shared.userName)." : ""), displayMode: .inline)
        }
    }
    public func calculatePercentage(value:Double,percentageVal:Double)->Double{
        let val = value - percentageVal
        return val / value
    }
}
extension Double
{
  func roundTo1f() -> NSString
  {
    return NSString(format: "%.1f", self)
  }
}
