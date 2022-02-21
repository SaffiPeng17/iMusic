//
//  BaseCollectionViewCell.swift
//  iMusic
//
//  Created by Saffi on 2022/2/13.
//

import Foundation
import RxSwift

class BaseViewModel {
    init() {}
}

protocol CellViewModelProtocol {
    var cellIdentifier: String { get }
}

class ViewCellModel: BaseViewModel, CellViewModelProtocol {
    var cellIdentifier: String = "ViewCellModel"
}

protocol CellViewProtocol: AnyObject {
    func setupViews()
    func setupViewModel(_ viewModel: BaseViewModel)
    func setupBinding()
    func updateViews()
}

class BaseCollectionViewCell<T: BaseViewModel>: UICollectionViewCell, CellViewProtocol {

    var disposeBag = DisposeBag()

    typealias ViewModelType = BaseViewModel
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

    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }

    // MARK: CellViewProtocol
    func setupViews() {}

    func setupViewModel(_ viewModel: BaseViewModel) {
        if let vm = viewModel as? T {
            self.viewModel = vm
        }
    }

    func setupBinding() {}

    func updateViews() {}
}
