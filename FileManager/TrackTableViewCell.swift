//
//  MusicTableViewCell.swift
//  FileManager
//
//  Created by Zhangir Tastemir on 4/28/20.
//  Copyright © 2020 AkanAkysh. All rights reserved.
//

import UIKit

protocol TrackTableViewCellDelegate: class {
    func didPressDownload(track: Track, completion: @escaping (Track) -> ())
}

class TrackTableViewCell: UITableViewCell {
    
    var track: Track! {
        didSet {
            self.trackNameLabel.text = track.trackName
            self.artistNameLabel.text = track.artistName
            
            let isDownloaded = ApiService.shared.isDownloaded(track: self.track)
            
            downloadButton.isUserInteractionEnabled = !isDownloaded
            downloadButton.isHidden = isDownloaded
        }
    }
    
    weak var delegate: TrackTableViewCellDelegate?
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
 
    @IBAction func downloadButtonTapped(_ sender: UIButton) {
        delegate?.didPressDownload(track: track) { track in
            self.track = track
        }
    }
    
}
