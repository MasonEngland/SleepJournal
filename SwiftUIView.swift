// Main view showing all the journal entries
// Forgot to change the name of this file...oops
// Each journal is added to what is hopefully a database

import SwiftUI

// MARK: - Main
struct journalView: View {
    
    @Binding var ents: [sleepEntry]
    @State private var showPopup: Bool = false
    @Binding var otherPopup: Bool
    @Binding var switchView: Int
    @EnvironmentObject var signupVM : SignUpViewModel
    
    var body: some View {
        ZStack {
            NavigationView {
                List(ents, id: \.id) { item in
                    
                    let rounded = item.date
                    VStack {
                        HStack {
                            Button {
                                if entries.count > 1 {
                                    if let index = entries.firstIndex(of: item) {
                                        entries.remove(at: index)
                                        ents = entries
                                    }
                                    let userRef = db.collection("users").document("\(String(describing: signupVM.loginName))")
                                    userRef.updateData([
                                        "data": encodeData(list: entries)
                                    ]) { err in
                                        if let err = err {
                                            print(err)
                                        } else {
                                            print("document updated successfully")
                                        }
                                    }
                                }
                            } label: {
                                Image(systemName: "x.square")
                            }.padding(.bottom, 30)
                            Spacer()
                            VStack {
                                Text("Date:")
                                    .padding(2)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.black)
                                Text("\(rounded)")
                                    .padding(.top, 5)
                                    .font(.system(size: 13, weight: .medium))
                            }.background(Color.white)
                            VStack {
                                Text("Time Slept:")
                                    .padding(2)
                                    .font(.system(size: 15, weight: .semibold))
                                Text("\(Int(round(item.timeSlept)))" + ":00")
                            }
                            VStack {
                                Text("Time Woken: ")
                                    .padding(2)
                                    .font(.system(size: 15, weight: .semibold))
                                Text("\(Int(round(item.timeWoken)))" + ":00")
                            }
                            Spacer()
                        }
                        Text("Sleep Duration: \(Int(round(item.sleepDuration))) Hours")
                            .fontWeight(.medium)
                    }.listRowBackground(Color.white).listRowSeparatorTint(.black)
                }.navigationTitle("Journals:")
            }.onAppear() {
                ents = entries
                UITableView.appearance().backgroundColor = UIColor(Color("tan"))
            }
            VStack {
                HStack {
                    Spacer()
                    Button {
                        switchView = 2
                    } label: {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .padding(.top, 20)
                            .padding(.trailing, 30)
                    }
                    buttonView(ents: $ents, showPopup: $showPopup)
                        .padding(.trailing, 40)
                }
                Spacer()
            }
            if otherPopup == true {
                Color(.black)
                    .opacity(0.9)
                    .ignoresSafeArea()
            }
        }
        .popup(isPresented: $showPopup) {
            popupViewAdd(showPopup: $showPopup, ents: $ents)
        }
        .popup(isPresented: $otherPopup) {
            ZStack {
                Color("lightBlue")
                VStack {
                    Text("Welcome Back!")
                        .padding(.top, 40)
                        .foregroundColor(.black)
                    Spacer()
                    Button {
                        ents = entries
                        otherPopup = false
                    } label: {
                        Text("Continue")
                            .padding(3)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }.padding(.bottom, 40)
                    
                }
            }.frame(width: 200, height: 200).overlay(RoundedRectangle(cornerRadius: 5).stroke(.black))
        }
    }
}

// just the preview for developement reasons 
struct SwiftUIView_Previews: PreviewProvider {
    
    static var previews: some View {
        journalView(ents: .constant(entries),otherPopup: .constant(false), switchView: .constant(0))
        //popupViewAdd(showPopup: .constant(true), ents: .constant([]))
    }
}

// Relocated button
struct buttonView: View {
    
    @Binding var ents: [sleepEntry]
    @Binding var showPopup: Bool
    
    var body: some View {
        Button {
            showPopup.toggle()
        }  label: {
            Image(systemName: "plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top, 20)
                .frame(width: 20)
        }
    }
}

// MARK: - Popup
// The popup label
struct popupViewAdd: View {
    
    @State  var date: String = ""
    @State var timeSleptf: Double = 1
    @State var timeWokenf: Double = 1
    @Binding var showPopup: Bool
    @Binding var ents: [sleepEntry]
    @EnvironmentObject var signupVM : SignUpViewModel
    
    var body: some View {
        ZStack {
            Color("lightBlue")
                .cornerRadius(10)
            VStack (alignment: .leading) {
                Text("New Journal")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.vertical, 5)
                Text("Enter Date:")
                    .font(.system(size: 18, weight: .semibold))
                TextField("Date", text: $date)
                    .border(Color.black)
                    .frame(width:250)
                    .background(.white)
                Text("Time slept: ")
                    .fontWeight(.semibold)
                Picker("Time Slept", selection: $timeSleptf) {
                    ForEach(times) { item in
                        Text(item.timef).tag(item.tag)
                    }
                }.padding(.horizontal, 5).background(.white).border(.black)
                Text("Time Woken:")
                    .fontWeight(.semibold)
                Picker("Time Slept", selection: $timeWokenf) {
                    ForEach(times) { item in
                        Text(item.timef).tag(item.tag)
                    }
                }.padding(.horizontal, 5).background(.white).border(.black)
                HStack {
                    Spacer()
                    Button {
                        showPopup.toggle()
                    } label: {
                        Text("Cancel")
                            .padding(4)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(4)
                    }
                    Button {
                        entries.append(sleepEntry(date: date, timeSlept: timeSleptf, timeWoken: timeWokenf))
                        ents = entries
                        showPopup.toggle()
                        date = ""
                        //print(signupVM.loginName)
                        // updates the user database
                        let userRef = db.collection("users").document("\(String(describing: signupVM.loginName))")
                        userRef.updateData([
                            "data": encodeData(list: entries)
                        ]) { err in
                            if let err = err {
                                print(err)
                            } else {
                                print("document updated successfully")
                            }
                        }
                    } label: {
                        Text("Add")
                            .padding(4)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(4)
                    }.padding(.horizontal, 8)
                }
                
            }
            .padding(.leading, 8)
        }
        .frame(width: 300, height: 350).overlay(RoundedRectangle(cornerRadius: 10).stroke( .black))
    }
}
