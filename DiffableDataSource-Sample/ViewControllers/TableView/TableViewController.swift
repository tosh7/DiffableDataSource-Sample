import UIKit
import SnapKit

final class TableViewController: UIViewController {

    enum Section: Hashable {
        case main
    }

    struct Item: Hashable {
        private let identifier = UUID()
        var name: String

        static func == (lhs: TableViewController.Item, rhs: TableViewController.Item) -> Bool {
            lhs.identifier == rhs.identifier
        }
    }

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
        snapShot.appendSections([.main])
        snapShot.appendItems([
            Item(name: "Joy"),
            Item(name: "Winter"),
            Item(name: "Keita")
        ], toSection: .main)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}

// MARK: Delegate
extension TableViewController: UITableViewDelegate {}
