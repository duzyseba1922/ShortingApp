import UIKit
import SafariServices
import CoreData

class HistoryController: UIViewController, UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    var titleLabel = UILabel()
    var tableView = UITableView()
    var cellId = "cellId"
    var listOfLinks = [[String]]()
    
    override func viewDidAppear(_ animated: Bool) {
        listOfLinks.removeAll()
        loadData()
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
    }
    
    func setupConstraints() {
        // MARK: Setting titleLabel
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "List of shortened links"
        titleLabel.textColor = .label
        titleLabel.font = .boldSystemFont(ofSize: 25)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        // MARK: Setting tableView
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = .systemBackground
        tableView.layer.cornerRadius = 10
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func loadData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Link")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject]{
                listOfLinks.append([data.value(forKey: "createdLink") as! String, data.value(forKey: "pastedLink") as! String])
            }
        } catch {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfLinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellId)
        cell?.textLabel?.text = listOfLinks[indexPath.row][0]
        cell?.detailTextLabel?.text = listOfLinks[indexPath.row][1]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = listOfLinks[indexPath.row][0]
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            present(vc, animated: true)
        }
    }
}
