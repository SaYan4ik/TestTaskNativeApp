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
        print(urlComponents.url)
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

        let fieldName = "name"
        let fieldValue = name

        let fieldName2 = "typeId"
        let fieldValue2 = id

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: URL(string: "https://junior.balinasoft.com/api/v2/photo")!)
        urlRequest.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        // Add the reqtype field and its value to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue)".data(using: .utf8)!)

        // Add the userhash field and its value to the raw http reqyest data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName2)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue2)".data(using: .utf8)!)

        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"photo\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.jpegData(compressionQuality: 0.5)!)

        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        // According to the HTTP 1.1 specification https://tools.ietf.org/html/rfc7230
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
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



