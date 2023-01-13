////
////  AgoraMessage.swift
////  
////
////  Created by Dr. Brandon Wiley on 12/24/22.
////
//
//import Foundation
//
//import KeychainCli
//
//public enum AgoraMessage: Codable
//{
//    case Hello(Hello)
//    case CreateBoard(CreateBoard)
//    case SetMetadata(SetMetadata)
//    case GetMetadata(GetMetadata)
//    case Post(Post)
//    case AddUser(AddUser)
//}
//
//public struct Hello: Codable
//{
//    let name: String
//
//    public init(name: String)
//    {
//        self.name = name
//    }
//}
//
//public struct CreateBoard: Codable
//{
//    let id: UUID
//    let name: String
//
//    public init(id: UUID, name: String)
//    {
//        self.id = id
//        self.name = name
//    }
//}
//
//public struct SetMetadata: Codable
//{
//    let creator: PublicKey
//    let id: UUID
//    let key: URL
//    let value: String
//
//    public init(creator: PublicKey, id: UUID, key: URL, value: String)
//    {
//        self.creator = creator
//        self.id = id
//        self.key = key
//        self.value = value
//    }
//}
//
//public struct GetMetadata: Codable
//{
//    let creator: PublicKey
//    let id: UUID?
//    let key: URL?
//
//    public init(creator: PublicKey, id: UUID?, key: URL?)
//    {
//        self.creator = creator
//        self.id = id
//        self.key = key
//    }
//}
//
//public struct Post: Codable
//{
//    let boardCreator: PublicKey
//    let boardId: UUID
//    let postId: UUID
//    let replyTo: UUID?
//    let title: String?
//    let contents: String
//
//    public init(boardCreator: PublicKey, boardId: UUID, postID: UUID, replyTo: UUID?, title: String?, contents: String)
//    {
//        self.boardCreator = boardCreator
//        self.boardId = boardId
//        self.postId = postID
//        self.replyTo = replyTo
//        self.title = title
//        self.contents = contents
//    }
//}
//
//
//
//
//
//
//
//
