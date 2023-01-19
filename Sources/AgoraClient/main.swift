//
//  AgoraClient.swift
//
//
//  Created by Dr. Brandon Wiley on 10/4/22.
//

import ArgumentParser
import Foundation

#if os(macOS) || os(iOS)
import os
#else
import Logging
#endif

import Gardener
import KeychainCli
import Nametag
import Net
import Simulation
import Spacetime
import Transmission
import Universe

import Agora

struct CommandLine: ParsableCommand
{
    static let configuration = CommandConfiguration(
        commandName: "agora-client",
        subcommands: [New.self, AddUser.self, GetUsers.self, DeleteUser.self, AddBoard.self, AddPost.self]
    )
}

extension CommandLine
{
    struct New: ParsableCommand
    {
        @Argument(help: "IP address of the server")
        var host: String

        @Argument(help: "port for the server")
        var port: Int

        mutating public func run() throws
        {
            let config = AgoraClientConfig(host: host, port: port)
            let encoder = JSONEncoder()
            let configData = try encoder.encode(config)
            let configURL = File.homeDirectory().appendingPathComponent("agora-client.json")
            try configData.write(to: configURL)
            print("Wrote config to \(configURL.path)")
        }
    }
}

extension CommandLine
{
    struct AddUser: ParsableCommand
    {
        @Argument(help: "URL for either Mastodon instance or RSS feed")
        var url: String

        @Argument(help: "username, only for Mastodon users")
        var username: String?

        mutating func run() throws
        {
            guard let serverUrl = URL(string: url) else
            {
                throw CommandLineError.notAUrl
            }

            let userInfo: User
            if let username = username
            {
                userInfo = User.Mastodon(MastodonUser(instance: serverUrl, username: username))
            }
            else
            {
                userInfo = User.RSS(serverUrl)
            }

            #if os(macOS) || os(iOS)
            let logger = Logger(subsystem: "org.OperatorFoundation.Agora", category: "AgoraClient")
            #else
            let logger = Logger(label: "org.OperatorFoundation.AgoraClient")
            #endif

            let configURL = File.homeDirectory().appendingPathComponent("agora-client.json")
            let configData = try Data(contentsOf: configURL)
            let decoder = JSONDecoder()
            let config = try decoder.decode(AgoraClientConfig.self, from: configData)
            print("Read config from \(configURL.path)")

            let simulation = Simulation(capabilities: Capabilities(.display, .networkConnect))
            let clientController = AgoraClientController(config: config, logger: logger, effects: simulation.effects, events: simulation.events)
            let connection = try clientController.connect()

            let client = AgoraClient(connection: connection)

            try client.addUser(userInfo: userInfo)
        }
    }
}

extension CommandLine
{
    struct GetUsers: ParsableCommand
    {
        mutating func run() throws
        {
            #if os(macOS) || os(iOS)
            let logger = Logger(subsystem: "org.OperatorFoundation.Agora", category: "AgoraClient")
            #else
            let logger = Logger(label: "org.OperatorFoundation.AgoraClient")
            #endif

            let configURL = File.homeDirectory().appendingPathComponent("agora-client.json")
            let configData = try Data(contentsOf: configURL)
            let decoder = JSONDecoder()
            let config = try decoder.decode(AgoraClientConfig.self, from: configData)
            print("Read config from \(configURL.path)")

            let simulation = Simulation(capabilities: Capabilities(.display, .networkConnect))
            let clientController = AgoraClientController(config: config, logger: logger, effects: simulation.effects, events: simulation.events)
            let connection = try clientController.connect()

            let client = AgoraClient(connection: connection)

            let results = try client.getUsers()
            print("Found \(results.count) users.")
            for result in results
            {
                let user = result.object
                switch user
                {
                    case .Mastodon(let value):
                        print("\(result.identifier) N\(value.instance) \(value.username)")

                    case .RSS(let value):
                        print(value)
                }
            }
        }
    }
}

