//
//  AboutView.swift
//  Dial
//
//  Created by KrLite on 2024/3/24.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.openURL) private var openURL
    
    @State var isShowingAcknowledgements: Bool = false
    
    var body: some View {
        VStack {
            // MARK: - Info
            
            VStack(spacing: 5) {
                Image(nsImage: NSImage(named: "AppIcon")!)
                    .resizable()
                    .frame(width: 120, height: 120)
                
                Text(Bundle.main.appName)
                    .font(.title)
                    .fontWeight(.bold)
                
                AppVersionView()
            }
            
            Spacer()
            
            Text("Your Surface Dial on Mac.")
                .multilineTextAlignment(.center)
            
            Spacer()
            
            VStack {
                Button {
                    openURL(URL(string: "https://github.com/NNN-Studio/Dial")!)
                } label: {
                    Text("GitHub")
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                }
                .controlSize(.large)
                
                Button {
                    self.isShowingAcknowledgements = true
                } label: {
                    Text("Acknowledgements")
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                }
                .controlSize(.large)
                .popover(isPresented: $isShowingAcknowledgements, arrowEdge: .bottom) {
                    AcknowledgementsView()
                }
            }
            
            Link(destination: URL(string: "https://github.com/NNN-Studio/Dial/blob/main/LICENSE")!) {
                Text("MIT License")
                    .underline()
                    .font(.caption)
                    .textSelection(.disabled)
                    .foregroundColor(.secondary)
            }
            
            Text(Bundle.main.copyright)
                .textSelection(.disabled)
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding(20)
        .frame(width: 260, height: 380)
        .background {
            VisualEffectView(
                material: .hudWindow,
                blendingMode: .behindWindow
            ).ignoresSafeArea()
        }
    }
}

#Preview {
    AboutView()
}
