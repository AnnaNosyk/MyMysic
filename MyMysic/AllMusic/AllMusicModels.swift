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
                case some
                case getSongs(text:String)
            }
        }
        struct Response {
            enum ResponseType {
                case some
                case presentSongs(response: SongsResponse?)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case some
                case displaySongs(viewModel: AllMusicViewModel)
            }
        }
    }
    
}

struct AllMusicViewModel {
    struct Cell: SongViewModelProtocol {
        var imageUrlString: String?
        var songName: String
        var albumName: String
        var artistName: String
        var previewUrl: String?
    }
    
    let cells: [Cell]
}
