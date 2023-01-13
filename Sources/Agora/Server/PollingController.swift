//
//  PollingController.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/1/23.
//

import Foundation

import FeedKit
import Schedule

public class PollingController
{
    let server: AgoraServerController
    let timerQueue: DispatchQueue = DispatchQueue(label: "Schedule timer")

    var task: Task? = nil

    public init(server: AgoraServerController)
    {
        self.server = server

        self.start()
    }

    public func start()
    {
        self.task = Plan.every(1.minute).do(queue: .global(), action: self.poll)
    }

    public func stop()
    {
        if let task = self.task
        {
            task.cancel()
        }
    }

    func poll()
    {
        print("Polling users...")

        for user in self.server.logic.state.getUsers()
        {
            print(user)

            do
            {
                try self.fetchPosts(user)
            }
            catch
            {
                print(error)
            }
        }
        print("done.")
    }

    func fetchPosts(_ user: User) throws
    {
        switch user
        {
            case .Mastodon(let value):
                try self.fetchMastodonPosts(value)

            case .RSS(let value):
                try self.fetchRSSPosts(value)
        }
    }

    func fetchMastodonPosts(_ user: MastodonUser) throws
    {
        guard var url = URL(string: user.instance) else
        {
            throw PollingControllerError.invalidURL(user.instance)
        }

        url = url.appending(component: "\(user.username).rss")
        try self.fetchRSSPosts(url)
    }

    func fetchRSSPosts(_ url: URL) throws
    {
        print("Parsing \(url)")
        let parser = FeedParser(URL: url)
        let result = parser.parse()
        print(result)
        switch result
        {
            case .success(let feed):
                switch feed
                {
                    case .atom(let atom):
                        if let items = atom.entries
                        {
                            for item in items
                            {
                                print(item)
                            }
                        }

                    case .json(let json):
                        if let items = json.items
                        {
                            for item in items
                            {
                                print(item)
                            }
                        }

                    case .rss(let rss):
                        if let items = rss.items
                        {
                            for item in items
                            {
                                print(item)

                                if let title = item.title
                                {
                                    print(title)
                                }

                                if let content = item.content
                                {
                                    print(content)
                                }

                                if let description = item.description
                                {
                                    print(description)
                                }
                            }
                        }
                }

            case .failure(let error):
                throw error
        }
    }
}

public enum PollingControllerError: Error
{
    case invalidURL(String)
}
