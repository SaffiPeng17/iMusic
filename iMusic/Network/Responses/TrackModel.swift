//
//  TrackModel.swift
//  iMusic
//
//  Created by Saffi on 2022/2/13.
//

import Foundation

struct SearchResult: Codable {
    var resultCount: Int
    var results: [TrackModel]
}

struct TrackModel: Codable {
    var artistName: String
    var trackName: String
    var previewUrl: String      // audition source
    var artworkUrl100: String   // album cover
    var longDescription: String?
}
