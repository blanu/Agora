//
//  Post.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/8/23.
//

import Foundation

public class Post: Codable
{
    public var title: String?
    public var body: String

    public init(title: String?, body: String)
    {
        self.title = title
        self.body = body
    }
}
