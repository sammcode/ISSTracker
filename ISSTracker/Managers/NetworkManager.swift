//
//  NetworkManager.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import Foundation
import UIKit

class NetworkManager {

    static let shared = NetworkManager()
    private let openNotifyBaseURL = "http://api.open-notify.org/"
    private let whereTheISSatBaseURL = "https://api.wheretheiss.at/v1/satellites/"
    private let nasaAPIkey = "uzjQMRyhBNgDAVQ2Oqu9hceDbIrSfbMcS45HfXna"

    let cache = NSCache<NSString, UIImage>()

    private init() {}

    func getIssLocations(for timestamps: [Int64], completed: @escaping (Result<IssLocations, ITError>) -> Void) {

        let endpoint = whereTheISSatBaseURL + "25544/positions?timestamps=\(timestamps[0]),\(timestamps[1]),\(timestamps[2]),\(timestamps[3]),\(timestamps[4]),\(timestamps[5]),\(timestamps[6]),\(timestamps[7]),\(timestamps[8]),\(timestamps[9]),\(timestamps[10])&units=kilometers"

        let url = URL(string: endpoint)

        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in

            if let _ = error {
                completed(.failure(.unableToComplete))
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let issLocations = try decoder.decode(IssLocations.self, from: data)
                completed(.success(issLocations))
            }catch {
                print(error.localizedDescription)
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }

    func getPeopleInSpace(completed: @escaping(Result<PeopleInSpace, ITError>) -> Void){
        let endpoint = openNotifyBaseURL + "astros.json"

        let url = URL(string: endpoint)

        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in

            if let _ = error {
                completed(.failure(.unableToComplete))
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do{
                let decoder = JSONDecoder()
                let peopleInSpace = try decoder.decode(PeopleInSpace.self, from: data)
                completed(.success(peopleInSpace))
            }catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }

    func conductNASAImageSearch(for searchText: String, page: Int, completed: @escaping (Result<NASAImageSearchResults, ITError>) -> Void){

        let endpoint = "https://images-api.nasa.gov/search?q=\(searchText)&media_type=image&page=\(page)"

        let url = URL(string: endpoint)

        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in

            if let _ = error {
                completed(.failure(.unableToComplete))
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let nasaImageSearchResults = try decoder.decode(NASAImageSearchResults.self, from: data)
                completed(.success(nasaImageSearchResults))
            }catch {
                print(error)
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }

    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void){
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey){
            completed(image)
            return
        }

        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed(nil)
                    return
                }

            self.cache.setObject(image, forKey: cacheKey)

            completed(image)
        }

        task.resume()
    }
}
