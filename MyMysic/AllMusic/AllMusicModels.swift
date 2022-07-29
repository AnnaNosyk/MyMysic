//
//  AllMusicModels.swift
//  MyMysic
//
//  Created by Anna Nosyk on 21/07/2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum AllMusic {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getSongs(text:String)
            }
        }
        struct Response {
            enum ResponseType {
                case presentSongs(response: SongsResponse?)
                case presentFooterView
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displaySongs(viewModel: AllMusicViewModel)
                case displayFooterView
            }
        }
    }
    
}

class AllMusicViewModel: NSObject, NSCoding {
    
    //for saving in UserDefaults
    //conver for format UserDefaults
    func encode(with coder: NSCoder) {
        coder.encode(cells, forKey: "cells")
    }
    
    required init?(coder: NSCoder) {
        cells = coder.decodeObject(forKey: "cells") as? [AllMusicViewModel.Cell] ?? []
    }
    
    @objc(_TtCC7MyMysic17AllMusicViewModel4Cell)class Cell: NSObject, NSCoding {
     
        
        var imageUrlString: String?
        var songName: String
        var albumName: String
        var artistName: String
        var previewUrl: String?
        
        init(imageUrlString: String?,
             songName: String,
             albumName: String,
             artistName: String,
             previewUrl: String?) {

            self.imageUrlString = imageUrlString
            self.songName = songName
            self.albumName = albumName
            self.artistName = artistName
            self.previewUrl = previewUrl
        }
        
        func encode(with coder: NSCoder) {
            coder.encode(imageUrlString, forKey: "imageUrlString")
            coder.encode(songName, forKey: "songName")
            coder.encode(albumName, forKey: "albumName")
            coder.encode(artistName, forKey: "artistName")
            coder.encode(previewUrl, forKey: "previewUrl")
        }
        
        required init?(coder: NSCoder) {
            imageUrlString = coder.decodeObject(forKey: "imageUrlString") as? String? ?? ""
            songName = coder.decodeObject(forKey: "songName") as? String ?? ""
            albumName = coder.decodeObject(forKey: "albumName") as? String ?? ""
            artistName = coder.decodeObject(forKey: "artistName") as? String ?? ""
            previewUrl = coder.decodeObject(forKey: "previewUrl") as? String ?? ""
        }
        
    }
    
    init(cells: [Cell]) {
        self.cells = cells
    }
    let cells: [Cell]
}
