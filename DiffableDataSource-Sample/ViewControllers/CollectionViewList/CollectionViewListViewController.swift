import UIKit

final class CollectionViewListViewController: UIViewController {
    enum Section: Hashable {
        case main
    }

    struct OutlineItem: Hashable {
        private let identifier = UUID()
        let title: String
        let subItems: [OutlineItem]

        init(title: String,
             subItems: [CollectionViewListViewController.OutlineItem] = []) {
            self.title = title
            self.subItems = subItems
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }

        static func == (lhs: OutlineItem, rhs: OutlineItem) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    }

    private var dataSource: UICollectionViewDiffableDataSource<Section, OutlineItem>!
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "CollectionViewList"
        configureCollectionView()
        configureDataSource()
    }

    private lazy var menuItem: [OutlineItem] = {
        return [
            OutlineItem(title: "FirstSection", subItems: [
                OutlineItem(title: "Hoge"),
                OutlineItem(title: "Fuga"),
                OutlineItem(title: "Piyo")
            ]),
            OutlineItem(title: "You Know Who?", subItems: [
                OutlineItem(title: "It's me Jcob"),
                OutlineItem(title: "Kety? You?"),
                OutlineItem(title: "Tell me who.")
            ]),
            OutlineItem(title: "Harry Potter and", subItems: [
                OutlineItem(title: "the stinkly toilet"),
                OutlineItem(title: "the hungry dog"),
                OutlineItem(title: "the british pub")
            ])
        ]
    }()
}

extension CollectionViewListViewController {

    private func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generalLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemGroupedBackground
        self.collectionView = collectionView
        collectionView.delegate = self
    }

    private func configureDataSource() {
        let containerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, OutlineItem> { cell, indexPath, menuItem in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = menuItem.title
            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .headline)
            cell.contentConfiguration = contentConfiguration

            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options: disclosureOptions)]
            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        }

        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, OutlineItem> { cell, indexPath, menuItem in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = menuItem.title
            cell.contentConfiguration = contentConfiguration
            cell.backgroundConfiguration = UIBackgroundConfiguration.clear()
        }

        self.dataSource = UICollectionViewDiffableDataSource<Section, OutlineItem>(collectionView: collectionView) { collectionView, indexPath, menuItem -> UICollectionViewCell? in
            menuItem.subItems.isEmpty ? collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: menuItem) : collectionView.dequeueConfiguredReusableCell(using: containerCellRegistration, for: indexPath, item: menuItem)
        }

        let snapShot = initialSnapShot()
        self.dataSource.apply(snapShot, to: .main, animatingDifferences: false)
    }

    private func generalLayout() -> UICollectionViewLayout {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }

    private func initialSnapShot() -> NSDiffableDataSourceSectionSnapshot<OutlineItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<OutlineItem>()

        func addItems(_ menuItems: [OutlineItem], to parent: OutlineItem?) {
            snapshot.append(menuItems, to: parent)
            for menuItem in menuItems where !menuItem.subItems.isEmpty {
                addItems(menuItem.subItems, to: menuItem)
            }
        }

        addItems(self.menuItem, to: nil)
        return snapshot
    }
}
extension CollectionViewListViewController: UICollectionViewDelegate { }
