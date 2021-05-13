//
//  NetworkManager.swift
//  ISSTracker
//
//  Created by Sam McGarry on 3/8/21.
//

import Foundation

class NetworkManager {

    static let shared = NetworkManager()
    private let openNotifyBaseURL = "http://api.open-notify.org/"
    private let whereTheISSatBaseURL = "https://api.wheretheiss.at/v1/satellites/"
    private let nasaAPIkey = "uzjQMRyhBNgDAVQ2Oqu9hceDbIrSfbMcS45HfXna"

    private init() {}


    /// Retrieves the current location of the ISS from the API
    /// - Parameter completed: On completion, returns a Result type that can either be a GPSLocation struct or an ITError
    func getISSLocation(completed: @escaping (Result<IssLocation, ITError>) -> Void){

        let endpoint = whereTheISSatBaseURL + "25544"

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
                let issLocation = try decoder.decode(IssLocation.self, from: data)
                completed(.success(issLocation))
            }catch {
                print(error.localizedDescription)
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }


    /// Retrieves ISS pass time predictions from the API based on inputted gps coordinates
    /// - Parameters:
    ///   - latitude: The latitude coordinate of the inputted gps location
    ///   - longitude: The longitude coordinate of the inputted gps location
    ///   - completed: On completion, returns a Result type that can either be a PassTime struct or an ITError
    func getISSPasstimes(latitude: Double, longitude: Double, completed: @escaping (Result<PassTime, ITError>) -> Void){

        let endpoint = openNotifyBaseURL + "iss-pass.json?lat=\(latitude)&lon=\(longitude)&n=5"

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
                DispatchQueue.main.async {
                    completed(.failure(.invalidData))
                }
                return
            }

            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let passTimes = try decoder.decode(PassTime.self, from: data)
                completed(.success(passTimes))
            }catch {
                completed(.failure(.invalidData))
                print(error)
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
}
