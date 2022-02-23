//
//  TrackCell.swift
//  iMusic
//
//  Created by Saffi on 2022/2/13.
//

import UIKit
import Kingfisher
import RxSwift

class TrackCell: BaseCollectionViewCell<TrackCellVM> {

    private lazy var albumCover: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "album")
        return imageView
    }()

    private lazy var trackName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()

    private lazy var artistName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    private lazy var longDescription: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private lazy var playStatus: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "play"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        imageView.isHidden = true
        return imageView
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        albumCover.image = UIImage(named: "album")
        trackName.text = ""
        artistName.text = ""
        longDescription.text = ""
    }

    override func setupViews() {
        super.setupViews()
        backgroundColor = .white

        contentView.addSubview(albumCover)
        contentView.addSubview(playStatus)
        contentView.addSubview(trackName)
        contentView.addSubview(artistName)
        contentView.addSubview(longDescription)

        albumCover.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.leading.equalTo(13)
            make.width.height.equalTo(60)
        }

        playStatus.snp.makeConstraints { make in
            make.trailing.equalTo(-13)
            make.centerY.equalTo(albumCover)
            make.width.height.equalTo(20)
        }

        trackName.snp.makeConstraints { make in
            make.top.equalTo(albumCover)
            make.leading.equalTo(albumCover.snp.trailing).offset(8)
            make.trailing.equalTo(playStatus.snp.leading).offset(-8)
        }

        artistName.snp.makeConstraints { make in
            make.top.equalTo(trackName.snp.bottom).offset(2)
            make.leading.trailing.equalTo(trackName)
        }

        longDescription.snp.makeConstraints { make in
            make.top.equalTo(artistName.snp.bottom).offset(4)
            make.leading.trailing.equalTo(trackName)
            make.bottom.equalTo(-8)
        }
    }

    override func setupBinding() {
        super.setupBinding()

        viewModel.isHidePlayStatus
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: playStatus.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.isPlaying
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isPlaying in
                self?.updatePlayControl(by: isPlaying)
            }).disposed(by: disposeBag)
    }

    override func updateViews() {
        super.updateViews()

        if let url = viewModel.albumURL {
            albumCover.kf.setImage(with: url)
        }
        trackName.text = viewModel.trackName
        artistName.text = viewModel.artistName
        longDescription.text = viewModel.description
    }

    private func updatePlayControl(by isPlaying: Bool) {
        let imageName: String = isPlaying ? "pause" : "play"
        playStatus.image = UIImage(named: imageName)
    }
}
