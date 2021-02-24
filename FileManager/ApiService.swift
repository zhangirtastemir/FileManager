//
//  ApiService.swift
//  FileManager
//
//  Created by Zhangir Tastemir on 4/28/20.
//  Copyright © 2020 AkanAkysh. All rights reserved.
//

import Foundation

class ApiService {
    
    static let shared = ApiService()
    
    func searchForMusic(artistName: String, completion: @escaping (TrackResponse?, Error?) -> ()) {
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(artistName)&entity=song") else {
            print("bad url request")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(TrackResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(response, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }.resume()
    }
    
    func isDownloaded(track: Track) -> Bool {
        return FileManager.default.fileExists(atPath: FileService.shared.getFileUrl(for: track).path)
    }
    
    func download(track: Track, completion: @escaping (URL?, Error?) -> ()) {
        URLSession.shared.downloadTask(with: track.previewUrl) { tempURL, _, error in
            if let tempURL = tempURL {
                do {
                    let url = FileService.shared.getFileUrl(for: track)
                    print(url)
                    try FileManager.default.moveItem(at: tempURL, to: url)
                    print("successfully downloaded: \(track.trackName)")
                    DispatchQueue.main.async {
                        completion(url, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }.resume()
    }
}
