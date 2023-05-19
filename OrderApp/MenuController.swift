//
//  MenuController.swift
//  OrderApp
//
//  Created by Ts SaM on 19/5/2023.
//

import Foundation

typealias MintesToPrepare = Int

class MenuContorller {
  
  static let shared = MenuContorller()
  static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")
  
  let baseURL = URL(string: "http://localhost:8080/")!
  
  var order = Order() {
    didSet {
      NotificationCenter.default.post(name: MenuContorller.orderUpdatedNotification, object: nil)
    }
  }
  
  
  
  func fetchCategories(completion: @escaping (Result<[String], Error>) -> Void) {
    let categoriesURL = baseURL.appendingPathComponent("categories")
    let task = URLSession.shared.dataTask(with: categoriesURL) { data, response, error in
      if let data = data {
        do {
          let jsonDecoder = JSONDecoder()
          let categoriesResponse = try jsonDecoder.decode(CategoriesResponse.self, from: data)
          completion(.success(categoriesResponse.categories))
        } catch {
          completion(.failure(error))
        }
      } else if let error = error {
        completion(.failure(error))
      }
    }
    task.resume()
  }
  
  func fetchMenuItems(forCategory categoryName: String, completion: @escaping (Result<[MenuItem], Error>) -> Void) {
    let baseMenuURL = baseURL.appendingPathComponent("menu")
    var components = URLComponents(url: baseMenuURL, resolvingAgainstBaseURL: true)!
    components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
    let menuURL = components.url!
    let task = URLSession.shared.dataTask(with: menuURL) { data, response, error in
      if let data = data {
        do {
          let jsonDecoder = JSONDecoder()
          let menuResponse = try jsonDecoder.decode(MenuResponse.self, from: data)
          completion(.success(menuResponse.items))
        } catch {
          completion(.failure(error))
        }
      } else if let error = error {
        completion(.failure(error))
      }
    }
    task.resume()
  }
  
  func submitOrder(forMenuIDs menuIDs: [Int], completion: @escaping (Result<MintesToPrepare, Error>) -> Void) {
    let orderURL = baseURL.appendingPathComponent("order")
    var request = URLRequest(url: orderURL)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let data = ["menuIds": menuIDs]
    let jsonEncoder = JSONEncoder()
    let jsonData = try? jsonEncoder.encode(data)
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      if let data = data {
        do {
          let jsonDecoder = JSONDecoder()
          let orderResponse = try jsonDecoder.decode(OrderResponse.self, from: data)
          completion(.success(orderResponse.prepTime))
        } catch {
          completion(.failure(error))
        }
      } else if let error = error {
        completion(.failure(error))
      }
    }
    task.resume()
  }
  
  
  
  
  
  
  
}



