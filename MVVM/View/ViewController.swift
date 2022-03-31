//
//  ViewController.swift
//  MVVM
//
//  Created by 성준 on 2022/03/28.
//

import UIKit

class ViewController: UIViewController {
    private var viewModel: ListControllerViewModel = ListControllerViewModel()
    private var tableView: UITableView!
    private var refreshBtn: UIButton!
    private var searchBar: UISearchBar!

    var a: Int {
        get{
            return 0
        }
    }
    
    var b: Int {
       get {
           return self.b
       }
       set(newVal) {
           self.b = newVal
       }
    }



    // MARK: -  viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ㅇㅅㅇ\(a)")
        
        setupUI()
        
        //users 정보 요청
        viewModel.fetchUsersData()
        
        //users의 변경사항이 있을 때마다 이벤트를 받음
        viewModel.filterdUsers.bind ({ [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
        
    }
    
    private func setupUI() {
        let width = view.frame.width
        let height = view.frame.height
        
        searchBar = UISearchBar()
        searchBar.frame = CGRect(x: 0, y: 44, width: width, height: 50)
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        view.addSubview(searchBar)
        
        tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 94, width: width, height: height - 94)
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        refreshBtn = UIButton()
        refreshBtn.setTitle("갱신", for: .normal)
        refreshBtn.setTitleColor(.black, for: .normal)
        refreshBtn.frame = CGRect(x: width - 120, y: height - 120, width: 100, height: 50)
        refreshBtn.backgroundColor = .yellow
        refreshBtn.addTarget(self, action: #selector(refreshList), for: .touchUpInside)
        view.addSubview(refreshBtn)
    }
    
    @objc func refreshList() {
        
        viewModel.filterdUsers.value = []
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            self?.viewModel.fetchUsersData()
        })
    }
}


// MARK: - TableViewDelegate/ TableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filterdUsers.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.filterdUsers.value?[indexPath.row].name
        //viewModel.users는 cell의 ViewModel이므로
        //cell.configure(with: viewModel.users.value?[indexpath.row])
        //와 같이 메서드를 따로 추가하여 cell의 viewModel을 전달하고 cell의 내부에서 viewModel을 통해
        //textLabel?.text를 set하게 하여도 된다.
        return cell
    }
}


// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.userNameContainsFilter(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
