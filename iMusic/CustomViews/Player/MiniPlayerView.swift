//
//  MiniPlayerView.swift
//  iMusic
//
//  Created by Saffi on 2022/2/22.
//

import UIKit
import AVFoundation
import Lottie
import RxSwift
import RxCocoa

class MiniPlayerView: BaseView<MiniPlayerVM> {

    private lazy var controlContent: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var albumCover: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "album")
        return imageView
    }()

    private lazy var trackName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()

    private lazy var artistName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()

    private lazy var loadingAnimation: AnimationView = {
        let view = AnimationView(name: "93280-loading")
        view.loopMode = .loop
        return view
    }()

    private lazy var playControl: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.addTarget(self, action: #selector(tappedPlayControl), for: .touchUpInside)
        return button
    }()

    private lazy var playProgress: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.trackTintColor = UIColor(hex: 0xD3D3D3)
        view.progressTintColor = .white
        return view
    }()

    let player = MiniPlayer()

    private let tapGesture = UITapGestureRecognizer()

    let tapped = PublishRelay<Void>()

    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor(hex: 0xB5446E, alpha: 0.9)
        layer.cornerRadius = 8

        addSubview(controlContent)
        addSubview(playProgress)
        playProgress.snp.makeConstraints { make in
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
            make.bottom.equalToSuperview()
            make.height.equalTo(3)
        }

        controlContent.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(playProgress)
            make.bottom.equalTo(playProgress.snp.top)
        }

        controlContent.addSubview(albumCover)
        controlContent.addSubview(trackName)
        controlContent.addSubview(artistName)
        controlContent.addSubview(loadingAnimation)
        controlContent.addSubview(playControl)
        playControl.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.height.equalTo(25)
        }

        loadingAnimation.snp.makeConstraints { make in
            make.trailing.equalTo(playControl.snp.leading).offset(-5)
            make.width.height.equalTo(28)
            make.centerY.equalToSuperview()
        }

        albumCover.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(36)
        }

        trackName.snp.makeConstraints { make in
            make.leading.equalTo(albumCover.snp.trailing).offset(15)
            make.trailing.equalTo(loadingAnimation.snp.leading).offset(-15)
            make.bottom.equalTo(controlContent.snp.centerY)
            make.height.equalTo(16)
        }

        artistName.snp.makeConstraints { make in
            make.top.equalTo(controlContent.snp.centerY)
            make.leading.trailing.equalTo(trackName)
            make.height.equalTo(16)
        }

        addGestureRecognizer(tapGesture)
    }

    override func setupViewModel(_ viewModel: BaseViewModel) {
        super.setupViewModel(viewModel)
        replaceTrackToPlay()
    }

    override func setupBinding() {
        super.setupBinding()

        tapGesture.rx.event.subscribe { [weak self] _ in
            self?.tapped.accept(())
        }.disposed(by: disposeBag)

        player.isBuffering
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] buffering in
                print("buffering:", buffering)
                buffering ? self?.loadingAnimation.playWithShow() : self?.loadingAnimation.stopWithHidden()
            }).disposed(by: disposeBag)

        player.isPlaying
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] playing in
                print("playing:", playing)
                self?.updatePlayControl(by: playing)
            }).disposed(by: disposeBag)

        player.progress
            .observe(on: MainScheduler.instance)
            .bind(to: playProgress.rx.progress)
            .disposed(by: disposeBag)
    }

    override func updateViews() {
        super.updateViews()

        if let url = viewModel.albumURL {
            albumCover.kf.setImage(with: url)
        }
        trackName.text = viewModel.trackName
        artistName.text = viewModel.artistName
    }

    private func updatePlayControl(by isPlaying: Bool) {
        let imageName: String = isPlaying ? "pause" : "play"
        playControl.setImage(UIImage(named: imageName), for: .normal)
    }

    private func replaceTrackToPlay() {
        guard let url = URL(string: viewModel.trackModel.previewUrl ?? "") else {
            return
        }
        player.pause()

        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }

    //action: player control
    @objc func tappedPlayControl() {
        if player.timeControlStatus == .playing {
            player.pause()
        } else {
            player.play()
        }
    }
}
