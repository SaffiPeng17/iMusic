//
//  TrackCellVM.swift
//  iMusic
//
//  Created by Saffi on 2022/2/13.
//

import Foundation
import AVFoundation
import RxSwift
import RxCocoa

class TrackCellVM: ViewCellModel {

    private let disposeBag = DisposeBag()

    private(set) var albumURL: URL?
    private(set) var trackName: String = ""
    private(set) var artistName: String = ""
    private(set) var description: String = ""

    let playStatus = PublishRelay<AVPlayer.Status>()

    private(set) var trackModel: TrackModel

    init(trackModel: TrackModel) {
        self.trackModel = trackModel
        super.init()
        self.cellIdentifier = "TrackCell"
        prepareViewData()
    }

    private func prepareViewData() {
        albumURL = URL(string: trackModel.artworkUrl100 ?? "")
        trackName = trackModel.trackName ?? ""
        artistName = trackModel.artistName ?? ""
        description = trackModel.longDescription ?? ""
    }
}
