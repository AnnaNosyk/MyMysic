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
    private lazy var footerView = FooterView()
  
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
        tableView.tableFooterView = footerView
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
  
  func displayData(viewModel: AllMusic.Model.ViewModel.ViewModelData) {
      switch viewModel {
      case .displaySongs(viewModel: let viewModel):
          self.viewModel = viewModel
          tableView.reloadData()
          footerView.hideaAtivityIndicatorr()
      case .displayFooterView:
          footerView.showActivityIndicator()
      }
  }
    
    // for label when no items in tableview
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter search term ..."
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 19)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.cells.count > 0 ? 0 : 250
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let songViewModel = viewModel.cells[indexPath.row]
        let window = UIApplication.shared.keyWindow 
        let songDetailView = Bundle.main.loadNibNamed("SongDetailView", owner: self, options: nil)?.first as! SongDetailView
        songDetailView.set(viewModel: songViewModel)
       
        window?.addSubview(songDetailView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}
