//
//  Order.swift
//  OrderApp
//
//  Created by Ts SaM on 19/5/2023.
//

import Foundation

struct Order: Codable {
  var menuItems: [MenuItem]
  
  init (menuItems: [MenuItem] = []) {
    self.menuItems = menuItems
  }
}
