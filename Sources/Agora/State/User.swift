//
//  User.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/5/23.
//

import Foundation

import Universe

public enum User: Codable
{
    case Mastodon(MastodonUser)
    case RSS(URL)
}

extension User: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        switch self
        {
            case .Mastodon(let value):
                hasher.combine(value)

            case .RSS(let value):
                hasher.combine(value)
        }
    }
}

extension User: Equatable
{
    public static func == (lhs: User, rhs: User) -> Bool
    {
        switch lhs
        {
            case .Mastodon(let lvalue):
                switch rhs
                {
                    case .Mastodon(let rvalue):
                        return lvalue == rvalue

                    default:
                        return false
                }

            case .RSS(let lvalue):
                switch rhs
                {
                    case .RSS(let rvalue):
                        return lvalue == rvalue

                    default:
                        return false
                }
        }
    }
}

public class MastodonUser: Codable
{
    public var instance: String
    public var username: String

    public init(instance: URL, username: String)
    {
        self.instance = instance.absoluteString
        self.username = username
    }
}

extension MastodonUser: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(instance)
        hasher.combine(username)
    }
}

extension MastodonUser: Equatable
{
    public static func == (lhs: MastodonUser, rhs: MastodonUser) -> Bool
    {
        return (lhs.instance == rhs.instance) && (lhs.username == rhs.username)
    }
}
