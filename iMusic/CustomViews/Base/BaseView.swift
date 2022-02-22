//
//  BaseView.swift
//  iMusic
//
//  Created by Saffi on 2022/2/22.
//

import UIKit
import RxSwift

protocol ViewSetupProtocol: AnyObject {
    func setupViews()
    func setupViewModel(_ viewModel: BaseViewModel)
    func setupBinding()
    func updateViews()
}

class BaseViewModel {
    init() {}
}

class BaseView<T: BaseViewModel>: UIView, ViewSetupProtocol {

    var disposeBag = DisposeBag()

    private(set) var viewModel: T! {
        willSet {
            self.disposeBag = DisposeBag()
        }
        didSet {
            self.setupBinding()
            self.updateViews()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: ViewSetupProtocol
    func setupViews() {}

    func setupViewModel(_ viewModel: BaseViewModel) {
        if let vm = viewModel as? T {
            self.viewModel = vm
        }
    }

    func setupBinding() {}

    func updateViews() {}
}
