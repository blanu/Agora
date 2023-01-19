//
//  ServerState.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/1/23.
//

import Foundation

import Spacetime
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
        let reference = try Reference<User>(universe: self.universe, object: userInfo)
        try reference.save()
    }

    public func getUser(identifier: UInt64) throws -> Reference<User>
    {
        return try self.universe.load(identifier: identifier)
    }

    public func getUsers() -> [Reference<User>]
    {
        do
        {
            let users: IndexedCollection<User> = try self.universe.load()
            return users.map { return $0 }
        }
        catch
        {
            print(error)
            return []
        }
    }

    public func deleteUser(user: UInt64) throws
    {
        let ref: Reference<User> = try self.universe.load(identifier: user)
        self.deleteUser(identifier: ref.identifier)
    }

    public func deleteUser(identifier: UInt64)
    {
        do
        {
            let ref: Reference<User> = try self.universe.load(identifier: identifier)
            try ref.delete()
        }
        catch
        {
            print(error)
            return
        }
    }

    public func addBoard(board: Board) throws
    {
        let reference = try Reference<Board>(universe: self.universe, object: board)
        try reference.save()
    }

    public func getBoard(name: String) -> Reference<Board>?
    {
        return self.getBoards().first { $0.object.name == name }
    }

    public func getBoards() -> [Reference<Board>]
    {
        do
        {
            let boards: IndexedCollection<Board> = try self.universe.load()
            return boards.map { $0 }
        }
        catch
        {
            print(error)
            return []
        }
    }

    public func deleteBoard(board: Board) throws
    {
        let boards: IndexedCollection<Board> = try self.universe.load()
        let ref = boards.first { $0.object == board }
        guard let ref = ref else
        {
            throw ServerStateError.noMatchForObject
        }

        self.deleteBoard(identifier: ref.identifier)
    }

    public func deleteBoard(identifier: UInt64)
    {
        do
        {
            let ref: Reference<Board> = try self.universe.load(identifier: identifier)
            try ref.delete()
        }
        catch
        {
            print(error)
            return
        }
    }


    public func addPost(user: Reference<User>, board: Reference<Board>, post: Post) throws
    {
        user.connect(universe: universe)
        board.connect(universe: universe)

        guard try user.exists() else
        {
            throw ServerStateError.badUser
        }

        guard try board.exists() else
        {
            throw ServerStateError.badBoard
        }

        let postRef = try Reference<Post>(universe: self.universe, object: post)
        try postRef.save()

        try self.universe.saveRelationship(relationship: Relationship(subject: board, relation: Relation.contains, object: postRef))
        try self.universe.saveRelationship(relationship: Relationship(subject: user, relation: Relation.authors, object: postRef))
    }

    public func getPosts(board: Reference<Board>) throws -> [Reference<Post>]
    {
        return try self.universe.query(subject: board, relation: .contains).map
        {
            relationship in

            return try Reference<Post>(universe: self.universe, identifier: relationship.object)
        }
    }

    public func deletePost(post: Reference<Post>) throws
    {
        post.connect(universe: universe)

        guard try post.exists() else
        {
            throw ServerStateError.badPost
        }

        try post.delete()
    }

    public func deletePost(identifier: UInt64) throws
    {
        let post: Reference<Post> = try Reference(universe: self.universe, identifier: identifier)
        try post.delete()
    }
}

public enum ServerStateError: Error
{
    case noMatchForObject
    case badUser
    case badBoard
    case badPost
}
