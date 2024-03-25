//
//  MoreSettingsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/20.
//

import SwiftUI
import Defaults

struct MoreSettingsView: View {
    @Environment(\.openURL) private var openURL
    
    @State var test: Bool = false
    @State var isAccessibilityAccessGranted: Bool = false
    @State var isShowingDataRestoration: Bool = false
    
    @State var isShowingRestoreGlobalConfigurationsDialog: Bool = false
    @State var isShowingRestoreControllersDataDialog: Bool = false
    
    var body: some View {
        Form {
            Section {
                Toggle("Automatically checks for updates", isOn: $test)
            } header: {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Updates")
                        
                        AppVersionView()
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
            
            Section("Fundamental") {
                HStack {
                    Text("""
By sending feedbacks, you can report bugs, request features or more. Issue templates are provided for detailing your feedbacks.
""")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    ShrinkableEqualWidthVStack {
                        Button {
                            openURL(URL(string: "placeholder")!)
                        } label: {
                            Image(systemSymbol: .rectanglePortraitAndArrowRight)
                                .frame(width: 20, alignment: .center)
                            
                            Text("Send Feedback…")
                                .frame(maxWidth: .infinity)
                        }
                        
                        Button {
                            NSApp.setActivationPolicy(.regular)
                            AboutViewController.open()
                        } label: {
                            Image(systemSymbol: .infoCircle)
                                .frame(width: 20, alignment: .center)
                            
                            Text("About \(Bundle.main.appName)…")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .controlSize(.extraLarge)
                }
            }
            
            Section("Data Reset", isExpanded: $isShowingDataRestoration) {
                VStack {
                    Button {
                        isShowingRestoreGlobalConfigurationsDialog = true
                    } label: {
                        Text("Reset All Global Configurations")
                            .frame(maxWidth: .infinity)
                    }
                    .confirmationDialog(
                        "Are You Sure to Reset All Global Configurations?",
                        isPresented: $isShowingRestoreGlobalConfigurationsDialog,
                        titleVisibility: .visible
                    ) {
                        Button("Reset", role: .destructive) {
                            Defaults.reset(
                                .globalHapticsEnabled,
                                .menuBarItemEnabled,
                                .menuBarItemAutoHidden,
                                .globalSensitivity,
                                .globalDirection
                            )
                            
                            print("!!! Reset all global configurations !!!")
                        }
                    }
                    
                    Button(role: .destructive) {
                        isShowingRestoreControllersDataDialog = true
                    } label: {
                        Text("Reset Controllers Data")
                            .frame(maxWidth: .infinity)
                    }
                    .confirmationDialog(
                        "Are You Sure to Reset Controllers Data?",
                        isPresented: $isShowingRestoreControllersDataDialog,
                        titleVisibility: .visible
                    ) {
                        Button("Reset", role: .destructive) {
                            Defaults.reset(
                                .activatedControllerIDs,
                                .nonactivatedControllerIDs,
                                .currentControllerID
                            )
                            
                            print("!!! Reset controllers data !!!")
                        }
                    }
                }
                .controlSize(.extraLarge)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        .formStyle(.grouped)
        .scrollDisabled(true)
    }
}

#Preview {
    MoreSettingsView()
}
