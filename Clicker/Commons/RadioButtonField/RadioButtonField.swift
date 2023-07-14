

import SwiftUI

//MARK:- Group of Radio Buttons
enum Question: String {
    case testBank = "Test Bank"
    case newQuestion = "New Question"
}

struct RadioButtonGroups: View {
    let callback: (String) -> ()
    
    @State var selectedId: String = Question.testBank.rawValue
    
    var body: some View {
        HStack {
            radiotestBankMajority
            radionewQuestionMajority
        }
    }
    
    var radiotestBankMajority: some View {
        RadioButtonField(
            id: Question.testBank.rawValue,
            label: Question.testBank.rawValue,
            isMarked: selectedId == Question.testBank.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var radionewQuestionMajority: some View {
        RadioButtonField(
            id: Question.newQuestion.rawValue,
            label: Question.newQuestion.rawValue,
            isMarked: selectedId == Question.newQuestion.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    func radioGroupCallback(id: String) {
        selectedId = id
        callback(id)
    }
}
struct RadioButtonField: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: CGFloat
    let isMarked:Bool
    let callback: (String)->()
    
    init(
        id: String,
        label:String,
        size: CGFloat = 20,
        color: Color = Color.black,
        textSize: CGFloat = 16,
        isMarked: Bool = false,
        callback: @escaping (String)->()
        ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.isMarked = isMarked
        self.callback = callback
    }
    
    var body: some View {
        Button(action:{
            self.callback(self.id)
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: self.isMarked ? "largecircle.fill.circle" : "circle")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
                Text(label)
                    .font(Font.system(size: textSize))
                    .fontWeight(.bold)
                Spacer()
            }.foregroundColor(self.color)
        }
        .foregroundColor(Color.white)
    }
}
