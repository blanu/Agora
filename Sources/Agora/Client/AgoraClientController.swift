//
//  AgoraClientController.swift
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

public class AgoraClientController: Universe
{
    let config: AgoraClientConfig

    var running: Bool = false

    public init(config: AgoraClientConfig, logger: Logger, effects: BlockingQueue<Effect>, events: BlockingQueue<Event>)
    {
        self.config = config

        super.init(effects: effects, events: events, logger: logger)
    }

    public func connect() throws -> Transmission.Connection
    {
        return try connect(self.config.host, self.config.port)
    }
}

