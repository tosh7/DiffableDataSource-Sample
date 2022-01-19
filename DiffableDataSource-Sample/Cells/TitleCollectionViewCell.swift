import UIKit

final class TitleCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .red
    }

    required init?(coder: NSCoder) { fatalError() }
}
