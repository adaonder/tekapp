//
//  ApiService.swift
//  tekapp
//
//  Created by Önder Ada on 25.10.2023.
//

import Foundation

public class ApiService {
    public static var shared = ApiService()
    
    
    public func makeRequest<T:Decodable>(searchText: String, page: Int, callbackData: @escaping (ApiResponse<T>) -> Void, callbackError: @escaping (String?) -> Void) {
        print("make Requeest....")
        let path = String.init(format: Parameters.API_URL, searchText, "\(page)")
        
        print(path)
        
        guard let url = URL(string: path) else{
            callbackError("Url oluşturmada bir hata oldu.")
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application-json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) {
            (data,response,errors) in
            
            if let data = data {
                
                do {
                    
                    let httpResponse = (response as! HTTPURLResponse)
                    let httpStatusCode = httpResponse.statusCode
                    
                    switch httpStatusCode {
                    case HTTPStatusCode.ok.rawValue:
                        
                        let currentApiResponse = try JSONDecoder().decode(ApiResponse<T>.self, from: data)
                        
                        callbackData(currentApiResponse)
                        
                        break
                    default:
                        callbackError("İnternet bağlantınızı lütfen kontrol ediniz. Hata Kodu: \(httpStatusCode)")
                        break
                    }
                    
                    
                } catch(let error) {
                    print("::error:: \(error)")
                    callbackError("Bilinmeyen bir sorun oluştu. Hata: \(error)")
                }
                
            } else {
                print("Error: Data alınamadı")
                callbackError("Bilinmeyen bir sorun oluştu. Error: Data alınamadı")
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
                .filter {
                    print("cancel_url: \($0.originalRequest?.url)")
                    return $0.originalRequest?.url == url
                }.first?
                .cancel()
        }
    }
    
}
