
import UIKit


//This protocol has to be confirmed in your controller.
protocol CustomLayoutDelegate {
    //This method accept the height for your cell.
    func heightFor(index : Int) -> CGFloat
 }

class CustomLayout: UICollectionViewFlowLayout {

     //Variables
       var layoutDelegate : CustomLayoutDelegate?
       var leftY = CGFloat(10)
       var rightY = CGFloat(10)
       var cache = [UICollectionViewLayoutAttributes]()

    //This method sets the frame (attributes) for every cell and store in chache.
    override func prepare() {
        guard  cache.isEmpty == true, let collectionView = collectionView else{
            return
        }
        let verticalSpacing = CGFloat(10)
        let horizontalSpacing = CGFloat(10)
        let margin = CGFloat(10)
        leftY = margin
        rightY = margin
        for item in 0..<collectionView.numberOfItems(inSection: 0){
            var frame = CGRect.zero
            let cellHeight = self.layoutDelegate?.heightFor(index: item) ?? 0.0
            frame.size.height = cellHeight
            frame.size.width = (collectionView.frame.size.width - 2 * margin) / 2 - horizontalSpacing/2
            if item%2 == 0{
                frame.origin.x = margin
                frame.origin.y = leftY
                leftY += cellHeight + verticalSpacing
            }else{
                frame.origin.x = (collectionView.frame.size.width - 2 * margin) / 2 +  ((4 * horizontalSpacing) / 3)
                frame.origin.y = rightY
                rightY += cellHeight + verticalSpacing
            }

            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)
        }
    
    
    }
    
    // This method returns the array of
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    //This method sets the collection view's content size.
    override var collectionViewContentSize: CGSize{
        return CGSize.init(width: collectionView?.frame.size.width ?? 0.0, height: max(leftY, rightY))
    }
}
