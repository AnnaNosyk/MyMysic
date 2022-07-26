//
//  CMTime + Extension.swift
//  MyMysic
//
//  Created by Anna Nosyk on 25/07/2022.
//

import Foundation
import AVKit

extension CMTime {
    //convert cmtime to string
    func convertToString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeFormatSting = String(format: "%02d:%02d", minutes, seconds)
        return timeFormatSting
    }
    
}
