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
    private var usersViewModel: UsersViewModel
    private let bag = DisposeBag()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(
            UserTableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        return table
    }()
    
    init(viewModel: UsersViewModel) {
        usersViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }
}

//MARK: - UI
extension MVVMViewController {
    private func setupUI() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Load Data", style: .plain, target: self, action: #selector(loadData))
    }
}

//MARK: Actions
extension MVVMViewController: UserFollowDelegate {
    @objc private func loadData() {
        usersViewModel.fetchData()
    }
    
    func didFollowUser(with viewModel: UserFollowViewModel) {
        usersViewModel.followUser(with: viewModel.user.id)
    }
}

//MARK: - MVVM
extension MVVMViewController {
    private func bindViewModel() {
        
        usersViewModel.users
            .bind(to: tableView.rx.items(
                    cellIdentifier: "cell",
                    cellType: UserTableViewCell.self)
            ) { row, model, cell in
                cell.configure(with: UserFollowViewModel(with: model))
                cell.delegate = self
            }.disposed(by: bag)
        
        tableView.rx.modelSelected(User.self)
            .bind { user in
                print(user.name)
            }.disposed(by: bag)
        
        usersViewModel.isLoading.asObservable()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { isLoading in
                isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
            }).disposed(by: bag)
        
        usersViewModel.error
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { error in
                guard !error.isEmpty else { return }
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }).disposed(by: bag)
    }
}
