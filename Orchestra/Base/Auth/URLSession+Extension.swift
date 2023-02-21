//
//  URLSession+Extension.swift
//  
//
//  Created by Mukesh Shakya on 06/01/2022.
//

import Foundation

public class APICall: Equatable {
    
    private let id = UUID()
    private var task: ((Error?) -> URLSessionDataTask?)?
    private var actualDataTask: URLSessionDataTask?
    
    init(task: @escaping (Error?) -> URLSessionDataTask?) {
        self.task = task
    }
    
    init() {
        task = nil
    }
    
    func cancel() {
        actualDataTask?.cancel()
        apiQueue.removeAll(where: {$0 == self})
    }
    
    func execute(explicitError error: Error? = nil) {
        actualDataTask = task?(error)
        apiQueue.removeAll(where: {$0 == self})
    }
    
    public static func ==(lhs: APICall, rhs: APICall) -> Bool {
        return lhs.id == rhs.id
    }
    
}

private var apiQueue: [APICall] = []
private var refreshQueue: [APICall] = []
fileprivate var isRefreshing: Bool { return refreshQueue.count > .zero }

extension URLSession {

    public struct File {
        
        public let name: String
        public let fileName: String
        public let data: Data
        public let contentType: String
        
        public init(name: String, fileName: String, data: Data, contentType: String) {
            self.name = name
            self.fileName = fileName
            self.data = data
            self.contentType = contentType
        }
        
    }
    
    @discardableResult
    public func dataTask<T: Codable>(request: EK_Request, completion: @escaping (Result<(T, Pagination?),Error>) -> ()) -> APICall {
        let apiCall = APICall(task: { error in
            if let error = error {
                completion(.failure(error))
                return nil
            } else {
                var newRequest = request.request
                if let token = Auth.shared.oAuth?.accessToken, let type = Auth.shared.oAuth?.tokenType {
                    newRequest.addValue("\(type) \(token)", forHTTPHeaderField: "Authorization")
                }
                newRequest.addValue(Configuration.conf?.clientId ?? "", forHTTPHeaderField: "client_id")
                newRequest.addValue(Configuration.conf?.clientSecret ?? "", forHTTPHeaderField: "client_secret")
                URLRequestLogger.log(request: newRequest)
                let task = self.dataTask(with: newRequest) { [weak self] (data, response, error) in
                    self?.handle(data: data, response: response, error: error, completion: { (result: Result<ApiResponse<T>, Error>) in
                        switch result {
                        case .success(let successData):
                            completion(.success((successData.data!, successData.meta?.pagination)))
                        case .failure(let error):
                            (error as NSError).code == -1009 ? completion(.failure(EK_GlobalConstants.Error.internetConnectionOffline)) : completion(.failure(error))
                        }
                    })
                }
                task.resume()
                return task as! URLSessionDataTask
            }
        })
        if request.endPoint.needsAuthorization {
            //Check if token is valid or not
            if !Auth.shared.isTokenValid() {
                if !isRefreshing {
                    refreshQueue.append(apiCall)
                    refresh { [weak self] result in
                        switch result {
                        case .success():
                            self?.successRefreshingToken()
                        case .failure(let error):
                            self?.failureRefreshingToken(error: error)
                        }
                    }
                } else {
                    refreshQueue.append(apiCall)
                }
                return apiCall
            }
            apiQueue.append(apiCall)
        } else {
            apiQueue.append(apiCall)
        }
        apiCall.execute()
        return apiCall
    }
    
