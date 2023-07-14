

import SwiftUI

struct previousQuiz : View {
    
    @State var a = LoadScore(quiz: "A")
    @State var b = LoadScore(quiz: "B")
    @State var c = LoadScore(quiz: "C")
    @State var d = LoadScore(quiz: "D")
    @State var totalScore = LoadScore(quiz: "totalScore")

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
                if totalScore == a{
                    ProgressView(value: 1.0)
                    Text(String(format: "%.0f %%" ,  1*100.0))
                }else{
                let value = calculatePercentage(value: Double(totalScore),percentageVal: Double(a))
                let percentageVal = value.isNaN ? 0.0 : value
                let finalValue = (Float(percentageVal.roundTo1f() as String) ?? 0.0)
                ProgressView(value: finalValue == 0.0 ? 0.0 : 1.0 - finalValue)
                Text(String(format: "%.0f %%" ,  min(finalValue == 0.0 ? 0.0 : 1.0 - (Float(percentageVal.roundTo1f() as String) ?? 0.0), 1.0)*100.0))
                }
            }
            .padding()
            HStack{
                Text("B")
                    .foregroundColor(Color("Color"))
                    .font(.body)
                    .fontWeight(.bold)
                if totalScore == b{
                    ProgressView(value: 1.0)
                    Text(String(format: "%.0f %%" ,  1*100.0))
                }else{
                let value = calculatePercentage(value: Double(totalScore),percentageVal: Double(b))
                let percentageVal = value.isNaN ? 0.0 : value
                let finalValue = (Float(percentageVal.roundTo1f() as String) ?? 0.0)
                ProgressView(value: finalValue == 0.0 ? 0.0 : 1.0 - finalValue)
                Text(String(format: "%.0f %%" ,  min( finalValue == 0.0 ? 0.0 : 1.0 - (Float(percentageVal.roundTo1f() as String) ?? 0.0), 1.0)*100.0))
                }
            }
            .padding()
            HStack{
                Text("C")
                    .foregroundColor(Color("Color"))
                    .font(.body)
                    .fontWeight(.bold)
                if totalScore == c{
                    ProgressView(value: 1.0)
                    Text(String(format: "%.0f %%" ,  1*100.0))
                }else{
                let value = calculatePercentage(value: Double(totalScore),percentageVal: Double(c))
                let percentageVal = value.isNaN ? 0.0 : value
                let finalValue = (Float(percentageVal.roundTo1f() as String) ?? 0.0)
                ProgressView(value: finalValue == 0.0 ? 0.0 : 1.0 - finalValue)
                Text(String(format: "%.0f %%" ,  min(finalValue == 0.0 ? 0.0 : 1.0 - (Float(percentageVal.roundTo1f() as String) ?? 0.0), 1.0)*100.0))
                }
                //ProgressView(value: 0.6)
                //Text(String(format: "%.0f %%", min(Double(self.c), 1.0)*100.0))
            }
            .padding()
            HStack{
                Text("D")
                    .foregroundColor(Color("Color"))
                    .font(.body)
                    .fontWeight(.bold)
                if totalScore == d{
                    ProgressView(value: 1.0)
                    Text(String(format: "%.0f %%" ,  1*100.0))
                }else{
                let value = calculatePercentage(value: Double(totalScore),percentageVal: Double(d))
                let percentageVal = value.isNaN ? 0.0 : value
                let finalValue = (Float(percentageVal.roundTo1f() as String) ?? 0.0)
                ProgressView(value: finalValue == 0.0 ? 0.0 : 1.0 - finalValue)
                Text(String(format: "%.0f %%" ,  min(finalValue == 0.0 ? 0.0 :1.0 - (Float(percentageVal.roundTo1f() as String) ?? 0.0), 1.0)*100.0))
                }
            }
            .padding()
        }
    }
    public func calculatePercentage(value:Double,percentageVal:Double)->Double{
        let val = value - percentageVal
        return val / value
    }
}
