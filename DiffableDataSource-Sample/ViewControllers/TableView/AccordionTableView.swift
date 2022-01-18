import UIKit

final class AccordionTableView: UIViewController {
    enum Section: Hashable {
        case main
    }

    struct OutlineItem: Hashable {
        private let identifier = UUID()
        let title: String
        let subItems: [OutlineItem]

        init(title: String,
             subItems: [OutlineItem] = []) {
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

    private var dataSource: UITableViewDiffableDataSource<Section, OutlineItem>!
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "AccordionTableView"

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

extension AccordionTableView {
    private func configureTableView() {
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.backgroundColor = .systemGroupedBackground
        self.tableView = tableView
        tableView.delegate = self
    }

    private func configureDataSource() {

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

extension AccordionTableView: UITableViewDelegate {}
