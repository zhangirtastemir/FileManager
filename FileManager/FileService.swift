//
//  FileService.swift
//  FileManager
//
//  Created by Zhangir Tastemir on 4/28/20.
//  Copyright © 2020 AkanAkysh. All rights reserved.
//

import UIKit

class FileService {
    static let shared = FileService()
    
    private let documentDirectoryURL = URL(string: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)!
    
    func createFolder(fileName: String) {
        let dataPath = documentDirectoryURL.appendingPathComponent(fileName)
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
                FileInstance.shared.files.append(File(image: UIImage(systemName: "folder")!, name: dataPath.lastPathComponent))
            } catch {
                print(error.localizedDescription);
            }
        }
    }
    
    func loadFiles() {
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentDirectoryURL, includingPropertiesForKeys: nil)
            
            FileInstance.shared.files.removeAll()
            
            for directoryContent in directoryContents {
                
                var image = UIImage()
                
                if directoryContent.pathExtension == "m4a" {
                    image = UIImage(systemName: "music.note")!
                } else {
                    image = UIImage(systemName: "folder")!
                }
                
                FileInstance.shared.files.append(File(image: image, name: directoryContent.lastPathComponent))
                
//                let mp3Files = directoryContents.filter{ $0.pathExtension == "m4a" }
//                print("mp3 urls:",mp3Files)
//                let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
//                print("mp3 list:", mp3FileNames)
            }
            
        } catch {
            print(error)
        }
    }
    
    func deleteFile(filePath: String) {
        do {
            if FileManager.default.fileExists(atPath: filePath) {
                try FileManager.default.removeItem(atPath: filePath)
            } else {
                print("File does not exist")
            }
        } catch let error as NSError {
            print("Error: \(error.domain)")
        }
    }
    
    func getFileUrl(for name: String) -> URL {
        let url = documentDirectoryURL.appendingPathComponent(name)
        return url
    }
    
    func getFileUrl(for track: Track) -> URL {
        let documentDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let url = documentDirectoryURL.appendingPathComponent(track.previewUrl.lastPathComponent)
        
        return url
    }
    
}
