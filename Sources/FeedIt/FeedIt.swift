import SwiftUI
import Combine

struct Show: Decodable {
    let name, imageUrl: String
}

@available(iOS 13.0, *)
class NetworkManager: BindableObject {
    var didChange = PassthroughSubject<NetworkManager, Never>()
    var shows = [Show]() {
        didSet {
            didChange.send(self)
        }
    }
    
    init(params: String) {
        guard let url = URL(string: "http://app.feedit.dev/j\(params)") else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            let shows = try! JSONDecoder().decode([Show].self, from: data)
            DispatchQueue.main.async {
                self.shows = shows
            }
            print("Got the shows")
        }.resume()
    }
}

@available(iOS 13.0, *)
class FeedIt {
    @State var showsFetcher = NetworkManager(params: "?shows=true")
    @State var showFetcher  = NetworkManager(params: "?shows=true&show_id=first")    
}
