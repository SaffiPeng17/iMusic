//
//  CMTime+Util.swift
//  iMusic
//
//  Created by Saffi on 2022/2/23.
//

import CoreMedia

extension CMTime {
    var toString: String {
        let totalSeconds = Int(seconds)
        let hours: Int = totalSeconds / 3600
        let minutes: Int = (totalSeconds / 60) % 60
        let seconds: Int = totalSeconds % 60
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}

extension TimeInterval {
    var toString: String {
        let totalSeconds = Int(self)
        let hours: Int = totalSeconds / 3600
        let minutes: Int = (totalSeconds / 60) % 60
        let seconds: Int = totalSeconds % 60
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}
