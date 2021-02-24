//
//  MusicViewController.swift
//  FileManager
//
//  Created by Zhangir Tastemir on 4/28/20.
//  Copyright © 2020 AkanAkysh. All rights reserved.
//

import UIKit

class MusicViewController: UIViewController {
    
    enum Constants {
        static let cellId = "trackCell"
    }
    
    var tracks: [Track] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let text = searchTextField.text else { return }
        
        // replace empty space with + symbol to search artist who have more than one word in fullname
        // Example: travis scott
        let textToSearch = text.replace(string: " ", replacement: "+")
        
        tracks.removeAll()
        
        ApiService.shared.searchForMusic(artistName: textToSearch) { [weak self] (result, error) in
            guard let self = self else { return }
            guard let tracks = result?.tracks else { return }
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.tracks = tracks
        }
    }

}

extension MusicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as! TrackTableViewCell
        cell.track = tracks[indexPath.row]
        cell.delegate = self
        return cell
    }
    
}

extension MusicViewController: TrackTableViewCellDelegate {
    func didPressDownload(track: Track, completion: @escaping (Track) -> ()) {
        ApiService.shared.download(track: track) { (url, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if url != nil {
                completion(track)
            }
        }
    }
}
