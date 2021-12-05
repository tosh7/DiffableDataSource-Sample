import UIKit
import SnapKit

final class TableViewController: UIViewController {

    enum Section: Hashable {
        case main
    }

    struct Item: Hashable {
        
    }

    init() {
        super.init(nibName: nil, bundle: nil)

        configure()

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
        return view
    }()

    private func configure() {
        dataSource = .init(tableView: tableView,
                           cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = UITableViewCell()
            return cell
        })
    }
}

extension TableViewController: UITableViewDelegate {}
