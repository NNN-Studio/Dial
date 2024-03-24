//
//  DraggableControllerState.swift
//  Dial
//
//  Created by KrLite on 2024/3/24.
//

import SwiftUI
import UniformTypeIdentifiers

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
