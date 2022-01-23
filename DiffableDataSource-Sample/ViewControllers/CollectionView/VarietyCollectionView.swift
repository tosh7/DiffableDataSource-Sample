import UIKit

final class VarietyCollectionViewController: UIViewController {

    enum Section: Hashable {
        case title
        case margin
        case list
        case bottom
    }

    enum Item: Hashable {
        case title(TitleItem)
        case margin
        case list(ListItem)
        case bottom
    }

    struct TitleItem: Hashable {
        var title: String
        var subTitle: String
    }

    struct ListItem: Hashable {
        private let uuid = UUID()
        var title: String
        var list: [ListItem]

        init(title: String, list: [ListItem]) {
            self.title = title
            self.list = list
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var currentSnapshot: NSDiffableDataSourceSnapshot<Section, Item>!
    private var items: [Item] = [] {
        didSet {
            updateUI()
        }
    }
    private var isAccordionAppear: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        configureDataSource()
        updateUI()

        getApiData()
    }

    private func getApiData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.items = [
                .title(TitleItem(title: "Note", subTitle: "That")),
                .margin,
                .list(ListItem(title: "This is list area.", list: [
                    ListItem(title: "one", list: []),
                    ListItem(title: "two", list: []),
                    ListItem(title: "three", list: [])
                ])),
                .bottom
            ]
        })
    }
}

// MARK: Layout
extension VarietyCollectionViewController {
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.delegate = self

        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: TitleCollectionViewCell.self))
        collectionView.register(MarginCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MarginCollectionViewCell.self))
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ListCollectionViewCell.self))
        collectionView.register(BottomCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: BottomCollectionViewCell.self))
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let sectionKind = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            var section: NSCollectionLayoutSection!
            switch sectionKind {
            case .title:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
            case .margin:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
            case .list:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.1))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
            case .bottom:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
            }
            return section
        }

        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}

// MARK: DataSource
extension VarietyCollectionViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .title:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  String(describing: TitleCollectionViewCell.self), for: indexPath) as! TitleCollectionViewCell
                return cell
            case .margin:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MarginCollectionViewCell.self), for: indexPath) as! MarginCollectionViewCell
                return cell
            case let .list(listItem):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ListCollectionViewCell.self), for: indexPath) as! ListCollectionViewCell
                cell.titleLabel.text = listItem.title
                return cell
            case .bottom:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BottomCollectionViewCell.self), for: indexPath) as! BottomCollectionViewCell
                return cell
            }
        }
    }

    private func updateUI() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()

        items.forEach {
            switch $0 {
            case let .title(titleItem):
                snapShot.appendSections([.title])
                snapShot.appendItems([.title(titleItem)], toSection: .title)
            case .margin:
                snapShot.appendSections([.margin])
                snapShot.appendItems([.margin], toSection: .margin)
            case let .list(listItem):
                snapShot.appendSections([.list])
                snapShot.appendItems(listItem.list.map { .list($0) }, toSection: .list)
            case .bottom:
                snapShot.appendSections([.bottom])
                snapShot.appendItems([.bottom], toSection: .bottom)
            }
        }

        dataSource.apply(snapShot, animatingDifferences: true)
    }
}

// MARK: Delegate
extension VarietyCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        items = isAccordionAppear ? [
            .title(TitleItem(title: "Note", subTitle: "That")),
            .margin,
            .list(ListItem(title: "This is list area.", list: [])),
            .bottom
        ] : [
            .title(TitleItem(title: "Note", subTitle: "That")),
            .margin,
            .list(ListItem(title: "This is list area.", list: [
                ListItem(title: "one", list: []),
                ListItem(title: "two", list: []),
                ListItem(title: "three", list: [])
            ])),
            .bottom
        ]
        isAccordionAppear.toggle()
    }
}
