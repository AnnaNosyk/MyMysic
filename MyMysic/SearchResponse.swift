//
//  SongModel.swift
//  MyMysic
//
//  Created by Anna Nosyk on 20/07/2022.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Song]
}

struct Song: Decodable {
    var trackName: String
    var collectionName: String?
    var artistName: String
    var artworkUrl100: String?
}
