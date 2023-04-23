//
//  StatementParser.swift
//  
//
//  Created by Rick Hohler on 8/23/22.
//

struct ParserFactory {
    
    static func factory(statement: NMEAStatement) -> StatementParser? {
        switch statement.statementType() {
        case GGAParser.messageId:
            return GGAParser()
        case GLLParser.messageId:
            return GLLParser()
        case GSAParser.messageId:
            return GSAParser()
        case GSVParser.messageId:
            return GSVParser()
        case RMCParser.messageId:
            return RMCParser()
        case ZDAParser.messageId:
            return ZDAParser()
        default:
            return nil
        }
    }
}

protocol StatementParser {

    func buildMessage(_ statement: NMEAStatement) throws -> NMEAMessage
}
