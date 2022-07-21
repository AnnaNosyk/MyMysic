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
  
  }
  
}
