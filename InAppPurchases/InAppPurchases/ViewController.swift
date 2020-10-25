//
//  ViewController.swift
//  InAppPurchases
//
//  Created by Mohamad Mortada on 10/24/20.
//
import StoreKit
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SKProductsRequestDelegate {
   
    
    
    
    //Protocol stubs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = models [indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(product.localizedTitle): \(product.localizedDescription) - \(product.priceLocale.currencySymbol ?? "$")\((product.price))"
        return cell
    }
    
    private func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({$0.rawValue})))
        request.delegate = self
        request.start()
    }
     func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    DispatchQueue.main.async {
        print("Count: \(response.products)")
        self.models = response.products
        self.tableView.reloadData()
    }
    }

    
    
    
    enum Product: String, CaseIterable {
        case removeAds = "com.myapp.removeAds"
        case unlockEverything  = "com.myapp.random"
        case getGems  = "com.myapp.pay"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let payment = SKPayment(product: models[indexPath.row])
        SKPaymentQueue.default().add(payment)
    }
    
   
    

   private var models = [SKProduct]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
        fetchProducts()
        
    }


}