    @discardableResult
    public func fileUpload<T: Codable>(request: EK_Request, params: [String: Any]? = nil, files: [File], completion: @escaping (Result<T, Error>) -> ()) -> APICall {
        let apiCall = APICall(task: { error in
            if let error = error {
                completion(.failure(error))
                return nil
            } else {
                var newRequest = request.request
                if let token = Auth.shared.oAuth?.accessToken, let type = Auth.shared.oAuth?.tokenType {
                    newRequest.addValue("\(type) \(token)", forHTTPHeaderField: "Authorization")
                }
                newRequest.addValue(Configuration.conf?.clientId ?? "", forHTTPHeaderField: "client_id")
                newRequest.addValue(Configuration.conf?.clientSecret ?? "", forHTTPHeaderField: "client_secret")
                // generate boundary string using a unique per-app string
                let boundary = UUID().uuidString
                // Set the URLRequest to POST and to the specified URL
                var urlRequest = newRequest
                // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
                // And the boundary is also set here
                urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                let data = self.createBodyWithMultipleImages(parameters: params, files: files, boundary: boundary)
                URLRequestLogger.log(request: urlRequest)
                // Send a POST request to the URL, with the data we created earlier
                let task = self.uploadTask(with: urlRequest, from: data) { [weak self] (data, response, error) in
                    self?.handle(data: data, response: response, error: error, completion: { (result: Result<ApiResponse<T>, Error>) in
                        switch result {
                        case .success(let successData):
                            completion(.success(successData.data!))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    })
                }
                task.resume()
                return task
            }
        })
        if request.endPoint.needsAuthorization {
            //Check if token is valid or not
            if !Auth.shared.isTokenValid() {
                if !isRefreshing {
                    refreshQueue.append(apiCall)
                    refresh { [weak self] result in
                        switch result {
                        case .success():
                            self?.successRefreshingToken()
                        case .failure(let error):
                            self?.failureRefreshingToken(error: error)
                        }
                    }
                } else {
                    refreshQueue.append(apiCall)
                }
                return apiCall
            }
        } else {
            apiQueue.append(apiCall)
        }
        apiCall.execute()
        return apiCall
    }
    
    private func createBodyWithMultipleImages(parameters: [String: Any]?, files: [File], boundary: String) -> Data {
        var body = Data()
        if let parameters = parameters {
            for (key, value) in parameters {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(value)\r\n".data(using: .utf8)!)
            }
        }
        files.forEach{
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\($0.name)\"; filename=\"\($0.fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \($0.contentType)\r\n\r\n".data(using: .utf8)!)
            body.append($0.data)
            body.append("\r\n".data(using: .utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
    
    private func handle<T: Container>(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<T, Error>) -> ()) {
        URLRequestLogger.log(data: data, response: response, error: error)
        func send(error: Error) {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
        func send(object: T) {
            DispatchQueue.main.async {
                completion(.success(object))
            }
        }
        if (error as NSError?)?.code == -999 {return}
        if let error = error {
            return send(error: error)
        }
        let statuscode = (response as? HTTPURLResponse)?.statusCode ?? 500
        if let data = data {
            do {
                let decoder = JSONDecoder()
                let container = try decoder.decode(T.self, from: data)
                if let error = container.errors?.first {
                    if statuscode == 401 {
                        DispatchQueue.main.async {
                            KeyChainManager.standard.clear()
                            EK_GlobalConstants.Notification.statusCodeNeedsToBeHandled.fire(withObject: 401)
                            return
                        }
                    }
                    return send(error: NSError(domain: "error", code: statuscode, userInfo: [NSLocalizedDescriptionKey: error.detail ?? LocalizedKey.oops.value]))
                }
                if container.hasData {
                    return send(object: container)
                }
            }
//            catch let jsonError as NSError {
//                print("JSON decode failed: \(jsonError.localizedDescription)")
//            } catch let DecodingError.dataCorrupted(context) {
//                print(context)
            catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
        if statuscode == 401 {
            KeyChainManager.standard.clear()
            EK_GlobalConstants.Notification.statusCodeNeedsToBeHandled.fire(withObject: statuscode)
            return
        }
        return send(error: EK_GlobalConstants.Error.oops)
    }
    
    private func refresh(completion: @escaping (Result<Void, Error>) -> ()) {
        guard let refreshToken = Auth.shared.oAuth?.refreshToken else {return}
        let params: [String: Any] = [
            "grant_type": Provider.refreshToken.rawValue,
            "refresh_token": refreshToken,
            "client_id": Configuration.conf?.clientId ?? "",
            "client_secret": Configuration.conf?.clientSecret ?? "",
        ]
        let urlSession = URLSession.shared
        let endPoint = EK_EndPoint(path: "auth/login", method: .post, needsAuthorization: false)
        let request = endPoint.request(body: params)
        urlSession.dataTask(request: request) { (result: Result<(AuthModel, Pagination?), Error>) in
            switch result {
            case .success((let model, _)):
                model.date = Date()
                if let isFromSocialMedia = Auth.shared.oAuth?.isFromSocialMedia {
                    model.isFromSocialMedia = isFromSocialMedia
                }
                model.expiresIn = 300
                KeyChainManager.standard.set(object: model, forKey: EK_GlobalConstants.authKey)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func successRefreshingToken() {
        debugPrint(#function, "is called")
        refreshQueue.forEach {
            $0.execute()
        }
        refreshQueue.removeAll()
    }
    
    private func failureRefreshingToken(error: Error) {
        refreshQueue.forEach({
            $0.execute(explicitError: error)
        })
        refreshQueue.removeAll()
    }
    
}
