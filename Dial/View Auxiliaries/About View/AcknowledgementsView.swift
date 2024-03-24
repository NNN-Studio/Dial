//
//  AcknowledgementsView.swift
//  Dial
//
//  Created by KrLite on 2024/3/24.
//

import SwiftUI

struct PackageDescription {
    var owner: String
    var name: String
    var url: URL
    var license: URL
    var reason: Text? = nil
}

struct AcknowledgementsView: View {
    @Environment(\.openURL) private var openURL
    
    let dependencies: [PackageDescription] = [
        .init(
            owner: "Sindre Sorhus",
            name: "Defaults",
            url: URL(string: "https://github.com/sindresorhus/Defaults")!,
            license: URL(string: "https://github.com/sindresorhus/Defaults/blob/main/license")!
        ),
        .init(
            owner: "Sindre Sorhus",
            name: "LaunchAtLogin",
            url: URL(string: "https://github.com/sindresorhus/LaunchAtLogin")!,
            license: URL(string: "https://github.com/sindresorhus/LaunchAtLogin/blob/main/license")!
        ),
        .init(
            owner: "Orchetect",
            name: "MenuBarExtraAccess",
            url: URL(string: "https://github.com/orchetect/MenuBarExtraAccess")!,
            license: URL(string: "https://github.com/orchetect/MenuBarExtraAccess/blob/main/LICENSE")!
        ),
        .init(
            owner: "Orchetect",
            name: "SettingsAccess",
            url: URL(string: "https://github.com/orchetect/SettingsAccess")!,
            license: URL(string: "https://github.com/orchetect/SettingsAccess/blob/main/LICENSE")!
        ),
        .init(
            owner: "SF Safe Symbols",
            name: "SFSafeSymbols",
            url: URL(string: "https://github.com/SFSafeSymbols/SFSafeSymbols")!,
            license: URL(string: "https://github.com/SFSafeSymbols/SFSafeSymbols/blob/stable/LICENSE")!
        )
    ]
    
    let specialThanks: [PackageDescription] = [
        .init(
            owner: "Andreas Karlsson",
            name: "MacDial",
            url: URL(string: "https://github.com/andreasjhkarlsson/mac-dial")!,
            license: URL(string: "https://github.com/andreasjhkarlsson/mac-dial/blob/main/LICENSE")!,
            reason: .init("Original project")
        ),
        .init(
            owner: "Kai Azim",
            name: "Loop",
            url: URL(string: "https://github.com/MrKai77/Loop")!,
            license: URL(string: "https://github.com/MrKai77/Loop/blob/develop/LICENSE")!,
            reason: .init("UI layout guide")
        )
    ]
    
    var body: some View {
        VStack {
            Text("Dependencies")
                .foregroundStyle(.secondary)
                .padding(.top, 12)
            
            buildAcknowledgements(packages: dependencies)
            
            Spacer()
            
            VStack {
                Text("Special Thanks")
                    .foregroundStyle(.secondary)
                    .padding(.top, 12)
                
                buildAcknowledgements(packages: specialThanks)
            }
            .background {
                VisualEffectView(material: .fullScreenUI, blendingMode: .behindWindow)
                    .ignoresSafeArea(.all)
            }
        }
    }
    
    @ViewBuilder
    func buildAcknowledgements(packages: [PackageDescription]) -> some View {
        VStack {
            ForEach(0..<packages.count, id: \.self) { index in
                let package = packages[index]
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(package.name)
                            .bold()
                        
                        if let reason = package.reason {
                            reason
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.bottom, 2)
                        }
                        
                        HStack(spacing: 3) {
                            Text("By")
                                .opacity(0.4)
                            
                            Text(package.owner)
                        }
                        .font(.caption)
                        .textScale(.secondary)
                        .foregroundStyle(.secondary)
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
                .buttonBorderShape(.circle)
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
