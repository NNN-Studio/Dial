//
//  AcknowledgementsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/24.
//

import SwiftUI

struct PackageDescription {
    var name: String
    var owner: String
    var url: URL
    var license: URL
    var reason: Text? = nil
}

struct AcknowledgementsView: View {
    @Environment(\.openURL) private var openURL
    
    let dependencies: [PackageDescription] = [
        .init(
            name: "hidapi",
            owner: "libusb",
            url: URL(string: "https://github.com/libusb/hidapi")!,
            license: URL(string: "https://github.com/libusb/hidapi/blob/master/LICENSE.txt")!,
            reason: Text("HID device communications")
        ),
        .init(
            name: "Defaults",
            owner: "Sindre Sorhus",
            url: URL(string: "https://github.com/sindresorhus/Defaults")!,
            license: URL(string: "https://github.com/sindresorhus/Defaults/blob/main/license")!
        ),
        /*
        .init(
            name: "ISSoundAdditions",
            owner: "InerziaSoft",
            url: URL(string: "https://github.com/InerziaSoft/ISSoundAdditions")!,
            license: URL(string: "https://github.com/InerziaSoft/ISSoundAdditions/LICENSE")!
        ),
         */
        .init(
            name: "LaunchAtLogin",
            owner: "Sindre Sorhus",
            url: URL(string: "https://github.com/sindresorhus/LaunchAtLogin")!,
            license: URL(string: "https://github.com/sindresorhus/LaunchAtLogin/blob/main/license")!
        ),
        .init(
            name: "MenuBarExtraAccess",
            owner: "Orchetect",
            url: URL(string: "https://github.com/orchetect/MenuBarExtraAccess")!,
            license: URL(string: "https://github.com/orchetect/MenuBarExtraAccess/blob/main/LICENSE")!
        ),
        .init(
            name: "SettingsAccess",
            owner: "Orchetect",
            url: URL(string: "https://github.com/orchetect/SettingsAccess")!,
            license: URL(string: "https://github.com/orchetect/SettingsAccess/blob/main/LICENSE")!
        ),
        .init(
            name: "SFSafeSymbols",
            owner: "SF Safe Symbols",
            url: URL(string: "https://github.com/SFSafeSymbols/SFSafeSymbols")!,
            license: URL(string: "https://github.com/SFSafeSymbols/SFSafeSymbols/blob/stable/LICENSE")!
        )
    ]
    
    let specialThanks: [PackageDescription] = [
        .init(
            name: "MacDial",
            owner: "Andreas Karlsson",
            url: URL(string: "https://github.com/andreasjhkarlsson/mac-dial")!,
            license: URL(string: "https://github.com/andreasjhkarlsson/mac-dial/blob/main/LICENSE")!,
            reason: Text("Original project")
        ),
        .init(
            name: "Loop",
            owner: "Kai Azim",
            url: URL(string: "https://github.com/MrKai77/Loop")!,
            license: URL(string: "https://github.com/MrKai77/Loop/blob/develop/LICENSE")!,
            reason: Text("UI layout guide")
        )
    ]
    
    var body: some View {
        VStack {
            VStack {
                Text("Dependencies")
                    .foregroundStyle(.secondary)
                
                buildAcknowledgements(packages: dependencies)
            }
            .padding()
            .background {
                VisualEffectView(material: .fullScreenUI, blendingMode: .behindWindow)
                    .ignoresSafeArea(.all)
            }
            
            VStack {
                Text("Special Thanks")
                    .foregroundStyle(.secondary)
                
                buildAcknowledgements(packages: specialThanks)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func buildAcknowledgements(packages: [PackageDescription]) -> some View {
        VStack {
            ForEach(0..<packages.count, id: \.self) { index in
                let package = packages[index]
                
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(package.name)
                            .bold()
                            .padding(.bottom, 0)
                        
                        if let reason = package.reason {
                            reason
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.bottom, 2)
                        }
                        
                        HStack(spacing: 2) {
                            Text("By")
                                .opacity(0.4)
                            
                            Text(package.owner)
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 2)
                    }
                    
                    Spacer(minLength: 50)
                    
                    Button(action: {
                        openURL(package.url)
                    }, label: {
                        Image(systemSymbol: .safariFill)
                    })
                    .help("Main page")
                    
                    Button(action: {
                        openURL(package.license)
                    }, label: {
                        Image(systemSymbol: .docCircleFill)
                    })
                    .help("License")
                }
                .tag(index)
                .buttonStyle(.borderless)
                .imageScale(.large)
                .padding(.vertical, 2)
            }
        }
        .padding(10)
    }
}

#Preview {
    AcknowledgementsView()
        .frame(height: 600)
}
