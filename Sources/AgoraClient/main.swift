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
        subcommands: [New.self, AddUser.self]
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

public enum CommandLineError: Error
{
    case portInUse
    case couldNotGeneratePrivateKey
    case couldNotLoadKeychain
    case nametagError
    case notAUrl
    case connectionFailed
}

CommandLine.main()
