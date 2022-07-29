//
//  UserDefaults + Extension.swift
//  MyMysic
//
//  Created by Anna Nosyk on 29/07/2022.
//

import Foundation

extension UserDefaults {
    
    static let mySongKey = "mySongKey"
    
    func savedSongs() -> [AllMusicViewModel.Cell] {
        let defaults = UserDefaults.standard
        guard let savedSongs = defaults.object(forKey: UserDefaults.mySongKey) as? Data else { return [] }
        //decode songs to the model
        guard let decodedSongs = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedSongs) as? [AllMusicViewModel.Cell] else { return [] }
        return decodedSongs
    }
    
}
