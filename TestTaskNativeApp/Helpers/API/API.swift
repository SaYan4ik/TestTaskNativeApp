//
//  API.swift
//  TestTaskNativeApp
//
//  Created by Александр Янчик on 13.04.23.
//

import UIKit

final class NetworkeManager {
    func getDataInObject(complition: @escaping (UserModel) -> Void, failure: @escaping ((Error) -> Void)) {
        guard let url = URL(string: "https://junior.balinasoft.com/api/v2/photo/type") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                let jsonData = try JSONDecoder().decode(UserModel.self, from: data)
                print(jsonData)
                complition(jsonData)
            } catch {
                print(error)
                failure(error)
            }
            
        }.resume()
    }
    
    func getDataWithPaging(page: Int, complition: @escaping (UserModel) -> Void, failure: @escaping ((Error) -> Void)) {

        guard var urlComponents = URLComponents(string: "https://junior.balinasoft.com/api/v2/photo/type") else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
        ]
        guard let newURL = urlComponents.url else { return }
        
        URLSession.shared.dataTask(with: newURL) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                let jsonData = try JSONDecoder().decode(UserModel.self, from: data)
                print(jsonData)
                complition(jsonData)
            } catch {
                print(error)
                failure(error)
            }
            
        }.resume()
    }
    
    func uploadImage(name: String, id: Int, image: UIImage) {
        let filename = "\(id).jpg"
        let boundary = UUID().uuidString
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var urlRequest = URLRequest(url: URL(string: "https://junior.balinasoft.com/api/v2/photo")!)
        urlRequest.httpMethod = "POST"

        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(name)".data(using: .utf8)!)

        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"typeId\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(id)".data(using: .utf8)!)

        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"photo\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.jpegData(compressionQuality: 0.5)!)
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            
            if(error != nil){
                print("\(error!.localizedDescription)")
            }
            
            guard let responseData = responseData else {
                print("no response data")
                return
            }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            print(statusCode)
            
            if let responseString = String(data: responseData, encoding: .utf8) {
                
                print("uploaded to: \(responseString)")
            }
        }).resume()
    }
    
}



