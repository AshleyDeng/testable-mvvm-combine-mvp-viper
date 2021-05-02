//
//  MVVMViewController.swift
//  testable-mvvm-mvp-viper
//
//  Created by Ashley Deng on 2021-04-29.
//

import UIKit
import RxCocoa
import RxSwift

class UserTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class MVVMViewController: UIViewController {
    
    private let usersViewModel = UsersViewModel()
    private let bag = DisposeBag()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(
            UserTableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        bindTableData()
    }
    
    private func bindTableData() {
        usersViewModel.users.bind(
            to: tableView.rx.items(
                cellIdentifier: "cell",
                cellType: UserTableViewCell.self)
        ) { row, model, cell in
            cell.textLabel?.text = model.name
            cell.detailTextLabel?.text = model.email
        }.disposed(by: bag)
        
        tableView.rx.modelSelected(User.self).bind { user in
            print(user.name)
        }.disposed(by: bag)
        
        usersViewModel.fetchData()
    }
}
