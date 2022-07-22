//
//  AllMusicInteractor.swift
//  MyMysic
//
//  Created by Anna Nosyk on 21/07/2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol AllMusicBusinessLogic {
  func makeRequest(request: AllMusic.Model.Request.RequestType)
}

class AllMusicInteractor: AllMusicBusinessLogic {

    var networkManager = NetworkManager()
  var presenter: AllMusicPresentationLogic?
  var service: AllMusicService?
  
  func makeRequest(request: AllMusic.Model.Request.RequestType) {
    if service == nil {
      service = AllMusicService()
    }
      
      switch request {
 
      case .some:
          print("interator.some")
      case .getSongs(text: let text):
          networkManager.getData(text: text) {[weak self] response in
              self?.presenter?.presentData(response: AllMusic.Model.Response.ResponseType.presentSongs(response: response))
          }
          
      }
  }
  
}
