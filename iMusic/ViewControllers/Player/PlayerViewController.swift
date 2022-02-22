//
//  PlayerViewController.swift
//  iMusic
//
//  Created by Saffi on 2022/2/22.
//

import UIKit
import RxSwift
import RxCocoa

class PlayerViewController: UIViewController {

    private lazy var albumCover: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .green
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "album")
        return imageView
    }()

    private lazy var trackName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var artistName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()

    private var progressView: PlayerControlView!

    let disposeBag = DisposeBag()

    private var player: MiniPlayer!

    init(with vm: MiniPlayerVM, player: MiniPlayer) {
        super.init(nibName: nil, bundle: nil)
        self.player = player
        setupViews()
        updateViews(viewModel: vm)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        view.backgroundColor = .white
        progressView = PlayerControlView(player: player)

        view.addSubview(albumCover)
        view.addSubview(trackName)
        view.addSubview(artistName)
        view.addSubview(progressView)

        albumCover.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.centerY)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(albumCover.snp.width)
        }

        trackName.snp.makeConstraints { make in
            make.top.equalTo(albumCover.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }

        artistName.snp.makeConstraints { make in
            make.top.equalTo(trackName.snp.bottom).offset(8)
            make.leading.trailing.equalTo(trackName)
        }

        progressView.snp.makeConstraints { make in
            make.top.equalTo(artistName.snp.bottom).offset(25)
            make.leading.trailing.equalTo(trackName)
            make.height.equalTo(110)
        }
    }

    func updateViews(viewModel: MiniPlayerVM) {
        if let url = viewModel.albumURL {
            albumCover.kf.setImage(with: url)
        }
        trackName.text = viewModel.trackName
        artistName.text = viewModel.artistName
    }
}
