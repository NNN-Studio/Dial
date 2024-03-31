//
//  KeyboardRecorderView.swift
//  Dial
//
//  Created by KrLite on 2024/3/30.
//

import SwiftUI

class KeyboardRecorderModel: ObservableObject {
    @Published var eventMonitor: NSEventMonitor?
}

struct KeyboardRecorderView: View {
    @EnvironmentObject private var model: KeyboardRecorderModel
    
    @Binding private var currentShortcuts: ShortcutArray
    @State private var previewShortcuts: ShortcutArray
    
    @State private var eventMonitor: NSEventMonitor?
    
    @State private var isHovering: Bool = false
    @State private var isActive: Bool = false
    @State private var isCurrentlyPressed: Bool = false
    
    init(_ keybind: Binding<ShortcutArray>) {
        self._currentShortcuts = keybind
        self._previewShortcuts = State(initialValue: keybind.wrappedValue)
    }
    
    let activeAnimation = Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)
    let noAnimation = Animation.linear(duration: 0)
    
    @ViewBuilder
    func buildBackgroundView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .foregroundStyle(.background)
            RoundedRectangle(cornerRadius: 6)
                .strokeBorder(
                    .tertiary.opacity((isHovering || isActive) ? 1 : 0.5),
                    lineWidth: 1
                )
        }
    }
    
    @ViewBuilder
    func buildModifierViews(_ modifiers: NSEvent.ModifierFlags) -> some View {
        ForEach(modifiers.sortedKeys) { modifier in
            buildBorderedView {
                modifier.symbol.image
            }
        }
    }
    
    @ViewBuilder
    func buildBorderedView(square: Bool = true, _ content: () -> some View) -> some View {
        content()
            .monospaced()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(square ? 1 : nil, contentMode: .fill)
            .padding(5)
            .background {
                buildBackgroundView()
            }
            .fixedSize(horizontal: true, vertical: false)
    }
    
    var body: some View {
        Button {
            guard !self.isActive else { return }
            self.startObservingKeys()
        } label: {
            HStack {
                if self.previewShortcuts.isEmpty {
                    buildBorderedView(square: false) {
                        Text("None")
                            .or(condition: isActive) {
                                Text("Press a key…")
                            }
                    }
                } else {
                    if !previewShortcuts.modifiers.isEmpty {
                        buildModifierViews(previewShortcuts.modifiers)
                        
                        Image(systemSymbol: .plus)
                            .imageScale(.large)
                            .frame(width: 24)
                            .foregroundStyle(.placeholder)
                    }
                    
                    ForEach(previewShortcuts.sortedKeys) { key in
                        buildBorderedView {
                            Text(key.name)
                        }
                    }
                }
            }
            .contentShape(Rectangle())
        }
        .contextMenu {
            Button(role: .destructive) {
                currentShortcuts = ShortcutArray()
                finishedObservingKeys(wasForced: true)
            } label: {
                Text("Reset")
                    .foregroundStyle(.red)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isCurrentlyPressed ? 0.9 : 1)
        .onHover { isHovering in
            self.isHovering = isHovering
        }
        .onChange(of: model.eventMonitor) { _, _ in
            if model.eventMonitor != self.eventMonitor {
                finishedObservingKeys(wasForced: true)
            }
        }
        .onChange(of: currentShortcuts) { _, _ in
            if previewShortcuts != currentShortcuts {
                previewShortcuts = currentShortcuts
            }
        }
    }
    
    func startObservingKeys() {
        previewShortcuts = ShortcutArray()
        isActive = true
        
        eventMonitor = NSEventMonitor(scope: .local, eventMask: [
            .keyDown, .keyUp, .flagsChanged
        ]) { event in
            if event.type == .flagsChanged {
                previewShortcuts.modifiers = event.modifierFlags
                
                if let key = Input(rawValue: Int32(event.keyCode)), key != .unknown {
                    previewShortcuts.keys.insert(key)
                }
                
                withAnimation(.snappy(duration: 0.1)) {
                    isCurrentlyPressed = true
                }
            }
            
            if event.type == .keyUp {
                finishedObservingKeys()
                return
            }
            
            if event.type == .keyDown  && !event.isARepeat {
                if let key = Input(rawValue: Int32(event.keyCode)), key != .unknown {
                    if key == .keyEscape {
                        finishedObservingKeys(wasForced: true)
                        return
                    }
                    
                    self.previewShortcuts.keys.insert(key)
                    
                    withAnimation(.snappy(duration: 0.1)) {
                        isCurrentlyPressed = true
                    }
                }
            }
        }
        
        eventMonitor!.start()
        model.eventMonitor = eventMonitor
    }
    
    func finishedObservingKeys(wasForced: Bool = false) {
        isActive = false
        var willSet = !wasForced
        
        withAnimation(.snappy(duration: 0.1)) {
            isCurrentlyPressed = false
        }
        
        if currentShortcuts == previewShortcuts {
            willSet = false
        }
        
        if willSet {
            // Set the valid keybind to the current selected one
            currentShortcuts = previewShortcuts
        } else {
            // Set preview keybind back to previous one
            previewShortcuts = currentShortcuts
        }
        
        eventMonitor?.stop()
        eventMonitor = nil
    }
}
