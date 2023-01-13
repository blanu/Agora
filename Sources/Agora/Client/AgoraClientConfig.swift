//
//  AgoraClientConfig.swift
//
//
//  Created by Dr. Brandon Wiley on 12/23/22.
//

import Foundation

public struct AgoraClientConfig: Codable
{
    let host: String
    let port: Int

    public init(host: String? = nil, port: Int)
    {
        self.host = host ?? "0.0.0.0"
        self.port = port
    }
}
