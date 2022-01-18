import UIKit

final class VarietyCollectionViewController: UIViewController {

    enum Section: Hashable {
        case main
    }

    struct Item: Hashable {
        let title: String
        let subItem: [Item]
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var currentSnapshot: NSDiffableDataSourceSnapshot<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        configureDataSource()
        updateUI()
    }
}

// MARK: DataSource
extension VarietyCollectionViewController {
    private func configureCollectionView() {

    }

    private func configureDataSource() {

    }

    private func updateUI() {

    }
}

// MARK: Delegate
extension VarietyCollectionViewController: UICollectionViewDelegate {}
