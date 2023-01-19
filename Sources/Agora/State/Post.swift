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

extension Post: Equatable
{
    public static func == (lhs: Post, rhs: Post) -> Bool
    {
        if let ltitle = lhs.title
        {
            guard let rtitle = rhs.title else
            {
                return false
            }

            guard ltitle == rtitle else
            {
                return false
            }
        }
        else
        {
            guard rhs.title == nil else
            {
                return false
            }
        }

        return lhs.body == rhs.body
    }
}
