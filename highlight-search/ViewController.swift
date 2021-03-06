//
//  ViewController.swift
//  highlight-search
//
//  Created by quan bui on 2021/06/17.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UITableViewController {

  let data = [
    "Act 1 Scene 1: Verona, A public place",
    "Act 1 Scene 2: Capulet's mansion",
    "Act 1 Scene 3: A room in Capulet's mansion",
    "Act 1 Scene 4: A street outside Capulet's mansion",
    "Act 1 Scene 5: The Great Hall in Capulet's mansion",
    "Act 2 Scene 1: Outside Capulet's mansion",
    "Act 2 Scene 2: Capulet's orchard",
    "Act 2 Scene 3: Outside Friar Lawrence's cell",
    "Act 2 Scene 4: A street in Verona",
    "Act 2 Scene 5: Capulet's mansion",
    "Act 2 Scene 6: Friar Lawrence's cell"
  ]

  let search: UISearchController = {
    let s = UISearchController()
    s.searchBar.translatesAutoresizingMaskIntoConstraints = false
    s.searchBar.accessibilityIdentifier = "SearchBar"
    s.searchBar.placeholder = "Search"
    s.obscuresBackgroundDuringPresentation = false
    s.searchBar.sizeToFit()
    s.searchBar.enablesReturnKeyAutomatically = false
    s.hidesNavigationBarDuringPresentation = false
    s.searchBar.returnKeyType = .done
    return s
  }()

  private var searchText = String()
  private var filtered: [String] = []
  private let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Highlight Text"
    navigationController?.navigationBar.prefersLargeTitles = true
    search.searchBar.isTranslucent = false
    navigationItem.searchController = search
    navigationItem.hidesSearchBarWhenScrolling = false

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.tableFooterView = UIView()

    search.searchBar
      .rx.text
      .orEmpty
      .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      // .filter { !$0.isEmpty }
      .subscribe(onNext: { [unowned self] query in
        self.searchText = query
        let searchTxt = query.lowercased()
        let result = self.data.filter { $0.lowercased().contains(searchTxt) }
        self.filtered = result.isEmpty ? data : result
        tableView.reloadData()
      })
      .disposed(by: disposeBag)
  }

  override init(style: UITableView.Style) {
    super.init(style: style)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filtered.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.highlightText(value: filtered[indexPath.row], highlight: searchText)
    cell.textLabel?.numberOfLines = 0
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension UILabel {
  func highlightText(value: String?, highlight: String?) {
    guard let value = value,
          let highlight = highlight else {
      return
    }

    let attributedText = NSMutableAttributedString(string: value)
    let range = (value as NSString).range(of: highlight, options: .caseInsensitive)
    let strokeText: [NSAttributedString.Key: Any] = [
      .backgroundColor: UIColor.yellow,
      .foregroundColor: UIColor.black
    ]
    attributedText.addAttributes(strokeText, range: range)
    self.attributedText = attributedText
  }
}
