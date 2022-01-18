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

// MARK: Layout
extension VarietyCollectionViewController {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.delegate = self
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            var section: NSCollectionLayoutSection!
            return section
        }

        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}

// MARK: DataSource
extension VarietyCollectionViewController {
    private func configureDataSource() {

    }

    private func updateUI() {

    }
}

// MARK: Delegate
extension VarietyCollectionViewController: UICollectionViewDelegate {}
