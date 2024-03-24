//
//  DraggableControllerState.swift
//  Dial
//
//  Created by KrLite on 2024/3/24.
//

import SwiftUI
import UniformTypeIdentifiers
import Defaults

class DraggableControllerState: NSObject, Codable {
    var controllerState: ControllerState
    
    init(_ controllerState: ControllerState) {
        self.controllerState = controllerState
    }
}

extension DraggableControllerState: NSItemProviderReading, NSItemProviderWriting {
    static var readableTypeIdentifiersForItemProvider: [String] {
        [
            UTType.draggableControllerState.identifier
        ]
    }
    
    static func object(
        withItemProviderData data: Data,
        typeIdentifier: String
    ) throws -> Self {
        try JSONDecoder().decode(Self.self, from: data)
    }
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        [
            UTType.draggableControllerState.identifier
        ]
    }
    
    func loadData(
        withTypeIdentifier typeIdentifier: String,
        forItemProviderCompletionHandler completionHandler: @escaping @Sendable (Data?, (any Error)?) -> Void
    ) -> Progress? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            completionHandler(try encoder.encode(self), nil)
        } catch {
            completionHandler(nil, error)
        }
        
        return nil
    }
}

extension DraggableControllerState: Transferable {
    static var transferRepresentation : some TransferRepresentation {
        CodableRepresentation(contentType: .draggableControllerState)
    }
}

struct DraggableControllerStateDelegate: DropDelegate {
    @Binding var current: ControllerState
    
    func performDrop(info: DropInfo) -> Bool {
        guard info.hasItemsConforming(to: [.draggableControllerState]) else { return false }
        
        let itemProviders = info.itemProviders(for: [.draggableControllerState])
        guard let itemProvider = itemProviders.first else { return false }
        
        itemProvider.loadObject(ofClass: DraggableControllerState.self) { draggableControllerState, _ in
            let draggableControllerState = draggableControllerState as? DraggableControllerState
            if let controllerState = draggableControllerState?.controllerState {
                guard
                    let currentIndex = Defaults[.controllerStates].firstIndex(of: current),
                    let index = Defaults[.controllerStates].firstIndex(of: controllerState)
                else { return }
                
                Defaults[.controllerStates].swapAt(currentIndex, index)
            }
        }
        
        return true
    }
}
