//
//  AgoraServer.swift
//
//
//  Created by Dr. Brandon Wiley on 10/4/22.
//

import ArgumentParser
import Lifecycle
import Foundation

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
#else
import FoundationNetworking
#endif

#if os(macOS) || os(iOS)
import os.log
#else
import Logging
#endif

import NIO

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
        commandName: "agora-server",
        subcommands: [New.self, Run.self]
    )
}

extension CommandLine
{
    struct New: ParsableCommand
    {
        @Argument(help: "Human-readable name for your listener to use in invites")
        var name: String

        @Argument(help: "Port on which to run the listener")
        var port: Int

        mutating public func run() throws
        {
            let ip: String = try Ipify.getPublicIP()

            if let test = TransmissionConnection(host: ip, port: port)
            {
                test.close()

                throw NewCommandError.portInUse
            }

            let config = AgoraServerConfig(host: ip, port: port)
            let encoder = JSONEncoder()
            let configData = try encoder.encode(config)
            let configURL = File.homeDirectory().appendingPathComponent("agora-server.json")
            try configData.write(to: configURL)
            print("Wrote config to \(configURL.path)")
        }
    }
}

extension CommandLine
{
    struct Run: ParsableCommand
    {
        mutating func run() throws
        {
#if os(macOS) || os(iOS)
            let logger = Logger(subsystem: "org.OperatorFoundation.AgoraServer", category: "Agora")
#else
            let logger = Logger(label: "org.OperatorFoundation.AgoraServer")
#endif

            let configURL = File.homeDirectory().appendingPathComponent("agora-server.json")
            let configData = try Data(contentsOf: configURL)
            let decoder = JSONDecoder()
            let config = try decoder.decode(AgoraServerConfig.self, from: configData)
            print("Read config from \(configURL.path)")

            let lifecycle = ServiceLifecycle()

            let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
            lifecycle.registerShutdown(label: "eventLoopGroup", .sync(eventLoopGroup.syncShutdownGracefully))

            let simulation = Simulation(capabilities: Capabilities(.display, .networkListen))
            let listener = try AgoraServerController(config: config, logger: logger, effects: simulation.effects, events: simulation.events)

            lifecycle.register(label: "server", start: .sync(listener.start), shutdown: .sync(listener.shutdown))

            lifecycle.start
            {
                error in

                if let error = error
                {
                    logger.error("failed starting automat-listener ☠️: \(error)")
                }
                else
                {
                    logger.info("automat-listener started successfully 🚀")
                }
            }

            lifecycle.wait()
        }
    }
}

public enum NewCommandError: Error
{
    case portInUse
    case couldNotGeneratePrivateKey
    case couldNotLoadKeychain
    case nametagError
}

CommandLine.main()
