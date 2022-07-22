//
//  AllMusicPresenter.swift
//  MyMysic
//
//  Created by Anna Nosyk on 21/07/2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AllMusicPresentationLogic {
  func presentData(response: AllMusic.Model.Response.ResponseType)
}

class AllMusicPresenter: AllMusicPresentationLogic {
  weak var viewController: AllMusicDisplayLogic?
  
  func presentData(response: AllMusic.Model.Response.ResponseType) {
  
      switch response {
      case .presentSongs(response: let result):
         let cells =  result?.results.map({ song in
              cellViewModel(from: song)
         }) ?? []
          let viewModel = AllMusicViewModel.init(cells: cells)
          viewController?.displayData(viewModel: AllMusic.Model.ViewModel.ViewModelData.displaySongs(viewModel: viewModel))
      case .presentFooterView:
          viewController?.displayData(viewModel: AllMusic.Model.ViewModel.ViewModelData.displayFooterView)
      }
  }
    
    private func cellViewModel(from song: Song) -> AllMusicViewModel.Cell {
        return AllMusicViewModel.Cell.init(imageUrlString: song.artworkUrl100,
                                           songName: song.trackName,
                                           albumName: song.collectionName ?? "",
                                           artistName: song.artistName,
                                           previewUrl: song.previewUrl)
    }
  
}
