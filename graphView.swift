// Main graph of last seven journals created
// If no data is given, the app crashes

import SwiftUI
import SwiftUICharts

struct graphView: View {
    
    @State var graphInfo: [Double] = LastSevenOfEntries(list: entries)
    @Binding var switchView: Int
    
    var body: some View {
        ZStack {
            Color("lightBlue")
                .ignoresSafeArea()
            VStack {
                Text("Average sleep duration: \(Int(getAverageofList(list: LastSevenOfEntries(list: entries)))) hours")
                    .padding(.top, 80)
                    .font(.system(size:20))
                Text("Sleep Duration, Last 7 Days")
                    .padding(.top, 40)
                    .font(.system(size: 15, weight: .medium))
                ZStack {
                    Text("Hours")
                        .frame(width: 50)
                        .rotationEffect(Angle(degrees: 270))
                        .padding(.trailing, 340)
                    LineView(data: graphInfo.count != 0  ? LastSevenOfEntries(list: entries): [1, 2])
                        .padding(.horizontal, 12)
                        .padding(.vertical, 40)
                        .frame(width: 300, height: 350)
                        .background(.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.black))
                        
                }.padding(.top, 20)
                Text("Days")
                Spacer()
            }
            VStack {
                HStack {
                    Button {
                        switchView = 1
                    } label:  {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25)
                    }.padding(.leading, 40).padding(.top, 30)
                    Spacer()
                }
                Spacer()
            }
        }.onAppear() {
            graphInfo = LastSevenOfEntries(list: entries)
        }
    }
}

struct graphView_Previews: PreviewProvider {
    static var previews: some View {
        graphView(switchView: .constant(0))
    }
}
