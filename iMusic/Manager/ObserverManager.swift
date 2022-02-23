//
//  ObserverManager.swift
//  iMusic
//
//  Created by Saffi on 2022/2/23.
//

import Foundation
import RxSwift
import RxCocoa

// for global notifications
class ObserverManager {

    static let shared: ObserverManager = .init()
    init() {}
    
    var currentPlayURL: BehaviorRelay<String> = BehaviorRelay(value: "")
    let isPlaying = PublishRelay<Bool>()
}
