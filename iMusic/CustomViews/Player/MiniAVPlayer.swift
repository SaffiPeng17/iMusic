//
//  MiniAVPlayer.swift
//  iMusic
//
//  Created by Saffi on 2022/2/22.
//

import Foundation
import AVFoundation
import RxSwift
import RxCocoa

class MiniPlayer: AVPlayer {

    private let disposeBag = DisposeBag()

    let isBuffering: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let isPlaying: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let progress: BehaviorRelay<Float> = BehaviorRelay(value: 0)

    override init() {
        super.init()
        setupBinding()
    }

    private func setupBinding() {
        rx.inBuffering.bind(to: isBuffering).disposed(by: disposeBag)
        rx.inPlaying.bind(to: isPlaying).disposed(by: disposeBag)

        let cmTime = CMTime(seconds: 0.05, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        rx.periodicTimeObserver(interval: cmTime)
            .subscribe(onNext: { [weak self] periodicTime in
                guard let self = self else { return }
                let playProgress = self.getProgress(periodicTime: periodicTime)
                self.progress.accept(playProgress)
            }).disposed(by: disposeBag)
    }

    private func getProgress(periodicTime: CMTime) -> Float {
        guard periodicTime.isValid, let duration = currentItem?.duration else {
            return 0
        }
        let currentSeconds = periodicTime.seconds
        let totalSeconds = duration.seconds
        guard currentSeconds.isFinite, totalSeconds.isFinite else {
            return 0
        }
        return Float(min(currentSeconds/totalSeconds, 1))
    }
}
