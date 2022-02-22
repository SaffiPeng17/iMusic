//
//  MusicFlowLayout.swift
//  iMusic
//
//  Created by Saffi on 2022/2/16.
//

import UIKit

// for auto size collectionViewCell
class MusicFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)?.map { $0.copy() } as? [UICollectionViewLayoutAttributes]
        layoutAttributesObjects?.forEach { layoutAttributes in
            guard layoutAttributes.representedElementCategory == .cell else {
                return
            }
            guard let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame else {
                return
            }
            layoutAttributes.frame = newFrame
        }
        return layoutAttributesObjects
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else {
            return nil
        }
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }
        layoutAttributes.frame.origin.x = sectionInset.left
        layoutAttributes.frame.size.width = collectionView.safeAreaLayoutGuide.layoutFrame.width - sectionInset.left - sectionInset.right
        return layoutAttributes
    }
}