extension CommandLine
{
    struct DeleteUser: ParsableCommand
    {
        @Argument(help: "ID of user to delete")
        var userid: UInt64

        mutating func run() throws
        {
#if os(macOS) || os(iOS)
            let logger = Logger(subsystem: "org.OperatorFoundation.Agora", category: "AgoraClient")
#else
            let logger = Logger(label: "org.OperatorFoundation.AgoraClient")
#endif

            let configURL = File.homeDirectory().appendingPathComponent("agora-client.json")
            let configData = try Data(contentsOf: configURL)
            let decoder = JSONDecoder()
            let config = try decoder.decode(AgoraClientConfig.self, from: configData)
            print("Read config from \(configURL.path)")

            let simulation = Simulation(capabilities: Capabilities(.display, .networkConnect))
            let clientController = AgoraClientController(config: config, logger: logger, effects: simulation.effects, events: simulation.events)
            let connection = try clientController.connect()

            let client = AgoraClient(connection: connection)
            try client.deleteUser(user: userid)
        }
    }
}

extension CommandLine
{
    struct AddBoard: ParsableCommand
    {
        @Argument(help: "name of board")
        var boardName: String

        mutating func run() throws
        {
#if os(macOS) || os(iOS)
            let logger = Logger(subsystem: "org.OperatorFoundation.Agora", category: "AgoraClient")
#else
            let logger = Logger(label: "org.OperatorFoundation.AgoraClient")
#endif

            let configURL = File.homeDirectory().appendingPathComponent("agora-client.json")
            let configData = try Data(contentsOf: configURL)
            let decoder = JSONDecoder()
            let config = try decoder.decode(AgoraClientConfig.self, from: configData)
            print("Read config from \(configURL.path)")

            let simulation = Simulation(capabilities: Capabilities(.display, .networkConnect))
            let clientController = AgoraClientController(config: config, logger: logger, effects: simulation.effects, events: simulation.events)
            let connection = try clientController.connect()

            let client = AgoraClient(connection: connection)
            let board = Board(name: boardName)
            try client.addBoard(board: board)
        }
    }
}

extension CommandLine
{
    struct AddPost: ParsableCommand
    {
        @Argument(help: "name of board to post on")
        var boardName: String

        @Argument(help: "userid to post as")
        var userid: UInt64

        @Argument(help: "title of post")
        var title: String

        @Argument(help: "body of post")
        var body: String

        mutating func run() throws
        {
#if os(macOS) || os(iOS)
            let logger = Logger(subsystem: "org.OperatorFoundation.Agora", category: "AgoraClient")
#else
            let logger = Logger(label: "org.OperatorFoundation.AgoraClient")
#endif

            let configURL = File.homeDirectory().appendingPathComponent("agora-client.json")
            let configData = try Data(contentsOf: configURL)
            let decoder = JSONDecoder()
            let config = try decoder.decode(AgoraClientConfig.self, from: configData)
            print("Read config from \(configURL.path)")

            let simulation = Simulation(capabilities: Capabilities(.display, .networkConnect))
            let clientController = AgoraClientController(config: config, logger: logger, effects: simulation.effects, events: simulation.events)
            let connection = try clientController.connect()

            let client = AgoraClient(connection: connection)

            guard let board = try client.getBoard(name: boardName) else
            {
                throw CommandLineError.unknownBoard(boardName)
            }

            guard let user = try client.getUser(identifier: userid) else
            {
                throw CommandLineError.unknownUser(userid)
            }

            let post = Post(title: title, body: body)
            try client.addPost(user: user, board: board, post: post)
        }
    }
}

public enum CommandLineError: Error
{
    case portInUse
    case couldNotGeneratePrivateKey
    case couldNotLoadKeychain
    case nametagError
    case notAUrl
    case connectionFailed
    case unknownBoard(String)
    case unknownUser(UInt64)
}

CommandLine.main()
