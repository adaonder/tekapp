//
//  ApiService.swift
//  tekapp
//
//  Created by Önder Ada on 25.10.2023.
//

import Foundation

final public class ApiService {
    public static var shared = ApiService()
    
    public func makeRequest<T:Decodable>(path: String, callbackData: @escaping (T) -> Void, callbackError: @escaping (String?) -> Void) {
        guard let url = URL(string: path) else{
            callbackError("string_to_url_error".localized())
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application-json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) {
            (data,response,errors) in
            if let data = data {
                do {
                    let httpResponse = (response as? HTTPURLResponse)
                    let httpStatusCode = httpResponse?.statusCode
                    
                    switch httpStatusCode {
                    case HTTPStatusCode.ok.rawValue:
                        let currentApiResponse = try JSONDecoder().decode(T.self, from: data)
                        callbackData(currentApiResponse)
                        break
                    default:
                        callbackError(String(format: "api_response_server_error".localized(), "\(httpStatusCode ?? 0)"))
                        break
                    }
                } catch(let error) {
                    callbackError(String(format: "api_response_unknown_error".localized(), "\(error.localizedDescription)"))
                }
            } else {
                callbackError("api_response_data_empty".localized())
            }
        }.resume()
    }
    
    public func makeRequestImage(url: String, completion: ((Data) -> Void)?) {
        guard let url = URL(string: url) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let imageData = data else { return }
            completion?(imageData)
        }.resume()
    }
    
    
    func cancelAllSearchRunningTask(_ path: String) {
        guard let url = URL(string: path) else {
            return
        }
        
        URLSession.shared.getAllTasks { tasks in
            tasks
                .filter { $0.state == .running }
                .filter {$0.originalRequest?.url == url}.first?
                .cancel()
        }
    }
}
