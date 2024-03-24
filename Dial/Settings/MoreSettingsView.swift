//
//  MoreSettingsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/20.
//

import SwiftUI

struct MoreSettingsView: View {
    @Environment(\.openURL) private var openURL
    
    @State var test: Bool = false
    @State var isAccessibilityAccessGranted: Bool = false
    
    var body: some View {
        Form {
            Section {
                Toggle("Automatically checks for updates", isOn: $test)
            } header: {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Updates")
                        
                        HStack {
                            Text("Version \(Bundle.main.appVersion) (\(Bundle.main.appBuild))")
                            
                            Button(action: {
                                let pasteboard = NSPasteboard.general
                                pasteboard.clearContents()
                                pasteboard.setString(
                                    "\(Bundle.main.appVersion) (\(Bundle.main.appBuild))",
                                    forType: NSPasteboard.PasteboardType.string
                                )
                            }, label: {
                                Image(systemSymbol: .clipboardFill)
                            })
                            .buttonStyle(.plain)
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button("Check for Updates…") {
                        //updater.checkForUpdates()
                        print("Check for updates")
                    }
                    .buttonStyle(.link)
                    .foregroundStyle(Color.accentColor)
                }
            }
            
            Section {
                HStack(alignment: .firstTextBaseline) {
                    Text("Accessibility Access")
                    
                    Spacer()
                    
                    Text("Granted")
                        .or(condition: !isAccessibilityAccessGranted) {
                            Text("Not Granted")
                        }
                    
                    Circle()
                        .frame(width: 8, height: 8)
                        .padding(.trailing, 5)
                        .foregroundColor(isAccessibilityAccessGranted ? .green : .red)
                        .shadow(color: isAccessibilityAccessGranted ? .green : .red, radius: 8)
                }
            } header: {
                HStack {
                    Text("Permissions")
                    
                    Spacer()
                    
                    Button("Request Access…", action: {
                        withAnimation {
                            PermissionsManager.requestAccess()
                            isAccessibilityAccessGranted = PermissionsManager.Accessibility.getStatus()
                        }
                    })
                    .buttonStyle(.link)
                    .foregroundStyle(Color.accentColor)
                    .disabled(isAccessibilityAccessGranted)
                    .opacity(isAccessibilityAccessGranted ? 0.2 : 1)
                    .task {
                        isAccessibilityAccessGranted = PermissionsManager.Accessibility.getStatus()
                    }
                }
            }
            
            Section("Feedback") {
                HStack {
                    Text(
                        "Description"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    ShrinkableEqualWidthVStack {
                        Button {
                            openURL(URL(string: "placeholder")!)
                        } label: {
                            Text("Send Feedback…")
                                .frame(maxWidth: .infinity)
                            
                            Image(systemSymbol: .rectanglePortraitAndArrowRight)
                                .frame(width: 20, alignment: .center)
                        }
                        
                        Button {
                            
                        } label: {
                            Text("About \(Bundle.main.appName)…")
                                .frame(maxWidth: .infinity)
                            
                            Image(systemSymbol: .infoCircle)
                                .frame(width: 20, alignment: .center)
                        }
                    }
                    .controlSize(.extraLarge)
                }
            }
        }
        .formStyle(.grouped)
        .scrollDisabled(true)
    }
}

#Preview {
    MoreSettingsView()
}
