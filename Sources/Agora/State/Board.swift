//
//  Board.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/8/23.
//

import Foundation

public class Board: Codable
{
    public var instance: String
    public var username: String

    public init(instance: URL, username: String)
    {
        self.instance = instance.absoluteString
        self.username = username
    }
}
