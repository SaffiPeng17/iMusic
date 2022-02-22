//
//  Lottie+Util.swift
//  iMusic
//
//  Created by Saffi on 2022/2/22.
//

import Foundation
import Lottie

extension AnimationView {

    func playWithShow() {
        self.isHidden = false
        self.play()
    }

    func stopWithHidden() {
        self.stop()
        self.isHidden = true
    }
}
