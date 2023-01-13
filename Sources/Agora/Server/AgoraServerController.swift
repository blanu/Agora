//
//  AgoraServerController.swift
//
//
//  Created by Dr. Brandon Wiley on 12/16/22.
//

import Foundation
#if os(macOS) || os(iOS)
import os.log
#else
import Logging
#endif

import Chord
import Simulation
import Spacetime
import Transmission
import Universe

public class AgoraServerController: Universe
{
    public var logic: Agora! = nil

    let config: AgoraServerConfig

    var listener: Transmission.Listener? = nil
    var running: Bool = false
    var polling: PollingController? = nil
    var server: AgoraServer? = nil

    public init(config: AgoraServerConfig, logger: Logger, effects: BlockingQueue<Effect>, events: BlockingQueue<Event>) throws
    {
        self.config = config

        super.init(effects: effects, events: events, logger: logger)

        self.logic = try Agora(self)
        self.polling = PollingController(server: self)
    }

    public func start() throws
    {
        self.running = true

        let listener = try listen(self.config.host, self.config.port)
        self.listener = listener

        self.server = AgoraServer(listener: listener, handler: self.logic)
    }

    public func shutdown()
    {
        self.running = false

        if let listener = self.listener
        {
            listener.close()
        }
    }
}

