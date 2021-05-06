//
//  MVVMViewController.swift
//  testable-mvvm-mvp-viper
//
//  Created by Ashley Deng on 2021-04-29.
//

import UIKit
import RxCocoa
import RxSwift
import SVProgressHUD

class MVVMViewController: UIViewController {
    private var userViewModel: UserViewModel
    private let bag = DisposeBag()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(
            UserTableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        return table
    }()
    
    init(viewModel: UserViewModel) {
        userViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        bindViewModel()
    }
    
    private func bindViewModel() {
        userViewModel.users.bind(
            to: tableView.rx.items(
                cellIdentifier: "cell",
                cellType: UserTableViewCell.self)
        ) { row, model, cell in
            cell.textLabel?.text = model.name
            cell.detailTextLabel?.text = model.email
        }.disposed(by: bag)
        
        userViewModel.isLoading
            .asDriver()
            .drive(onNext: { [weak self] isLoading in
                self?.showLoading(isLoading: isLoading)
            }).disposed(by: bag)
        
        tableView.rx.modelSelected(User.self)
            .bind { user in
                print(user.name)
            }.disposed(by: bag)
        
        userViewModel.fetchData()
    }
    
    private func showLoading(isLoading: Bool) {
        isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
    }
}
