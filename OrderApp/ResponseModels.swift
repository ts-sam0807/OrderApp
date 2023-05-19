//
//  ResponseModels.swift
//  OrderApp
//
//  Created by Ts SaM on 19/5/2023.
//

import Foundation

struct MenuResponse: Codable {
  let items: [MenuItem]
}

struct CategoriesResponse: Codable {
  let categories: [String]
}

struct OrderResponse: Codable {
  let prepTime: Int
  
  enum CodingKeys: String, CodingKey {
    case prepTime = "preparation_time"
  }
}
