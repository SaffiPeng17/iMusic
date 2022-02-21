//
//  ViewController.swift
//  iMusic
//
//  Created by Saffi on 2022/2/12.
//

import UIKit
import SnapKit
import RxSwift

class ViewController: UIViewController {

    let disposeBag = DisposeBag()

    var viewModel = ViewControllerVM()

    private lazy var searchBar = UISearchBar()

    private lazy var collecionView: UICollectionView = {
        let flowLayout = MusicFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 15

        let view = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
        view.backgroundColor = .white
        view.contentInsetAdjustmentBehavior = .always
        view.keyboardDismissMode = .onDrag
        view.register(TrackCell.self, forCellWithReuseIdentifier: "TrackCell")
        view.dataSource = self
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBinding()
    }

    func setupViews() {
        title = "iTunes Music"

        view.addSubview(searchBar)
        view.addSubview(collecionView)

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }

        collecionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    func setupBinding() {
        searchBar.searchTextField.rx.text.orEmpty
            .throttle(.microseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe { [weak self] inputText in
                guard let text = inputText.element else {
                    return
                }
                self?.viewModel.searchMusic(keyword: text)
            }.disposed(by: disposeBag)

        viewModel.reloadData.observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.collecionView.reloadData()
            }.disposed(by: disposeBag)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellVM = viewModel.cellViewModel(at: indexPath) else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellVM.cellIdentifier, for: indexPath)
        if let trackCell = cell as? TrackCell {
            trackCell.setupViewModel(cellVM)
        }
        return cell
    }
}
