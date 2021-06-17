//
//  ViewController.swift
//  highlight-search
//
//  Created by quan bui on 2021/06/17.
//

import UIKit

class ViewController: UITableViewController {

  let data = ["choose random index from array swift",
              "pick random a number from array swift",
              "select random element from array in swift",
              "how to select a random item from a n array swift",
              "how to randomly select an item from an array in swift",
              "swift array random element",
              "random array selection swift",
              "swift get a random element from array",
              "how to pick random element from aray swift",
              "select random value from array swift",
              "random pick from array swift",
              "how to make a random array in swift",
              "pick random element from array swift",
              "getting random item from array swift",
              "swift get random item from array",
              "how to select random values from array in swift",
              "swift pick random number from array",
              "random value from array swift",
              "random pick from array swift",
              "swift choose 電話 value from array",
              "how to pick random value from array in swift",
              "picking a random number from a array in swift",
              "get random number of things from an array swift",
              "choose random value from array swift",
              "random pick array swift",
              "pick randomly from an array swift",
              "pick a random number from array swift",
              "using an カタカナ to select random values from array in swift",
              "randomly get an ement from an array in swift",
              "how to get a random item from an array swift",
              "pick a random entry in an array swift",
              "return random element from array swift",
              "randomize elements in an array swift",
              "randomly select from an array swift",
              "how to get a random element from an array in javas",
              "how to pick random element from an array swift",
              "Print random element from array of array in swift",
              "swift pick random element in array",
              "return random index of array swift",
              "choose 天気 array element swift",
              "swift random element of array select",
              "how to sample randomly from array 漢字"]

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

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Highlight Text"
    navigationController?.navigationBar.prefersLargeTitles = true
    search.searchBar.isTranslucent = false
    navigationItem.searchController = search
    navigationItem.hidesSearchBarWhenScrolling = false
    search.searchBar.delegate = self
    self.filtered = data

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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

extension ViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    self.searchText = searchText
    let searchText = searchText.lowercased()
    let result = data.filter({ $0.lowercased().contains(searchText)})
    self.filtered = result.isEmpty ? data : result
    tableView.reloadData()
  }

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    print("EndEditing.")
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.searchText = ""
    tableView.reloadData()
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
