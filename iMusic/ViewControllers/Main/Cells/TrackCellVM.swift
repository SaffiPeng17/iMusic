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

    let isHidePlayStatus: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    let isPlaying: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    private(set) var trackModel: TrackModel

    init(trackModel: TrackModel) {
        self.trackModel = trackModel
        super.init()
        self.cellIdentifier = "TrackCell"
        setupBinding()
        prepareViewData()
    }

    private func setupBinding() {
        ObserverManager.shared.currentPlayURL
            .subscribe(onNext: { [weak self] currentPlayURL in
                guard let url = self?.trackModel.previewUrl, url == currentPlayURL else {
                    self?.isHidePlayStatus.accept(true)
                    return
                }
                self?.isHidePlayStatus.accept(false)
            }).disposed(by: disposeBag)

        ObserverManager.shared.isPlaying
            .subscribe(onNext: { [weak self] isPlaying in
                guard let isPlayStatusHide = self?.isHidePlayStatus.value, !isPlayStatusHide else {
                    self?.isPlaying.accept(false)
                    return
                }
                self?.isPlaying.accept(isPlaying)
            }).disposed(by: disposeBag)
    }

    private func prepareViewData() {
        albumURL = URL(string: trackModel.artworkUrl100 ?? "")
        trackName = trackModel.trackName ?? ""
        artistName = trackModel.artistName ?? ""
        description = trackModel.longDescription ?? ""
    }
}
