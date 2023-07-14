

import SwiftUI
import Firebase
import FirebaseFirestore

enum RegistrationKeys: String {
    case firstName
    case lastName
    case email
    case password
    case studentID
    case phoneNumber
    case uid
}
struct RegistrationPage: View {
    
    //Colors
    @State var color = Color.black.opacity(0.7)
    
    //Information
    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    @State var password = ""
    @State var repassword = ""
    @State var studentID = ""
    @State var phoneNumber = ""
    
    //View Controlling states
    @State var visible = false
    @State var passwordStatus = ""
    @Environment(\.presentationMode) var presentationMode
    @State var trigger : Int = 0// if trigger = 0, then you can't register
    @State var error: ErrorView?
    
    var body: some View {
        
        VStack {
            HStack {
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(Color.black)
                        .font(.largeTitle)
                }
                .padding()
                Spacer()
            }
            VStack{
                Text("Fill your information")
                    .foregroundColor(Color("Color"))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                TextField("First Name", text: $firstName)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.firstName != "" ? Color("Color") : self.color, lineWidth: 2))
                    .autocapitalization(.none)
                
                TextField("Last Name", text: $lastName)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.lastName != "" ? Color("Color") : self.color, lineWidth: 2))
                    .autocapitalization(.none)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : self.color, lineWidth: 2))
                    .autocapitalization(.none)
                
                ZStack(alignment: .trailing){
                    VStack(alignment: .leading){
                        if self.visible {
                            TextField("Enter your password", text: $password)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color("Color") : self.color, lineWidth: 2))
                                .autocapitalization(.none)
                        } else {
                            SecureField("Enter your password", text: $password)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color("Color") : self.color, lineWidth: 2))
                                .autocapitalization(.none)
                        }
                        if passwordStatus == "Strong" {
                            Text("\(passwordStatus)")
                                .foregroundColor(Color.green)
                                .font(.subheadline)
                                .fontWeight(.bold)
                        } else {
                            Text("\(passwordStatus)")
                                .foregroundColor(Color.red)
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                    }
                    Button(action: {
                        self.visible.toggle()
                    }) {
                        Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                    }
                    .padding()
                    .foregroundColor(self.color)
                }
                Group{
                    if self.visible {
                        TextField("Repeat Password", text: $repassword)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.repassword != "" ? Color("Color") : self.color, lineWidth: 2))
                            .autocapitalization(.none)
                    } else {
                        SecureField("Repeat Password", text: $repassword)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.repassword != "" ? Color("Color") : self.color, lineWidth: 2))
                            .autocapitalization(.none)
                    }
                }
                Group{
                    TextField("Student id", text: $studentID)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.studentID != "" ? Color("Color") : self.color, lineWidth: 2))
                        .autocapitalization(.none)
                    
                    TextField("Phone Number", text: $phoneNumber)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.phoneNumber != "" ? Color("Color") : self.color, lineWidth: 2))
                        .autocapitalization(.none)
                }
                Group{
                    Button(action: {
                        checkStrength()
                        self.trigger = 1
                    }) {
                        Text("Check Strength")
                    }
                    .padding(12)
                    .frame(width: UIScreen.main.bounds.width - 150)
                    .background(Color("Color"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    //Check the strength before registering
                    Button(action: {
                        if self.password != self.repassword {
                            trigger = 0
                            passwordStatus = ""
                            error = ErrorView(id: 1, title: "Error", description: "Passwords are not MATCHING")
                        } else if (self.firstName == "") && (self.lastName == "") && (self.email == "") && (self.password == "") && (self.repassword == "") && (self.studentID == "") && (self.phoneNumber == "") {
                            trigger = 0
                            passwordStatus = ""
                            error = ErrorView(id: 2, title: "Something Wrong", description: "One or more field is/are EMPTY!")
                        } else if self.passwordStatus == "Weak" {
                            trigger = 0
                            passwordStatus = ""
                            error = ErrorView(id: 3, title: "Error", description: "Password is WEAK!")
                        } else if trigger == 0 {
                            trigger = 0
                            passwordStatus = ""
                            error = ErrorView(id: 4, title: "Opps..", description: "Check the strength first please!")
                        } else {
                            createUser()
                        }
                    }) {
                        Text("Register")
                    }
                    .padding(12)
                    .frame(width: UIScreen.main.bounds.width - 150)
                    .background(Color("Color"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .alert(item: $error, content: { error in
                        Alert(
                            title: Text(error.title),
                            message: Text(error.description))
                    })
                }
            }
            .padding()
            Spacer()
        }
    }
    func checkStrength() {
        
        var containsSymbol = false
        var containsUpperCase = false
        
        for character in self.password {
            if "ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(character) {
                containsUpperCase = true
            }
            
            if "!@#$%^&*-_.".contains(character) {
                containsSymbol = true
            }
        }
        if password.count > 8 && containsSymbol && containsUpperCase {
            passwordStatus = "Strong"
        } else {
            passwordStatus = "Weak"
        }
    }
    
    //User Authentication
    private func createUser() {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, err in
            if err != nil {
                print("Failed to create user")
            } else {
                print("Success from Auth")
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let userData = ["firstName": self.firstName, "lastName": self.lastName, "email": self.email ,"password": self.password, "studentID": self.studentID, "phonenumber": self.phoneNumber, "uid": uid]
                Firestore.firestore().collection("Student")
                    .document(uid).setData(userData) { err in
                        if let err = err {
                            print(err)
                            return
                        }else{
                            error = ErrorView(id: 5, title: "Congrats!!", description: "You successfully registered!")
                            //Text Fields
                            firstName = ""
                            lastName = ""
                            email = ""
                            password = ""
                            phoneNumber = ""
                            studentID = ""
                            repassword = ""
                            
                            //After checking the strength
                            passwordStatus = ""
                            trigger = 0
                        }
                    }
            }
        }
    }
}

//Error View for the Registration
struct ErrorView: Identifiable {
    var id: Int
    let title: String
    let description: String
}


struct StudentRegistration_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationPage()
        //.environmentObject()//DataManager()
    }
}
