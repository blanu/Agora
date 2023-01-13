//
//  Agora.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/3/23.
//

import Foundation

import Universe

public class Agora
{
    public let universe: Universe
    public let state: ServerState

    public init(_ universe: Universe) throws
    {
        self.universe = universe
        self.state = try ServerState(universe)
    }

    public func addUser(userInfo: User) throws
    {
        try self.state.addUser(userInfo)
    }
}
