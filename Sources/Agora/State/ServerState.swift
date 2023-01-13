//
//  ServerState.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/1/23.
//

import Foundation

import Universe

public class ServerState
{
    let universe: Universe

    public init(_ universe: Universe) throws
    {
        self.universe = universe
    }

    public func addUser(_ userInfo: User) throws
    {
        let identifier = try self.universe.allocateIdentifier()
        try self.universe.save(identifier: identifier, object: userInfo)
    }

    public func getUsers() -> [User]
    {
        do
        {
            let users: IndexedCollection<UserInfo> = try self.universe.load()
            return users.map { return $0.object }
        }
        catch
        {
            print(error)
            return []
        }
    }
}
