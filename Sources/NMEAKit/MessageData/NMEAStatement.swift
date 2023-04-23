//
//  NMEAStatement.swift
//  
//
//  Created by Rick Hohler on 10/24/22.
//

import Foundation

public struct NMEAStatement: Equatable {

    let line: String
    var components: [String]
    var lastError: Error? = nil

    var timingDataListener: (any StatementListener)?

    public init(_ line: String) {
        self.line = line
        self.components = [String](line.components(separatedBy: ","))
        do {
            if let result = try NMEAChecksum.lastElementValues(components: self.components) {
                self.components[self.components.count-1] = result.lastElement
                try NMEAChecksum.verify(line: self.line, expectedChecksumValue: result.checksum)
            }
        } catch {
            // any error in init will be stored in lastError
            self.lastError = error
        }

        if self.statementType() == GGAParser.messageId {
            self.timingDataListener = TimingDataNotifier.Listener()
        }
    }

    public func parseMessage() -> NMEAData {
        // check for an error caught in init method
        if let error = self.lastError {
            return NMEAData(message: NMEAMessage.error(error), statement: self)
        }
        
        let parser = ParserFactory.factory(statement: self)
        guard let parser = parser else {
            return NMEAData(message: NMEAMessage.error(StatementError.unsupportedMessageType), statement: self)
        }

        do {
            let message = try parser.buildMessage(self)
            return NMEAData(message: message, statement: self)
        } catch {
            return NMEAData(message: NMEAMessage.error(error), statement: self)
        }
    }
    
    func statementType() -> String {
        return components[0]
    }

    public static func == (lhs: NMEAStatement, rhs: NMEAStatement) -> Bool {
        lhs.line == rhs.line
    }
}

protocol StatementListener {
    associatedtype Value
    
    var value: Value? { get }
}
