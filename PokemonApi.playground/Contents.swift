import UIKit

struct SearchResult: Decodable {
    let count: Int
    let next: String
    let previous: String
    let results: [Result]

}



struct Result: Decodable {
    let name: String
    let url: String
}

struct SearchResultsTwo: Decodable {
    let abilities: [ResultHabilities]
    let weight: Int
}

struct ResultHabilities: Decodable {
    var ability: abilityes
    let is_hidden: Bool
    let slot: Int
}

struct abilityes: Decodable {
    let name: String
    let url: String

}





fileprivate func fetchPokemon() {
    let urlString = "https://pokeapi.co/api/v2/pokemon?limit=100&offset=200"

    guard let url = URL(string: urlString) else { return}

    URLSession.shared.dataTask(with: url) { (data, resp, err) in
//        failaure
        if let err = err {
            print("Failed to fetch apps:", err)
            return
        }
//        sucess
//        print(data)
//        print(String(data: data!, encoding: .utf8))
        guard let data = data else {return}

        do {
            let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
//            print(searchResult)

            searchResult.results.forEach { (result) in
//                Segundo Llamado
                let  urlStringTwo = result.url
//                print(urlStringTwo)

                guard let url = URL(string: urlStringTwo) else {return}

                secondCallApi(url: url)
            }
        } catch let jsonErr {
            print("Failed Decode Json", jsonErr)
        }
    }.resume()
}

fileprivate func secondCallApi(url: URL) {
    URLSession.shared.dataTask(with: url) { (data, resp, err) in
        if let err = err {
            print("Failed to second fecth", err)
            return
        }
//                    print(data)
//                    print(String(data: data!, encoding: .utf8))
        guard let data = data else {return}

        do {
            let searchResultsTwo = try JSONDecoder().decode(SearchResultsTwo.self, from: data)
//            debugPrint(searchResultsTwo)

//            print(searchResultsTwo.weight)
            searchResultsTwo.abilities.forEach({print(" ability: \($0.ability.name), hidden: \($0.is_hidden), slot: \($0.slot)")})

        } catch let jsonErrTwo {
            print("Failed Decode Json", jsonErrTwo)
        }
    }.resume()
}
fetchPokemon()

