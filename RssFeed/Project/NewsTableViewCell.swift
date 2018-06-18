
import UIKit

enum CellState {
    case expanded
    case collapsed
}

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var wordLabel:UILabel!
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 3
        }
    }
    @IBOutlet weak var dateLabel:UILabel!

    
    var item: RSSItem! {
        didSet {
            titleLabel.text = item.title
            descriptionLabel.text = item.description
            dateLabel.text = item.pubDate
            wordLabel.text = "Bu makalede en cok gecen kelime = "+item.word
        }
    }
    
    
}












