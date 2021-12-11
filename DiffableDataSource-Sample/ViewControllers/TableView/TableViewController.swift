import UIKit
import SnapKit

final class TableViewController: UIViewController {

    enum Section: Hashable {
        case tableView
        case collectionView
        case collectionViewList

        var headerTitle: String {
            switch self {
            case .tableView:
                return "UITableView"
            case .collectionView:
                return "UICollectionView"
            case .collectionViewList:
                return "UICollectionViewList"
            }
        }
    }

    struct Item: Hashable {
        private let identifier = UUID()
        var name: String

        static func == (lhs: TableViewController.Item, rhs: TableViewController.Item) -> Bool {
            lhs.identifier == rhs.identifier
        }
    }

    private var sections: [Section] = []

    init() {
        super.init(nibName: nil, bundle: nil)

        configureDataSource()
        updateUI()

        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    private var dataSource: UITableViewDiffableDataSource<Section, Item>!

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return view
    }()
}

// MARK: DataSource
extension TableViewController {
    private func configureDataSource() {
        dataSource = .init(tableView: tableView,
                           cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = itemIdentifier.name
            return cell
        })
    }

    private func updateUI() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Item>()
        sections = [.tableView, .collectionView, .collectionViewList]
        snapShot.appendSections(sections)
        snapShot.appendItems([
            Item(name: "nomarl"),
            Item(name: "abnomal"),
            Item(name: "cdnomal")
        ], toSection: .tableView)
        snapShot.appendItems([
            Item(name: "nomarl"),
            Item(name: "abnomal"),
            Item(name: "cdnomal")
        ], toSection: .collectionView)
        snapShot.appendItems([
            Item(name: "nomarl"),
            Item(name: "abnomal"),
            Item(name: "cdnomal")
        ], toSection: .collectionViewList)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}

// MARK: Delegate
extension TableViewController: UITableViewDelegate {
    // set headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel()
        label.text = sections[section].headerTitle
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        return view
    }
}
