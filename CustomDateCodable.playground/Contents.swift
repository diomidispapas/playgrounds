//: Playground - noun: a place where people can play

import UIKit

// https://rss.itunes.apple.com/api/v1/gb/podcasts/top-podcasts/all/3/explicit.json
let json = """
{
"feed": {
"title":"Top Audio Podcasts",
"country":"gb",
"updated":"2017-11-16T02:02:55.000-08:00",
"results":[
{
"artistName":"BBC Radio",
"name":"Blue Planet II: The Podcast",
"releaseDate":"2017-11-12",
"url":"https://itunes.apple.com/gb/podcast/blue-planet-ii-the-podcast/id1296222557?mt=2"
},
{
"artistName":"Audible",
"name":"The Butterfly Effect with Jon Ronson",
"releaseDate":"2017-11-03",
"url":"https://itunes.apple.com/gb/podcast/the-butterfly-effect-with-jon-ronson/id1258779354?mt=2"
},
{
"artistName":"TED",
"name":"TED Talks Daily",
"releaseDate":"2017-11-16",
"url":"https://itunes.apple.com/gb/podcast/ted-talks-daily/id160904630?mt=2"
}
]
}
}
"""

struct RSSFeed: Codable {
    struct Feed: Codable {
        struct Podcast: Codable {
            let artistName: String
            let name: String
            let releaseDate: Date
            let url: URL
            
            private enum CodingKeys: String, CodingKey {
                case artistName
                case name
                case releaseDate
                case url
            }
        }
        
        let title: String
        let country: String
        let updated: Date
        let podcasts: [Podcast]
        
        private enum CodingKeys: String, CodingKey {
            case title
            case country
            case updated
            case podcasts = "results"
        }
    }
    let feed: Feed
}

typealias Feed = RSSFeed.Feed
typealias Podcast = Feed.Podcast

extension DateFormatter {
    
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return formatter
    }()
    
    static let yyyyMMdd: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        return dateFormatter
    }()
}

extension Podcast {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        artistName = try container.decode(String.self, forKey: .artistName)
        url = try container.decode(URL.self, forKey: .url)
        
        let dateString = try container.decode(String.self, forKey: .releaseDate)
        let formatter = DateFormatter.yyyyMMdd
        if let date = formatter.date(from: dateString) {
            releaseDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .releaseDate,
                                                   in: container,
                                                   debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}

let data = Data(json.utf8)
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
let rssFeed = try! decoder.decode(RSSFeed.self, from: data)

let feed = rssFeed.feed
print(feed.title, feed.country, feed.updated)

feed.podcasts.forEach {
    print($0.name)
}
