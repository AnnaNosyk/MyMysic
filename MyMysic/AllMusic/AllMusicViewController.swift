//
//  AllMusicViewController.swift
//  MyMysic
//
//  Created by Anna Nosyk on 21/07/2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit


protocol AllMusicDisplayLogic: class {
  func displayData(viewModel: AllMusic.Model.ViewModel.ViewModelData)
    
}

class AllMusicViewController: UIViewController, AllMusicDisplayLogic {

  var interactor: AllMusicBusinessLogic?
  var router: (NSObjectProtocol & AllMusicRoutingLogic)?

    
    @IBOutlet weak var tableView: UITableView!
    let cellId = "AllMusicCell"
    let searchController = UISearchController(searchResultsController: nil)
    private var viewModel = AllMusicViewModel.init(cells: [])
    private var timer: Timer?
  
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = AllMusicInteractor()
    let presenter             = AllMusicPresenter()
    let router                = AllMusicRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
      setup()
      setupTableView()
      setupSearchBar()
  }
    
    private func setupTableView() {
        let nib = UINib(nibName: "SongCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: SongViewCell.cellId)
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
  
  func displayData(viewModel: AllMusic.Model.ViewModel.ViewModelData) {
      switch viewModel {
  
      case .some:
          print("viewcontroller.some")
      case .displaySongs(viewModel: let viewModel):
          self.viewModel = viewModel
          tableView.reloadData()
      }
  }
  
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension AllMusicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongViewCell.cellId, for: indexPath) as! SongViewCell
        let songViewModel = viewModel.cells[indexPath.row]
        cell.set(viewModel: songViewModel)
        cell.songImage.backgroundColor = .yellow
        return cell
    }
}
// MARK: -
extension AllMusicViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer =  Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.interactor?.makeRequest(request: AllMusic.Model.Request.RequestType.getSongs(text: searchText))
        })
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}
