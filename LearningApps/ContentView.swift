// first view loadeed
// Home page
// allows user to sign in using google...hopefully
// I'm not good at figuring things out sometimes 

import SwiftUI

struct ContentView: View {
    
    @Binding var isRun: Int
    @EnvironmentObject var signupVM : SignUpViewModel
    
    var tex: String = "Continue with google"
    var body: some View {
        ZStack(alignment: .top)  {
            Color(.white)
                .ignoresSafeArea()
            VStack {
                HeaderView()
                Button {
                    signupVM.signUpWithGoogle()
                    isRun = 1
                }   label: {
                    buttonLabel(tex: tex, buttonColor: .blue)
                }.cornerRadius(10)
                
                Spacer()
                Image("SillySleep")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
        
    static var previews: some View {
        ContentView(isRun: .constant(0))
    }
}

struct HeaderView: View {
    
    var body: some View {
        ZStack {
            Color(.black)
                .frame(width: 400, height: 200)
                .ignoresSafeArea()
            Text("Sleep Journal Pro")
                .foregroundColor(.white)
                .font(.system(size: 40, weight: .medium))
        }
    }
}

struct buttonLabel: View {
    
    var tex: String
    var buttonColor: Color
        
    var body: some View {
        Text(tex)
            .padding(5)
            .background(buttonColor)
            .foregroundColor(.white)
            .font(.system(size: 30))
    }
}

