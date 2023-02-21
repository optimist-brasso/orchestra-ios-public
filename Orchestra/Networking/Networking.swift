//
//  Networking.swift
//  Orchestra
//
//  Created by manjil on 01/04/2022.
//

import Foundation
import Combine
import Alamofire

public enum NetworkingError: LocalizedError {
    case none
    case malformedDataReceived
    case nonParsableErrorReceived
    case tokenValidationFailed
    case tokenRefreshFailed(Error?)
    case failedReason(String, Int)
    case noInternetConnection
    case facebookCancelled
    case custom(String)
    case requestTimedOut
    case badGateway
    case gatewayTimeout
    case unauthorized
    case noData
    
    public var description: String {
        switch self {
        case .none, .facebookCancelled: return ""
        case .malformedDataReceived:
            return "Data couldn't be read from server. Please try again later."
        case .nonParsableErrorReceived:
            return "Data couldn't be parsed from response. Please try again later."
        case .failedReason(let reason, _): return reason
        case .noInternetConnection:
            return "インターネット接続がありません。接続を確認してください"//"The internet connection appears to be offline."
        case .custom(let msg):
            return msg
        case .tokenValidationFailed:
            return "Unable to validate the access token for request"
        case .tokenRefreshFailed(let error):
            return "Token refresh failed \(error?.localizedDescription ?? "")"
        case .requestTimedOut:
            return "The request timed out."
        case .badGateway:
            return "Server Error (502 Bad Gateway)"
        case .gatewayTimeout:
            return "Server Error (504 Gateway Timeout)"
        case .unauthorized:
            return "Unauthorized user"
        case .noData:
            return "No data"
        }
    }
    
    public var code: Int {
        switch self {
        case .failedReason(_, let code):
            return code
        case .badGateway:
            return 502
        case .gatewayTimeout:
            return 504
        case .unauthorized:
            return 401
        default:
            return 0
        }
    }
}


public struct NetworkingResult<T: Decodable> {
    public var success: Bool
    public var error: NetworkingError
    public var object:T?
    public var statusCode: Int
    
    
    public init(success: Bool = true, error: NetworkingError = .none, object: T? = nil,  statusCode: Int = 0) {
        self.success = success
        self.error = error
        self.object = object
        self.statusCode = statusCode
    }
}


class Networking {
    
    private func parser<T: Decodable>(response: DataResponse<DataParser<T>, AFError>) -> NetworkingResult<DataParser<T>> {
        Logger.shared.log(DataParser<T>.self, response)
        var result = NetworkingResult<DataParser<T>>()
        result.statusCode = response.response?.statusCode ?? 0
        
        if let object  = response.value  {
            result.object = object
        } else if let  data = response.data {
            do {
                result.object = try builder(type: T.self, data: data)
                if let error = result.object?.error {
                    result.error = .custom(error.detail)
                }
            } catch {
                result.error = .custom(error.localizedDescription)
            }
        }
        switch response.result {
        case .success(let data):
            result.object = data
            result.success = true
        case .failure(let error):
            print(error.localizedDescription)
            result.success =  false
            if   response.data  == nil ||  result.object == nil {
                result.error = .custom(error.localizedDescription)
                
                if response.response?.statusCode == NSURLErrorTimedOut {
                    result.error = .requestTimedOut
                }
            }
        }
        
        return result
        
    }
    
    func request<T: Decodable>(type: T.Type, router: Routable)  -> AnyPublisher<NetworkingResult<DataParser<T>>, Never> {
        Future<NetworkingResult<DataParser<T>>, Never> { [weak self] promise in
            AF.request(router).validate().responseDecodable(of: DataParser<T>.self) { [weak self] response in
                guard let self = self else { return }
                return  promise(.success(self.parser(response: response)))
            }
        }.eraseToAnyPublisher()
    }
    
    
    
    func requestData<T: Decodable>(type: T.Type, router: Routable) ->  AnyPublisher<NetworkingResult<T>, Never>  {
        
        Future<NetworkingResult<T>, Never> { [weak self] promise in
            AF.request(router).validate().responseData { [weak self] response in
                guard let self = self else { return }
                return  promise(.success(self.parserData(response: response)))
            }
        }.eraseToAnyPublisher()
    }
    
    func upload<T: Decodable>(type: T.Type,router: Routable) -> AnyPublisher<NetworkingResult<DataParser<T>>, Never> {
        Future<NetworkingResult<DataParser<T>>, Never> { [weak self] promise  in
            var parameter = [String: Any]()
            var file: File!
            let url = try! router.urlRequest!.url!
            switch router {
            case AuthRouter.register(file: let files, parameters: let para):
                parameter = para
                file = files
            default:
                break
            }
            
            AF.upload(multipartFormData: { multipart in
                multipart.append(file.data, withName: file.key, fileName: file.name, mimeType: file.mimeType)
                for (key, value) in parameter {
                    if let string = value as? String, let data = string.data(using: .utf8) {
                        multipart.append(data, withName: key)
                    }
                    if let bool = value as? Bool, let data = bool.description.data(using: .utf8) {
                        multipart.append(data, withName: key)
                    }
                    if let int = value as? Int, let data = int.description.data(using: .utf8) {
                        multipart.append(data, withName: key)
                    }
                    
                }
                
            }, to: url, method: router.httpMethod, headers: HTTPHeaders(router.headers)).responseDecodable(of: DataParser<T>.self, completionHandler: { [weak self] response in
                guard let self = self else { return }
                return  promise(.success(self.parser(response: response)))
            })
            
        }.eraseToAnyPublisher()
    }
    
    private func parserData<T: Decodable>(response: AFDataResponse<Data>) -> NetworkingResult<T> {
        
        Logger.shared.logData(response)
        var result = NetworkingResult<T>()
        result.statusCode = response.response?.statusCode ?? 0
        do {
            if let data =  response.data {
                let parserObject =  try  builder(type: T.self ,data: data)
                result.object = parserObject.data
                if let error = parserObject.errors.first {
                    result.error = NetworkingError.custom(error.detail)
                }
            }
        } catch(let error) {
            result.error = NetworkingError.custom(error.localizedDescription)
        }
        
        switch response.result {
        case .success:
            result.success = true
        case .failure(let error):
            //print(error.localizedDescription)
            result.success =   result.statusCode  == 200
            if   response.data  == nil {
                result.error = .custom(error.localizedDescription)
                // checking for request timed out
                if response.response?.statusCode == NSURLErrorTimedOut {
                    result.error = .requestTimedOut
                }
            }
        }
        return result
        
    }
    
    private func builder<T: Decodable>(type: T.Type,data: Data) throws ->  DataParser<T> {
        try JSONDecoder().decode(DataParser<T>.self, from: data)
    }
}

struct File {
    var data: Data
    var key: String
    var name: String
    var mimeType: String
}

struct SendToken: Codable {
    var message: String
    var detail: String
    var email: String
}

struct MessageModel: Codable {
    var code: String
    var title: String
    var detail: String
}

struct DataParser<T: Decodable> : Decodable {
    var data: T? = nil
    var errors: [MessageModel] = []
    
    
    var error: MessageModel? {
        errors.first
    }
    
    enum CodingKeys: String, CodingKey {
        case data
        case errors
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        data = try container.decodeIfPresent(T.self, forKey: .data) ?? nil
        errors = try container.decodeIfPresent([MessageModel].self, forKey: .errors) ?? []
    }
    
    init(data: T? = nil , errors: [MessageModel] = []) {
        self.data = data
        self.errors = errors
    }
}
