import Foundation
import RealmSwift

class Book: Object, Decodable {
    var documents = List<Information>()
    
    private enum CodingKeys: String, CodingKey {
        case documents = "documents"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let documentsDataDecode = try container.decodeIfPresent([Information].self, forKey: .documents) ?? [Information()]
        
        documents.append(objectsIn: documentsDataDecode)
    }
}

class Information: Object, Decodable {
    @objc dynamic var price: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var thumbnail: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case price = "price"
        case title = "title"
        case thumbnail = "thumbnail"
    }
}






