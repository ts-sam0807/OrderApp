//
//  MenuItem.swift
//  OrderApp
//
//  Created by Ts SaM on 19/5/2023.
//

import Foundation

struct MenuItem: Codable {
  
  var id: Int
  var name: String
  var detailText: String
  var price: Double
  var category: String
  var imageURL: URL
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case detailText = "description"
    case price
    case category
    case imageURL = "image_url"
  }
  
  static let priceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencySymbol = "$"
    return formatter
  }()
  
}
