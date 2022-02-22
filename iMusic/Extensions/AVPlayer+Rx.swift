//
//  AVPlayer+Rx.swift
//  iMusic
//
//  Created by Saffi on 2022/2/22.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

extension Reactive where Base: AVPlayer {

    var inBuffering: Observable<Bool> {
        return base.rx.observe(Bool.self, "currentItem.playbackLikelyToKeepUp", options: .new, retainSelf: false)
            .map { !($0 ?? false) }
    }

    var inPlaying: Observable<Bool> {
        return observe(Float.self, #keyPath(AVPlayer.rate))
            .map { ($0 ?? 0) > 0 }
    }

    func periodicTimeObserver(interval: CMTime) -> Observable<CMTime> {
        return Observable.create { observer in
            let time = base.addPeriodicTimeObserver(forInterval: interval, queue: nil) { time in
                observer.onNext(time)
            }
            return Disposables.create { base.removeTimeObserver(time) }
        }
    }
}
