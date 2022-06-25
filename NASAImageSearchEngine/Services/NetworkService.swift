//
//  NetworkService.swift
//  NASAImageSearchEngine
//
//  Created by Erica Gutierrez on 1/28/20.

import UIKit

var imageCache = [String : UIImage]()

protocol MediaProtocol {
    func loadMedia(urlString: String, completion: @escaping (Result<[MediaObject], MediaErrorWrapper>) -> Void)
    func loadImage(urlString: String, completion: @escaping (Result<UIImage, MediaErrorWrapper>) -> Void)
}

struct NetworkService: MediaProtocol {
    private let session: DataSessionProtocol
    init(session: DataSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func loadImage(urlString: String, completion: @escaping (Result<UIImage, MediaErrorWrapper>) -> Void) {
        if let cachedimage = imageCache[urlString] {
            completion(.success(cachedimage))
            return
        }
        
        guard let url = URL(string: urlString) else {
            let errorWrapper = MediaErrorWrapper(errorType: .faultyURLString, errorCode: urlString)
            completion(.failure(errorWrapper))
            return}
        
        session.loadData(from: url) { (data, response, err) in
            guard let httpResponse = response as? HTTPURLResponse else {
                let errorWrapper = MediaErrorWrapper(errorType: .badStatusCode, errorCode: "Unable to cast reponse as HTTPURLResponse")
                completion(.failure(errorWrapper))
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorWrapper = MediaErrorWrapper(errorType: .badStatusCode, errorCode: String(httpResponse.statusCode))
                    completion(.failure(errorWrapper))
                    return
            }
            
            if err != nil {
                let errorWrapper = MediaErrorWrapper(errorType: .imageError, errorCode: nil)
                completion(.failure(errorWrapper))
                return
            }
            
            guard
                let imageData = data,
                let photoImage = UIImage(data: imageData)
                else {
                    let errorWrapper = MediaErrorWrapper(errorType: .badParsing, errorCode: nil)
                    completion(.failure(errorWrapper))
                    return}
            completion(.success(photoImage))
        }
    }
    
    func loadMedia(urlString: String, completion: @escaping (Result<[MediaObject], MediaErrorWrapper>) -> Void) {
        guard let url = URL(string: urlString) else {
            let errorWrapper = MediaErrorWrapper(errorType: .faultyURLString, errorCode: urlString)
            completion(.failure(errorWrapper))
            return
        }
        
        session.loadData(from: url) { (data, response, err) in
            guard let httpResponse = response as? HTTPURLResponse else {
                let errorWrapper = MediaErrorWrapper(errorType: .badStatusCode, errorCode: "Unable to cast reponse as HTTPURLResponse")
                completion(.failure(errorWrapper))
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorWrapper = MediaErrorWrapper(errorType: .badStatusCode, errorCode: String(httpResponse.statusCode))
                    completion(.failure(errorWrapper))
                    return
            }
            
            if err != nil {
                let errorWrapper = MediaErrorWrapper(errorType: .mediaError, errorCode: nil)
                completion(.failure(errorWrapper))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let data = data else {return}
                let rawNetworkResponse = try decoder.decode(JSONObject.self, from: data)
                completion(.success(rawNetworkResponse.collection.items))
            } catch {
                let errorWrapper = MediaErrorWrapper(errorType: .badParsing, errorCode: nil)
                completion(.failure(errorWrapper))
            }
        }
    }
}
