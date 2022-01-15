import UIKit
import SnapKit

final class CollectionViewListViewController: UIViewController {
    enum Section: Hashable {
        case main
    }

    struct Item: Hashable {
        private let identifier = UUID()

        static func == (lhs: CollectionViewListViewController.Item, rhs: CollectionViewListViewController.Item) -> Bool {
            lhs.identifier == rhs.identifier
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        updateUI()
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: self.createLayout())
        return collectionView
    }()

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { section, layoutEnvironment in
            let config = UICollectionLayoutListConfiguration(appearance: .plain)
            return  NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
        }
    }
}

extension CollectionViewListViewController {
    private func configureCollectionView() {
    }

    private func updateUI() {

    }
}
extension CollectionViewListViewController: UICollectionViewDelegate { }
