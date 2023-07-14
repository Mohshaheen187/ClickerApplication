

import SwiftUI
import Firebase
struct Settings : View {
    
    @Environment(\.openURL) var openURL
    @State var needHelp : Bool = false
    @State var backToLogin = false
    @ObservedObject var viewModel: ProfileVM
    var body: some View{
        VStack{
            
            Text("What can we help?")
                .foregroundColor(Color("Color"))
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Button("Edit profile") {
                viewModel.editProfile.toggle()
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
                UserDefaults.standard.removeObject(forKey: "email")
                UserDefaults.standard.removeObject(forKey: "loginAs")
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
        .onAppear{
            viewModel.getData()
        }
        .padding(.horizontal)
    }
}
