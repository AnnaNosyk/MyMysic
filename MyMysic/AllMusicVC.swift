//
//  AllMusicVC.swift
//  MyMysic
//
//  Created by Anna Nosyk on 18/07/2022.
//

import UIKit
import Alamofire

class AllMusicVC: UITableViewController {
    
    let cellId = "AllMusicCell"
    private var timer: Timer?
    let searchController = UISearchController(searchResultsController: nil)
    var songs = [Song]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        setupSearchBar()

    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    private func getData(text: String) {
        let url = "https://itunes.apple.com/search"
        let parametrs = ["term":"\(text)",
                         "limit":"50"]
        // get request
        AF.request(url, method: .get, parameters: parametrs, encoding: URLEncoding.default, headers: nil).responseData { data in
            if let error = data.error {
                print("Error received requestiong data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data.data else { return }
            //decode data
            let decoder = JSONDecoder()
            do {
                let items = try decoder.decode( SearchResponse.self, from: data)
                self.songs = items.results
                self.tableView.reloadData()
                
            } catch let error  {
                print("Failed to decode JSON", error )
            }
        }
        
    }
    


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return songs.count    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let song = songs[indexPath.row]
        cell.textLabel?.text = "\(song.trackName)\n\(song.artistName)"
        cell.textLabel?.numberOfLines = 2
        cell.imageView?.image = UIImage(named: "Image")
       // cell.imageView?.contentMode = .scaleAspectFill

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AllMusicVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer =  Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [self] _ in
            getData(text: searchText)
        })
    
    }
}

