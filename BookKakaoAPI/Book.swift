import Foundation

struct Book: Decodable {
    let documents: [Information]
}

struct Information: Decodable {
    let authors: [String]
    let price: Int
    let title: String
    let thumbnail: String
}
