//
//  Board.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/8/23.
//

import Foundation

public class Board: Codable
{
    public var name: String

    public init(name: String)
    {
        self.name = name
    }
}

extension Board: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.name)
    }
}

extension Board: Equatable
{
    public static func == (lhs: Board, rhs: Board) -> Bool
    {
        return lhs.name == rhs.name
    }
}
