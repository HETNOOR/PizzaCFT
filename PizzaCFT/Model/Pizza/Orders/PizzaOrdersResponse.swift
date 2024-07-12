//
//  testModel.swift
//  PizzaCFT
//
//  Created by Максим Герасимов on 11.07.2024.
//

import Foundation

//struct Pizza: Decodable {
//    let id: String
//    let name: String
//    let description: String
//    let price: Double
//    let imageUrl: String


struct OrdersResponse: Decodable {
    let success: Bool
    let reason: String?
    let orders: [Order]
   
}

//struct Order: Decodable {
//
//}


struct Order: Decodable {
    let person: [Person]
    let receiverAddress: [ReceiverAddress]
    let status: String
    let cancellable: String
}


struct Person: Decodable {
    let name: String
    let address: String
    let phone: String
    let email: String
}

struct ReceiverAddress: Decodable {
    let name: String
    let address: String
    let phone: String
    let email: String
}

