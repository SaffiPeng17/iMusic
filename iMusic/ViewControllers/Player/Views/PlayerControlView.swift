//
//  PlayerControlView.swift
//  iMusic
//
//  Created by Saffi on 2022/2/23.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

class CustomSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: 4))
    }
}

class PlayerControlView: UIView {

    private lazy var progressSlider: CustomSlider = {
        let slider = CustomSlider()
        slider.isContinuous = true
        slider.tintColor = UIColor(hex: 0xD3D3D3)
        slider.minimumTrackTintColor = UIColor(hex: 0xB5446E)
        slider.setThumbImage(UIImage(named: "anchor"), for: .normal)
        return slider
    }()

    private lazy var progressTime: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(hex: 0xB5446E, alpha: 0.8)
        return label
    }()

    private lazy var remainTime: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(hex: 0xB5446E, alpha: 0.8)
        label.textAlignment = .right
        return label
    }()

    private lazy var playControlView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.distribution = .fillEqually
        view.axis = .horizontal
        view.spacing = 50
        return view
    }()

    private lazy var backward: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "backward"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.addTarget(self, action: #selector(tappedBackward), for: .touchUpInside)
        return button
    }()

    private lazy var playControl: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "play"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.addTarget(self, action: #selector(tappedPlayControl), for: .touchUpInside)
        return button
    }()

    private lazy var forward: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "forward"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.addTarget(self, action: #selector(tappedForward), for: .touchUpInside)
        return button
    }()

    @objc func testEvent() {
        print("testEvent")
    }

    let disposeBag = DisposeBag()

    private var player: MiniPlayer!

    init(player: MiniPlayer) {
        super.init(frame: .zero)
        self.player = player
        setupViews()
        setupBinding()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(progressSlider)
        addSubview(progressTime)
        addSubview(remainTime)
        addSubview(playControlView)

        progressSlider.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(10)
        }

        progressTime.snp.makeConstraints { make in
            make.top.equalTo(progressSlider.snp.bottom).offset(6)
            make.leading.equalToSuperview()
            make.height.equalTo(14)
        }

        remainTime.snp.makeConstraints { make in
            make.top.height.equalTo(progressTime)
            make.trailing.equalToSuperview()
        }

        playControlView.snp.makeConstraints { make in
            make.top.equalTo(remainTime.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
        }

        playControlView.addArrangedSubview(backward)
        playControlView.addArrangedSubview(playControl)
        playControlView.addArrangedSubview(forward)
        playControl.snp.makeConstraints { make in
            make.width.height.equalTo(33)
        }

        backward.snp.makeConstraints { make in
            make.width.height.equalTo(playControl)
        }

        forward.snp.makeConstraints { make in
            make.width.height.equalTo(playControl)
        }
    }

    private func setupBinding() {
        player.isPlaying
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] playing in
                print("playing:", playing)
                self?.updatePlayControl(by: playing)
            }).disposed(by: disposeBag)
        
        player.progress
            .observe(on: MainScheduler.instance)
            .bind(to: progressSlider.rx.value)
            .disposed(by: disposeBag)

        player.progressTime
            .observe(on: MainScheduler.instance)
            .bind(to: progressTime.rx.text)
            .disposed(by: disposeBag)

        player.remainTime
            .observe(on: MainScheduler.instance)
            .bind(to: remainTime.rx.text)
            .disposed(by: disposeBag)

        progressSlider.rx.value
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] value in
                self?.updateTime(by: value)
            }.disposed(by: disposeBag)

        progressSlider.rx.controlEvent([.touchUpInside, .touchUpOutside])
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.playCurrentProgress()
            }.disposed(by: disposeBag)
    }

    // update time by Slider
    private func updateTime(by value: Float) {
        guard let duration = player.currentItem?.duration else {
            return
        }
        let progressT: TimeInterval = duration.seconds * TimeInterval(value)
        let remainT: TimeInterval = duration.seconds * (1 - TimeInterval(value))
        progressTime.text = progressT.toString
        remainTime.text = remainT.toString
    }

    private func playCurrentProgress() {
        guard let duration = player.currentItem?.duration else {
            return
        }
        let time: TimeInterval = duration.seconds * TimeInterval(progressSlider.value)
        let cmTime = CMTime(seconds: time, preferredTimescale: 1000000)
        player.seek(to: cmTime)
    }

    //action: button
    private func updatePlayControl(by isPlaying: Bool) {
        let imageName: String = isPlaying ? "pause" : "play"
        playControl.setImage(UIImage(named: imageName), for: .normal)
    }

    //actions
    @objc func tappedBackward() {
        guard let duration = player.currentItem?.duration else {
            return
        }
        var time: TimeInterval = duration.seconds * TimeInterval(progressSlider.value)
        time = time <= 0 ? 0 : time - 7
        let cmTime = CMTime(seconds: time, preferredTimescale: 1000000)
        player.seek(to: cmTime)
    }

    @objc func tappedPlayControl() {
        if player.timeControlStatus == .playing {
            player.pause()
        } else {
            player.play()
        }
    }

    @objc func tappedForward() {
        guard let duration = player.currentItem?.duration else {
            return
        }
        var time: TimeInterval = duration.seconds * TimeInterval(progressSlider.value)
        time = time >= duration.seconds ? duration.seconds : time + 7
        let cmTime = CMTime(seconds: time, preferredTimescale: 1000000)
        player.seek(to: cmTime)
    }
}
