//
//  UISlider+rx.swift
//  iMusic
//
//  Created by Saffi on 2022/2/23.
//

import UIKit
import RxSwift
import RxCocoa

//extension Reactive where Base: UISlider {
//
//    var inBuffering: Observable<Bool> {
//        return base.rx.controlEvent(.touch)
//    }
//
////    var status: Observable<AVPlayer.Status?> {
////        return observe(AVPlayer.Status.self, #keyPath(AVPlayer.status))
////    }
////    var playStatus: Observable<AVPlayer.TimeControlStatus?> {
////        return observe(AVPlayer.TimeControlStatus.self, #keyPath(AVPlayer.timeControlStatus))
////    }
//
//    var inBuffering: Observable<Bool> {
//        return base.rx.observe(Bool.self, "currentItem.playbackLikelyToKeepUp", options: .new, retainSelf: false)
//            .map { !($0 ?? false) }
//    }
//
//    var inPlaying: Observable<Bool> {
//        return observe(Float.self, #keyPath(AVPlayer.rate))
//            .map { ($0 ?? 0) > 0 }
//    }
//
////    var inBuffering: Observable<Bool> {
//////        return base.rx.observe(#keyPath(AVPlayer.currentItem.isPlaybackLikelyToKeepUp), options: .new)
//////        "currentItem.playbackLikelyToKeepUp"
////        return base.rx.observe(Bool.self, "currentItem.playbackLikelyToKeepUp", options: .new, retainSelf: false)
////            .map { !($0 ?? false) }
////    }
//
////    var playStatus: Observable<Bool> {
////        return observe(Float.self, #keyPath(AVPlayer.rate))
////            .map { ($0 ?? 0) > 0 }
////    }
//
////    var didSetCurrentItem: Observable<Bool> {
////        return observe(AVPlayerItem.self, #keyPath(AVPlayer.currentItem))
////            .map { $0 != nil }
////    }
//
//    func periodicTimeObserver(interval: CMTime) -> Observable<CMTime> {
//        return Observable.create { observer in
//            let time = base.addPeriodicTimeObserver(forInterval: interval, queue: nil) { time in
//                observer.onNext(time)
//            }
//            return Disposables.create { base.removeTimeObserver(time) }
//        }
//    }
////
////    func addBoundaryTimeObserver(interval: CMTime) -> Observable<CMTime> {
////        return Observable.create { observer in
////            let time = base.addBoundaryTimeObserver(forTimes: <#T##[NSValue]#>, queue: <#T##DispatchQueue?#>, using: <#T##() -> Void#>) { time in
////                observer.onNext(time)
////            }
////            return Disposables.create { base.removeTimeObserver(time) }
////        }
////    }
////////    player.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
////    var inBuffering: Observable<Bool> {
//////        return base.rx.observe(#keyPath(AVPlayer.currentItem.isPlaybackLikelyToKeepUp), options: .new)
//////        "currentItem.playbackLikelyToKeepUp"
////        return base.rx.observe(Bool.self, "currentItem.playbackLikelyToKeepUp", options: .new, retainSelf: false)
////            .map { !($0 ?? false) }
////    }
//
////    func buffer(interval: CMTime) -> Observable<CMTime> {
////        return Observable.create { observer in
////            let time = base.addPeriodicTimeObserver(forInterval: interval, queue: nil) { time in
////                observer.onNext(time)
////            }
////            return Disposables.create { base.removeTimeObserver(time) }
////        }
////    }
////    /// Create observable which will emitt `AVPlayerStatus` every time player's status change. Only distinct values will be emitted.
////    ///
////    /// - Parameter options: Observing options which determine the values that are returned. These options are passed to KVO method.
////    /// - Returns: Observable which emitt player's status every time it change.
////    public func status(options: KeyValueObservingOptions) -> Observable<AVPlayer.Status?> {
////        return base.rx.observe(AVPlayer.Status.self, "status", options: options, retainSelf: false)
////            .distinctUntilChanged()
////    }
////
////    /// Create observable which will emitt `Float` every time player's rate change. Only distinct values will be emitted.
////    ///
////    /// - Parameter options: Observing options which determine the values that are returned. These options are passed to KVO method.
////    /// - Returns: Observable which emitt player's rate every time it change.
////    public func rate(options: KeyValueObservingOptions) -> Observable<Float?> {
////        return base.rx.observe(Float.self, "rate", options: options, retainSelf: false)
////            .distinctUntilChanged()
////    }
////
////
////    /// Create observable which will emitt `Bool` every time player's rate change. Only distinct values will be emitted.
////    /// If rate is <= 0.0 then this will emitt `true`.
////    ///
////    /// - Parameter options: Observing options which determine the values that are returned. These options are passed to KVO method.
////    /// - Returns: Observable which emitt paused state every time player's rate change.
////    public func paused(options: KeyValueObservingOptions) -> Observable<Bool> {
////        return base.rx.rate(options: options)
////            .map { ($0 ?? 0.0) <= 0.0 }
////            .distinctUntilChanged()
////    }
////
////    /// Create observable which will emitt playback position.
////    ///
////    /// - Parameters:
////    ///   - updateInterval: Interval in which is position updated.
////    ///   - updateQueue: Queue which is used to update position. If this is set to `nil` then updates are done on main queue.
////    /// - Returns: Observable which will emitt playback position.
////    public func playbackPosition(updateInterval: TimeInterval, updateQueue: DispatchQueue?) -> Observable<TimeInterval> {
////        return Observable.create({[weak base] observer in
////
////            guard let player = base else {
////                observer.onCompleted()
////                return Disposables.create()
////            }
////
////            let intervalTime = CMTime(seconds: updateInterval, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
////            let obj = player.addPeriodicTimeObserver(
////                forInterval: intervalTime,
////                queue: updateQueue,
////                using: { positionTime in
////
////                    observer.onNext(positionTime.seconds)
////            })
////
////            return Disposables.create {
////                player.removeTimeObserver(obj)
////            }
////        })
////    }
////
////    /// Create observable which will emitt `Bool` every time player's externalPlaybackActive change. Only distinct values will be emitted.
////    ///
////    /// - Parameter options: Observing options which determine the values that are returned. These options are passed to KVO method.
////    /// - Returns: Observable which emitt player's externalPlaybackActive every time it change.
////    public func externalPlaybackActive(options: KeyValueObservingOptions) -> Observable<Bool?> {
////        return base.rx.observe(Bool.self, "externalPlaybackActive", options: options, retainSelf: false)
////            .distinctUntilChanged()
////    }
//}
