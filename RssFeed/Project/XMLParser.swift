
import Foundation

struct RSSItem {
    var title: String
    var description: String
    var pubDate: String
    var word:String
}

// download and parse xml


class FeedParser: NSObject, XMLParserDelegate
{
    private var rssItems: [RSSItem] = []
    
    private var currentWord:String {
       
       return wordCount(str: currentDescription)
    }
    
    
    
    private var currentElement = ""

    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var parserCompletionHandler: (([RSSItem]) -> Void)?
    
    func parseFeed(url: String, completionHandler: (([RSSItem]) -> Void)?)
    {
        self.parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                
                return
            }
            
            /// parsing xml data
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        
        task.resume()
    }
    
    // XML Parser Delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentDescription = ""
            currentPubDate = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        switch currentElement {
        case "title": currentTitle += string
        case "description" : currentDescription += string
        case "pubDate" : currentPubDate += string
        default: break
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == "item" {
            let rssItem = RSSItem(title: currentTitle, description: currentDescription, pubDate: currentPubDate, word: currentWord)
            self.rssItems.append(rssItem)
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        print(parseError.localizedDescription)
    }
    
  
    func wordCount(str: String) -> String {
        let words = str.components(separatedBy: CharacterSet.whitespaces)
        var wordDictionary = Dictionary<String, Int>()
        for word in words {
            
 
            if (word != "of"){
            
            
                                if let count = wordDictionary[word] {
                                    wordDictionary[word] = count + 1
                                } else {
                                    wordDictionary[word] = 1
                                }
                                

                
            }
            
            
        
        }
        return wordDictionary.keys.first!
    }
    
    
    
    
    
}
























