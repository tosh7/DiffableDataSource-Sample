import UIKit

final class VarietyCollectionViewController: UIViewController {

    enum Section: Hashable {
        case title
        case margin
        case list
        case bottom
    }

    enum Item: Hashable {
        case title
        case margin
        case list(ListItem)
        case bottom
    }

    struct ListItem: Hashable {
        var uuid = UUID()
        var title: String
//        var list: [ListItem]
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
        updateUI(str: "Hoge")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.updateUI(str: "huga")
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
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
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

    private func updateUI(str: String) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
        if str == "Hoge" {
            snapShot.appendSections([.title, .list, .margin, .bottom])
        } else {
            snapShot.appendSections([.title, .margin, .list, .bottom])
        }

        snapShot.appendItems([.title], toSection: .title)
        snapShot.appendItems([.list(ListItem(title: str))], toSection: .list)
        snapShot.appendItems([.margin], toSection: .margin)
        snapShot.appendItems([.bottom], toSection: .bottom)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}

// MARK: Delegate
extension VarietyCollectionViewController: UICollectionViewDelegate {}
