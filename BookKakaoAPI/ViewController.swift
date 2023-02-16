import UIKit
import Alamofire
import Kingfisher

class BooksTableViewController: UITableViewController {
    @IBOutlet var booksTableView: UITableView!
    
    let url: String = "https://dapi.kakao.com/v3/search/book?target=title"
    var bookList: [Information] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBookData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookCell else { return UITableViewCell() }
        
        cell.title.text = bookList[indexPath.row].title
        cell.price.text = String(bookList[indexPath.row].price)
        cell.author.text = bookList[indexPath.row].authors.first
        
        if let imageURL = URL(string: bookList[indexPath.row].thumbnail) {
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
                print(data.documents)
                self.bookList = data.documents
                print(self.bookList.count)
            } else {
            print("통신 실패")
            }
            
            DispatchQueue.main.async {
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

