//
//  MiniPlayerVM.swift
//  iMusic
//
//  Created by Saffi on 2022/2/22.
//

import Foundation
import RxSwift
import RxCocoa

class MiniPlayerVM: BaseViewModel {

    private(set) var albumURL: URL?
    private(set) var trackName: String = ""
    private(set) var artistName: String = ""

    private(set) var trackModel: TrackModel

    init(trackModel: TrackModel) {
        self.trackModel = trackModel
        super.init()
        prepareViewData()
    }

    private func prepareViewData() {
        albumURL = URL(string: trackModel.artworkUrl100 ?? "")
        trackName = trackModel.trackName ?? ""
        artistName = trackModel.artistName ?? ""
    }
}
