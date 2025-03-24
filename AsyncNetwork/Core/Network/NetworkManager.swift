//
//  NetworkManager.swift
//  AsyncNetwork
//
//  Created by Ali Mert Ozhayta [Obssteknolojileri] on 18.12.2024.
//

import UIKit

enum APIError: Error {
    case invalidURL(String)
    case invalidResponse
    case invalidData
    case badServerResponse
}

protocol NetworkProtocol {
    func call<T: Decodable>(request: Encodable, endpoint: String, responseType: T.Type) async throws -> T
    func callWithTaskCompletionHandler<T: Decodable>(request: Encodable, endpoint: String, responseType: T.Type) async throws -> T
}

final class NetworkManager: NetworkProtocol {

    private static let session = URLSession(
        configuration: .default,
        delegate: CustomSessionDelegate(),
        delegateQueue: nil
    )


    ///uses `URLSession.shared.dataTask` with async to call the service
    func call<T: Decodable>(
        request: Encodable,
        endpoint: String,
        responseType: T.Type
    ) async throws -> T {
        let request = try getRequest(for: endpoint, with: request)
        do {
            // Perform the async network request
            let (data, response) = try await NetworkManager.session.data(for: request)

            // Ensure the response status code is valid
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw APIError.badServerResponse
            }
            
            /// print response
            print("Received Response for: \(endpoint)\n")
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("Response for: \(endpoint)\n\n\(jsonString)\n")
//            }
             
            // Decode the response
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            // Handle cancellation
            if let urlError = error as? URLError,
               urlError.code == .cancelled {
                print("Request canceled: \(endpoint)")
            }
            throw error
        }
    }

    /// uses `URLSession.shared.dataTask` with completionHandler to call the service
    func callWithTaskCompletionHandler<T: Decodable>(
        request: Encodable,
        endpoint: String,
        responseType: T.Type
    ) async throws -> T {
        // Use a reference to store the task safely
        let threadSafe = ThreadSafe<URLSessionDataTask>()
        let request = try getRequest(for: endpoint, with: request)

        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                let task = NetworkManager.session.dataTask(with: request) { (data, response, error) in
                    if let error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    // Ensure the response status code is valid
                    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                        continuation.resume(throwing: APIError.badServerResponse)
                        return
                    }
                    
                    guard let data else {
                        continuation.resume(throwing: APIError.invalidData)
                        return
                    }
                    
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        continuation.resume(returning: decodedData)
                    } catch(let error) {
                        continuation.resume(throwing: error)
                    }
                }
                threadSafe.value = task
            }
        }
        onCancel: {
            print("Task is canceled! Cancelling the request...")
            threadSafe.value?.cancel()
            print("Request canceled: \(endpoint)")
        }
    }
    
    /// define default request properties
    /// For instance request header, timeout, httpMethod, etc..
    ///
    private func getRequest(for endpoint: String, with body: Encodable) throws -> URLRequest {
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL("Invalid URL: \(endpoint)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 60
       
        let data = try JSONEncoder().encode(body)
        request.httpBody = data
        
        let header = getRequestHeader()
        request.allHTTPHeaderFields = header
        
        let requestBody = String(data: data, encoding: .utf8) ?? ""
        let headerData = try? JSONEncoder().encode(header)
        let requestHeader = String(data: headerData ?? Data(), encoding: .utf8) ?? ""

        print("""
        \nRequested: \(endpoint)
        Header: \(requestHeader)
        Body: \(requestBody)\n
        """)

        return request
    }
    
    private func getRequestHeader() -> [String : String] {
        ["Content-Type": "application/json"]
    }
    
    deinit {
        print("NetworkManager deinitialized\n")
    }
}
