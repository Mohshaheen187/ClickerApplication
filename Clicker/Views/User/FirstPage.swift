

import SwiftUI
import Firebase
import FirebaseFirestore

struct FirstPage: View {
    
    //Colors
    @State var color = Color.black.opacity(0.7)
    
    @State var email = "Amani.abujabal@gju.edu.jo"
    @State var password = "123456_Aa"
    @State var visible = false
    @State var reVisible = false
    @State var alert = false
    @State var error = ""
    @State var passwordStrength : Int = 0
    
    @State var goToRegister = false
    @State var welcomeStudent = false
    @State var welcomeInstructor = false
    @State var errorView: ErrorsHandling?
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Image("logo")
                        .resizable()
                        .frame(width: 300, height: 150)
                    Text("Login to your account")
                        .font(.headline)
                        .fontWeight(.bold)
                    VStack{
                        TextField("Enter your email", text: $email)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : self.color, lineWidth: 2))
                            .autocapitalization(.none)
                        
                        if self.visible {
                            TextField("Enter your password", text: $password)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : self.color, lineWidth: 2))
                                .autocapitalization(.none)
                        } else {
                            SecureField("Enter your password", text: $password)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : self.color, lineWidth: 2))
                                .autocapitalization(.none)
                        }
                        
                        HStack{
                            Button(action: {
                                self.visible.toggle()
                            }) {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                            .padding()
                            .foregroundColor(self.color)
                            
                            Button(action: {
                                if self.email != "" {
                                    Auth.auth().sendPasswordReset(withEmail: email) { (err) in
                                        if err != nil {
                                            errorView = ErrorsHandling(id: 0, title: "Your request was sent successfully", message: "You can change your password now!")
                                            return
                                        }
                                    }
                                } else {
                                    errorView = ErrorsHandling(id: 1, title: "Something Wrong!", message: "The email field is empty.")
                                }
                            }) {
                                Text("Forgot your password?")
                                    .foregroundColor(Color("Color"))
                                    .font(.body)
                                    .fontWeight(.bold)
                            }
                            .alert(item: $errorView, content: { error in
                                Alert(
                                    title: Text(error.title),
                                    message: Text(error.message)
                                )
                            })
                        }
                    }
                    .padding()
                    
                    //Buttons
                    VStack {
                        Button("Login as Student") {
                            studentLogin { result in
                                if (result == true) {
                                    withAnimation{
                                        self.welcomeStudent.toggle()
                                    }
                                } else {
                                    errorView = ErrorsHandling(id: 2, title: "Something Wrong!", message: "Please try again")
                                }
                            }
                        }
                        .padding(12)
                        .frame(width: UIScreen.main.bounds.width - 150)
                        .background(Color("Color"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .fullScreenCover(isPresented: $welcomeStudent) {
                            StudentPage()
                        }
                        
                        Button("Login as Instructor") {
                            instructorLogin { result in
                                if (result == true) {
                                    withAnimation{
                                        self.welcomeInstructor.toggle()
                                    }
                                } else {
                                    errorView = ErrorsHandling(id: 2, title: "Something Wrong!", message: "Please try again")
                                }
                            }
                        }
                        .padding(12)
                        .frame(width: UIScreen.main.bounds.width - 150)
                        .background(Color("Color"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .fullScreenCover(isPresented: $welcomeInstructor) {
                            StudentPage()
                        }
                    }
                }
                Button("Register") {
                    self.goToRegister.toggle()
                }
                .padding()
                .foregroundColor(Color("Color"))
                .font(.body.bold())
                .cornerRadius(25.0)
                .fullScreenCover(isPresented: $goToRegister) {
                    RegistrationPage()
                }
            }
        }
    }
    
    var StudentCollection = Firestore.firestore().collection("Student")
    var InstructorCollection = Firestore.firestore().collection("Instructor")
    
    func studentLogin(completion:@escaping((Bool) -> () )) {
        //        Auth.auth().signIn(withEmail: email, password: password) { (querySnapshot, err) in
        self.StudentCollection.whereField("email", isEqualTo: self.email).getDocuments() { (querySnapshot, err) in
            self.StudentCollection.whereField("password", isEqualTo: self.password).getDocuments() { (querySnapshot, err) in
                if let errorResult = err {
                    print("Unable to query" + errorResult.localizedDescription)
                    completion(false)
                } else {
                    if (querySnapshot!.count > 0) {
                        print("There is a user")
                        UserDefaults.standard.set("student", forKey: "loginAs")
                        Auth.auth().signIn(withEmail: email, password: password) { (querySnapshot, err) in
                        }
                        UserDefaults.standard.set(email, forKey: "email")
                        completion(true)
                    } else {
                        print("No user founded")
                        completion(false)
                    }
                }
            }
        }
        
    }
    //For Instructor
    // Email: Amani.abujabal@gju.edu.jo
    // Password: 123456_Aa
    func instructorLogin(completion:@escaping((Bool) -> () )) {
        self.InstructorCollection.whereField("email", isEqualTo: self.email).getDocuments() { (querySnapshot, err) in
            self.InstructorCollection.whereField("password", isEqualTo: self.password).getDocuments() { (querySnapshot, err) in
                if let errorResult = err {
                    print("Unable to query" + errorResult.localizedDescription)
                    completion(false)
                } else {
                    if (querySnapshot!.count > 0) {
                        print("There is a user")
                        Auth.auth().signIn(withEmail: email, password: password) { (querySnapshot, err) in
                        }
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set("instructor", forKey: "loginAs")
                        completion(true)
                    } else {
                        print("No user founded")
                        completion(false)
                    }
                }
            }
        }
    }
}

struct ErrorsHandling : Identifiable{
    var id: Int
    var title: String
    var message: String
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FirstPage()
    }
}
