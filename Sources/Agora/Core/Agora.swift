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

    public func getUser(identifier: UInt64) -> Reference<User>?
    {
        do
        {
            return try self.state.getUser(identifier: identifier)
        }
        catch
        {
            print(error)
            return nil
        }
    }

    public func getUsers() throws -> [Reference<User>]
    {
        return self.state.getUsers()
    }

    public func deleteUser(user: UInt64) throws
    {
        try self.state.deleteUser(user: user)
    }

    public func addBoard(board: Board) throws
    {
        try self.state.addBoard(board: board)
    }

    public func getBoard(name: String) -> Reference<Board>?
    {
        return self.state.getBoard(name: name)
    }

    public func addPost(user: Reference<User>, board: Reference<Board>, post: Post) throws
    {
        try self.state.addPost(user: user, board: board, post: post)
    }
}
