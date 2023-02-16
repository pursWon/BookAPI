import UIKit
import Alamofire
import Kingfisher
import RealmSwift

class BooksTableViewController: UITableViewController {
    @IBOutlet var booksTableView: UITableView!
    
    let url: String = "https://dapi.kakao.com/v3/search/book?target=title"
    var bookList: [Information] = []
    var bookArray: [BookData] = []
    
    let realm = try! Realm()
    var book = BookData(title: "", author: "", price: 0, thumbnail: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBookData()
    }
    
    func getDataStorage() {
        let books = Array(realm.objects(BookData.self))
        
        for index in 0..<bookList.count {
            book = BookData(title: bookList[index].title, author: bookList[index].authors.first!,
                            price: bookList[index].price, thumbnail: bookList[index].thumbnail)
            
            // try! realm.write {
            //     realm.add(book)
            // }
        
        bookArray = books
        print(bookArray)
        print(bookArray.count)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookCell else { return UITableViewCell() }
        
        cell.title.text = bookArray[indexPath.row].title
        cell.price.text = String(bookArray[indexPath.row].price)
        cell.author.text = bookArray[indexPath.row].author
        
        if let imageURL = URL(string: bookArray[indexPath.row].thumbnail) {
            cell.bookImage.kf.setImage(with: imageURL)
        } else {
            cell.bookImage.image = UIImage(named: "kingfisher-7")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func getBookData() {
        let headers: HTTPHeaders = ["Authorization": "KakaoAK b458fb7a1977b0079080e5622942b26d"]
        
        let parameters: [String: Any] = [
            "query" : "여행",
            "sort" : "accuracy",
            "page" : "1",
            "size" : "20"
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers).responseDecodable(of: Book.self) { response in
            if let data = response.value {
                self.bookList = data.documents
                
            } else {
                print("통신 실패")
            }
            
            DispatchQueue.main.async {
                self.getDataStorage()
                self.booksTableView.reloadData()
            }
        }
    }
}

class BookCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
}

