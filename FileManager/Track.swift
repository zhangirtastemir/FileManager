//
//  Track.swift
//  FileManager
//
//  Created by Zhangir Tastemir on 4/28/20.
//  Copyright © 2020 AkanAkysh. All rights reserved.
//

import Foundation

struct Track: Codable {
    var previewUrl: URL
    var artistName: String
    var trackName: String
}

struct TrackResponse: Codable {
    var tracks: [Track]
    
    enum CodingKeys: String, CodingKey {
        case tracks = "results"
    }
}
