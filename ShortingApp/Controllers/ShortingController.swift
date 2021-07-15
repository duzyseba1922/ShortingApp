import UIKit
import CoreData

class ShortingController: UIViewController, UITextFieldDelegate {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    
    var titleLabel = UILabel()
    var backgroundView = UIView()
    var enterUrlLabel = UILabel()
    var textField = UITextField()
    var shortenButton = UIButton()
    var shortUrl = UILabel()
    var spinner = UIActivityIndicatorView()
    
    var isUrlValid: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func setupConstraints() {
        // MARK: Setting titleLabel
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Short it!"
        titleLabel.textColor = .label
        titleLabel.font = .boldSystemFont(ofSize: 25)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
        
        // MARK: Setting backgroundView
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            backgroundView.heightAnchor.constraint(equalToConstant: 180)
        ])
        backgroundView.backgroundColor = .systemBlue
        backgroundView.layer.cornerRadius = 10
        
        // MARK: Setting enterUrlLabel
        backgroundView.addSubview(enterUrlLabel)
        enterUrlLabel.translatesAutoresizingMaskIntoConstraints = false
        enterUrlLabel.text = "Enter url:"
        enterUrlLabel.textColor = .white
        NSLayoutConstraint.activate([
            enterUrlLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20),
            enterUrlLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
        ])
        
        // MARK: Setting textField
        backgroundView.addSubview(textField)
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your URL here..."
        textField.textColor = .black
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .unlessEditing
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            textField.topAnchor.constraint(equalTo: enterUrlLabel.bottomAnchor, constant: 20)
        ])
        
        // MARK: Setting shortenButton
        backgroundView.addSubview(shortenButton)
        shortenButton.translatesAutoresizingMaskIntoConstraints = false
        shortenButton.setTitle("Shorten!", for: .normal)
        shortenButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        shortenButton.backgroundColor = .red
        shortenButton.layer.cornerRadius = 20
        shortenButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        shortenButton.addTarget(self, action: #selector(shortenButtonAction), for: .touchUpInside)
        NSLayoutConstraint.activate([
            shortenButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            shortenButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20),
            shortenButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
        
        // MARK: Setting shortUrl
        view.addSubview(shortUrl)
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        shortUrl.isUserInteractionEnabled = true
        shortUrl.addGestureRecognizer(labelTap)
        shortUrl.translatesAutoresizingMaskIntoConstraints = false
        shortUrl.font = .systemFont(ofSize: 25)
        shortUrl.numberOfLines = 0
        shortUrl.textAlignment = .center
        shortUrl.textColor = .label
        NSLayoutConstraint.activate([
            shortUrl.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 20),
            shortUrl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            shortUrl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            shortUrl.heightAnchor.constraint(equalToConstant: 100),
            shortUrl.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        // MARK: Setting spinner
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .green
        spinner.style = .large
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func onClick() {
        if(isUrlValid == true) {
            let vc = WebViewController()
            vc.passedUrl = shortUrl.text!
            UIPasteboard.general.string = shortUrl.text!
            present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func shortenButtonAction() {
        if (textField.text != "") {
            if (textField.text?.contains("http://") == true || textField.text?.contains("https://") == true) {
                spinner.startAnimating()
                isUrlValid = true
                shortenUrl(url: textField.text!)
            } else {
                isUrlValid = false
                shortUrl.text = "Your URL should starts with 'https://' or 'http://'"
            }
        } else {
            isUrlValid = false
            shortUrl.text = "Enter your URL first"
        }
    }
    
    func shortenUrl(url: String) {
        let urlComponents = NSURLComponents(string: "http://tiny-url.info/api/v1/create")!
        urlComponents.queryItems = [
            URLQueryItem(name: "apikey", value: "9874D9BE5139960ACDA"),
            URLQueryItem(name: "provider", value: "tw_gs"),
            URLQueryItem(name: "format", value: "text"),
            URLQueryItem(name: "url", value: url)
        ]
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { data, response, _ in
            guard let data=data else { return }
            DispatchQueue.main.async {
                self.shortUrl.text = String(data: data, encoding: .utf8)!
                self.spinner.stopAnimating()
                self.saveData(pastedLink: url, createdLink: String(data: data, encoding: .utf8)!)
            }
        }
        task.resume()
    }
    
    func saveData(pastedLink: String, createdLink: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Link", in: context)
        let newLink = NSManagedObject(entity: entity!, insertInto: context)
        
        newLink.setValue(pastedLink, forKey: "pastedLink")
        newLink.setValue(createdLink, forKey: "createdLink")
        
        do {
            try context.save()
        } catch {
            print("Saving Failed \(error)")
        }
    }
}
