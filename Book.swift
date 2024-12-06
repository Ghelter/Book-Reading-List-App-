//
//  Book.swift
//  FinalProject
//
//  Created by andres siri on 11/29/24.
//

import Foundation
import SwiftData

@Model
class Book {
    @Attribute(.unique) var title: String
    var author: String
    var genre: String
    var price: Double
    
    init(title: String, author: String, genre: String, price: Double) {
        self.title = title
        self.author = author
        self.genre = genre
        self.price = price
    }
}
