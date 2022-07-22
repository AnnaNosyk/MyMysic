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
