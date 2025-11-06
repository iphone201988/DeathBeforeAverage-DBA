//
//  CustomCollectionViewFlowLayout.swift
//  DBA Fitness
//
//  Created by Macmini2022-2 on 01/04/25.
//

import Foundation
import UIKit

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesForElementsInRect = super.layoutAttributesForElements(in: rect)
        var newAttributesForElementsInRect = [UICollectionViewLayoutAttributes]()
        
        var leftMargin: CGFloat = 0.0;
        
        for attributes in attributesForElementsInRect! {
            if (attributes.frame.origin.x == self.sectionInset.left) {
                leftMargin = self.sectionInset.left
            } else {
                var newLeftAlignedFrame = attributes.frame
                newLeftAlignedFrame.origin.x = leftMargin
                attributes.frame = newLeftAlignedFrame
            }
            leftMargin += attributes.frame.size.width + 5 // Makes the space between cells
            newAttributesForElementsInRect.append(attributes)
            
            
            let collectionViewWidth = self.collectionView?.frame.width ?? 0 - (self.sectionInset.right + self.sectionInset.left)

            if (attributes.frame.origin.x + attributes.frame.size.width > collectionViewWidth) {
                var newLeftAlignedFrame = attributes.frame
                newLeftAlignedFrame.origin.x = self.sectionInset.left
                attributes.frame = newLeftAlignedFrame
            }
        }
        
        return newAttributesForElementsInRect
    }
}
