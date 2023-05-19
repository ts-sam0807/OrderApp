//
//  OrderTableViewController.swift
//  OrderApp
//
//  Created by Ts SaM on 19/5/2023.
//

import UIKit

class OrderTableViewController: UITableViewController {
  
  var mintesToPrepareOrder = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = editButtonItem
    
    NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: MenuContorller.orderUpdatedNotification, object: nil)
  }
  
  @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
    if segue.identifier == "dismissConfirmation" {
      MenuContorller.shared.order.menuItems.removeAll()
    }
  }
  
  @IBSegueAction func confirmOrder(_ coder: NSCoder) -> OrderConfirmationViewController? {
    return OrderConfirmationViewController(coder: coder, minutesToPrepare: mintesToPrepareOrder)
  }
  
  @IBAction func submitTapped(_ sender: Any) {
    let orderTotal = MenuContorller.shared.order.menuItems.reduce(0.0) {
      (result, menuItem) -> Double in
      return result + menuItem.price
    }
    let formattedTotal = MenuItem.priceFormatter.string(from: NSNumber(value: orderTotal)) ?? "\(orderTotal)"
    let alertController = UIAlertController(
      title: "Confirm Order",
      message: "You are about to submit your order with a total of \(formattedTotal)",
      preferredStyle: .actionSheet
    )
    alertController.addAction(
      UIAlertAction(
        title: "Submit",
        style: .default,
        handler: { _ in
          self.uploadOrder()
        }
      )
    )
    alertController.addAction(
      UIAlertAction(
        title: "Cancel",
        style: .cancel,
        handler: nil
      )
    )
    present(alertController, animated: true, completion: nil)
  }
  
  
  func uploadOrder() {
    let menuIds = MenuContorller.shared.order.menuItems.map { $0.id }
    MenuContorller.shared.submitOrder(forMenuIDs: menuIds) { (result) in
      switch result {
      case .success(let minutesToPrepare):
        DispatchQueue.main.async {
          self.mintesToPrepareOrder = minutesToPrepare
          self.performSegue(
            withIdentifier: "confirmOrder",
            sender: nil
          )
        }
      case .failure(let error):
        self.displayError(error, title: "Order Submission Failed")
      }
    }
  }
  
  func displayError(_ error: Error, title: String) {
    DispatchQueue.main.async {
      let alert = UIAlertController(
        title: title,
        message: error.localizedDescription,
        preferredStyle: .alert
      )
      alert.addAction(
        UIAlertAction(
          title: "Dismiss",
          style: .default,
          handler: nil)
      )
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return MenuContorller.shared.order.menuItems.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)
    configure(cell, forItemAt: indexPath)
    return cell
  }
  
  func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
    let menuItem = MenuContorller.shared.order.menuItems[indexPath.row]
    cell.textLabel?.text = menuItem.name
    cell.detailTextLabel?.text = MenuItem.priceFormatter.string(from: NSNumber(value: menuItem.price))
    MenuContorller.shared.fetchImage(url: menuItem.imageURL) { (image) in
      guard let image = image else { return }
      DispatchQueue.main.async {
        if let currentIndexPath = self.tableView.indexPath(for: cell),
            currentIndexPath != indexPath {
          return
        }
        cell.imageView?.image = image
        cell.setNeedsLayout()
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      MenuContorller.shared.order.menuItems.remove(at: indexPath.row)
    }
  }
  
}
