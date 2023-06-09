//
//  MenuItemDetailViewController.swift
//  OrderApp
//
//  Created by Ts SaM on 19/5/2023.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
  
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var priceLabel: UILabel!
  @IBOutlet var detailTextLabel: UILabel!
  @IBOutlet var addToOrderButton: UIButton!
  
  let menuItem: MenuItem
  
  init?(coder: NSCoder, menuItem: MenuItem) {
    self.menuItem = menuItem
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @IBAction func orderButtonTapped(_ sender: UIButton) {
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.1,
      options: [],
      animations: {
        self.addToOrderButton.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
      }, completion: nil
    )
    
    MenuContorller.shared.order.menuItems.append(menuItem)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addToOrderButton.layer.cornerRadius = 5.0
    updateUI()
  }
  
  func updateUI() {
    title = menuItem.name
    nameLabel.text = menuItem.name
    priceLabel.text = MenuItem.priceFormatter.string(from: NSNumber(value: menuItem.price))
    detailTextLabel.text = menuItem.detailText
    MenuContorller.shared.fetchImage(url: menuItem.imageURL) { (image) in
      guard let image = image else { return }
      DispatchQueue.main.async {
        self.imageView.image = image
      }
    }
  }
  
  
}
