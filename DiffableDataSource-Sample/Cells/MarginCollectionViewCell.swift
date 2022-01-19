import UIKit

final class MarginCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .blue

    }

    required init?(coder: NSCoder) { fatalError() }
}
