//
//  ContentView.swift
//  RandomContacts
//
//  Created by Jinwoo Kim on 1/6/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel: ContentViewModel = .init()
    
    private var trailingButtons: some View {
        HStack {
            Button("Presets") {
                viewModel.isPresetSheetPresented = true
            }
            
            Button("Delete") {
                viewModel.error = nil
                do {
                    try viewModel.deleteContacts()
                } catch {
                    viewModel.error = error
                }
                viewModel.isResultAlertPresented = true
            }
            
            Button("Save") {
                viewModel.error = nil
                do {
                    try viewModel.saveContacts()
                } catch {
                    viewModel.error = error
                }
                viewModel.isResultAlertPresented = true
            }
        }
    }
    
    internal var body: some View {
        NavigationView {
            ScrollView {
                HStack(alignment: .center, spacing: 0) {
                    Text("Contacts count")
                        .fontWeight(.heavy)
                        .frame(width: 140)
                        .padding()
                    TextField("(Required)", text: $viewModel.countToSave)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding()
                }
                
                HStack(alignment: .center, spacing: 0) {
                    Text("Region code")
                        .fontWeight(.heavy)
                        .frame(width: 140)
                        .padding()
                    TextField("(Optional)", text: $viewModel.regionCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding()
                }
                
                HStack(alignment: .center, spacing: 0) {
                    Text("Starting number")
                        .fontWeight(.heavy)
                        .frame(width: 140)
                        .padding()
                    TextField("(Optional)", text: $viewModel.startingNumberWith)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding()
                }
                
                HStack(alignment: .center, spacing: 0) {
                    Text("Digits")
                        .fontWeight(.heavy)
                        .frame(width: 140)
                        .padding()
                    TextField("(Required)", text: $viewModel.digits)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding()
                }
                
                HStack(alignment: .center, spacing: 0) {
                    Text("Name lauguage")
                        .fontWeight(.heavy)
                        .frame(width: 140)
                        .padding()
                    Picker(selection: $viewModel.nameLangType, label: Text("")) {
                        ForEach(0..<ContentViewModel.LangType.allCases.count) { idx in
                            switch ContentViewModel.LangType(rawValue: idx) {
                            case .english:
                                Text("English")
                            case .korean:
                                Text("Korean")
                            default:
                                Text("English")
                            }
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Text("All contacts info are generated by random. You can delete them by pressing Delete button.")
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .navigationTitle("RandomContacts")
            .navigationBarItems(trailing: trailingButtons)
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .actionSheet(isPresented: $viewModel.isPresetSheetPresented) {
            ActionSheet(title: Text("Select a preset"), message: nil, buttons: [
                .default(Text("English number")) { viewModel.setPreset(of: .english) },
                .default(Text("Korean number")) { viewModel.setPreset(of: .korean) },
                .cancel()
            ])
        }
        .alert(isPresented: $viewModel.isResultAlertPresented, content: {
            Alert(title: Text("Result"),
                  message: Text(viewModel.error?.localizedDescription ?? "Success!"),
                  dismissButton: .default(Text("Done"))
            )
        })
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
