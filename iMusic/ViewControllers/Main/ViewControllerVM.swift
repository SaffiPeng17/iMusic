//
//  ViewControllerVM.swift
//  iMusic
//
//  Created by Saffi on 2022/2/13.
//

import Foundation
import RxSwift
import RxCocoa

class ViewControllerVM: BaseViewModel {

    private let disposeBag = DisposeBag()

    let reloadData = PublishRelay<Void>()

    private var tracks: [TrackModel] = []

    func searchMusic(keyword: String) {
        NetworkManager.fetchSearchResult(searchText: keyword)
            .subscribe { [weak self] result in
                self?.tracks = result.results
                self?.reloadData.accept(())
            } onError: { error in
                print("search failed:", error)
            }.disposed(by: disposeBag)
    }
}

// MARK: - collectionView dataSource
extension ViewControllerVM {
    func numberOfItems() -> Int {
        return tracks.count
    }

    func cellViewModel(at indexPath: IndexPath) -> TrackCellVM? {
        guard indexPath.item < tracks.count else {
            return nil
        }
        let model = tracks[indexPath.item]
        return TrackCellVM(trackModel: model)
    }
}
