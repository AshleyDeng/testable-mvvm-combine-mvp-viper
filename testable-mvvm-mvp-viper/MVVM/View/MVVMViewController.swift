//
//  MVVMViewController.swift
//  testable-mvvm-mvp-viper
//
//  Created by Ashley Deng on 2021-04-29.
//

import UIKit
import RxCocoa
import RxSwift

struct Product {
    let imageName: String
    let title: String
}

struct ProductViewModel {
    var items = PublishSubject<[Product]>()
    
    func fetchItems() {
        let products = [
            Product(imageName: "house", title: "Home"),
            Product(imageName: "gear", title: "Settings"),
            Product(imageName: "person.circle", title: "Profile"),
            Product(imageName: "airplane", title: "Flights"),
            Product(imageName: "bell", title: "Activity"),
        ]
        
        items.onNext(products)
        items.onCompleted()
    }
}

class MVVMViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        return table
    }()
    
    private let viewModel = ProductViewModel()
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        bindTableData()
    }
    
    private func bindTableData() {
        viewModel.items.bind(
            to: tableView.rx.items(
                cellIdentifier: "cell",
                cellType: UITableViewCell.self)
        ) { row, model, cell in
            cell.textLabel?.text = model.title
            cell.imageView?.image = UIImage(systemName: model.imageName)
        }.disposed(by: bag)
        
        tableView.rx.modelSelected(Product.self).bind { product in
            print(product.title)
        }.disposed(by: bag)
        
        viewModel.fetchItems()
    }
}
