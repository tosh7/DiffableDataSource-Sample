import UIKit

final class BottomCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .orange

    }

    required init?(coder: NSCoder) { fatalError() }
}
