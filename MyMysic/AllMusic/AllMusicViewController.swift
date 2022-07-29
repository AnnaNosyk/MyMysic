//
//  AllMusicViewController.swift
//  MyMysic
//
//  Created by Anna Nosyk on 21/07/2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
protocol AllMusicDisplayLogic: AnyObject {
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
    
    weak var tabBarDelegate: MainTabBarControllerDelegate?
  
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
        let tabBarVC = keyWindow?.rootViewController as? MainTabBarC
        tabBarVC?.songDetailView.delegate = self
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let songViewModel = viewModel.cells[indexPath.row]
        self.tabBarDelegate?.maxmizeSongDetailView(viewModel: songViewModel)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
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

// MARK: - UISearchBarDelegate
extension AllMusicViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer =  Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.interactor?.makeRequest(request: AllMusic.Model.Request.RequestType.getSongs(text: searchText))
        })
    }
}
 // MARK: - SongMovingDelegate
extension AllMusicViewController: SongMovingDelegate {
    
    private func getSong(isNext: Bool) ->AllMusicViewModel.Cell? {
        guard let indexPath = tableView.indexPathForSelectedRow else { return nil }
        tableView.deselectRow(at: indexPath, animated: true)
        var nextIndexPath: IndexPath!
        if isNext {
            nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if nextIndexPath.row == viewModel.cells.count {
                nextIndexPath.row = 0
            }
        } else {
            nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if nextIndexPath.row == -1 {
                nextIndexPath.row = viewModel.cells.count - 1
            }
        }
        tableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        let cellViewModel = viewModel.cells[nextIndexPath.row]
        return cellViewModel
        
    }
    func moveBack() -> AllMusicViewModel.Cell? {
        return getSong(isNext: false)
    }
    
    func moveForward() -> AllMusicViewModel.Cell? {
        return getSong(isNext: true)
    }
    
}
