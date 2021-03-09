//
//  AlamofireWrapper.swift
//  RxAlamofireWrapper
//
//  Created by Artem Eremeev on 13.05.2020.
//  Copyright © 2020 Artem Eremeev. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

public class AlamofireWrapper {
    
    public static let shared = AlamofireWrapper()
    
    #if DEBUG
    private var logLevel: AFWrapperLogLevel = .default
    
    public func set(logLevel: AFWrapperLogLevel) {
        self.logLevel = logLevel
    }
    #endif
    
    private var uploadRequests = [UUID: UploadRequest]()
    
    private var session: Session
    
    public func configure(session: Session) {
        self.session = session
    }
    
    public init(session: Session = Session()) {
        self.session = session
    }
    
    @discardableResult
    public func dataRequest(_ destination: URLConvertible, method: HTTPMethod, json: Any? = nil, queryParameters: [String: Any] = [:], basicAuth basicAuthInfo: BasicAuthInfo? = nil, headers: [String: String] = [:], onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) -> DataRequest {
        
        #if DEBUG
        print("Endpoint: \(try! destination.asURL().absoluteString)")
        if logLevel != .default {
            if let basicAuthInfo = basicAuthInfo {
                print("BasicAuth: \(basicAuthInfo)")
            }
            if let json = json {
                print("JSON body: \(json)")
            }
            if !queryParameters.isEmpty {
                print("QUERY parameters: \(queryParameters)")
            }
        }
        #endif
        
        let dataRequest = createDataRequest(destination,
                                            method: method,
                                            json: json,
                                            queryParameters: queryParameters,
                                            basicAuth: basicAuthInfo,
                                            headers: headers)
        
        dataRequest.validate(validateRequest).responseData(completionHandler: { dataResponse in
            self.processResponse(dataResponse: dataResponse, onSuccess: onSuccess, onError: onError)
        })
        
        return dataRequest
    }
    
    @discardableResult
    public func dataRequest(_ destination: URLConvertible, method: HTTPMethod, json: Any? = nil, queryParameters: [String: Any] = [:], basicAuth basicAuthInfo: BasicAuthInfo? = nil, headers: [String: String] = [:], onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) -> DataRequest {
        
        #if DEBUG
        print("Endpoint: \(try! destination.asURL().absoluteString)")
        if logLevel != .default {
            if let basicAuthInfo = basicAuthInfo {
                print("BasicAuth: \(basicAuthInfo)")
            }
            if let json = json {
                print("JSON body: \(json)")
            }
            if !queryParameters.isEmpty {
                print("QUERY parameters: \(queryParameters)")
            }
        }
        #endif
        
        let dataRequest = createDataRequest(destination,
                                            method: method,
                                            json: json,
                                            queryParameters: queryParameters,
                                            basicAuth: basicAuthInfo,
                                            headers: headers)
        
        dataRequest.validate(validateRequest).responseData(completionHandler: { dataResponse in
            self.processResponse(dataResponse: dataResponse, onSuccess: { _ in onSuccess() }, onError: onError)
        })
        
        return dataRequest
        
    }
    
    
    @discardableResult
    public func uploadRequest(_ destination: URLConvertible, method: HTTPMethod, formData: MultipartFormData, basicAuth basicAuthInfo: BasicAuthInfo? = nil, headers: [String: String] = [:], onSuccess: @escaping (Data) -> Void, onStateChanged: @escaping (UploadingState) -> Void, onError: @escaping (Error) -> Void) -> UploadRequest {
        
        #if DEBUG
        print("Endpoint: \(try! destination.asURL().absoluteString)")
        if logLevel != .default {
            if let basicAuthInfo = basicAuthInfo {
                print("BasicAuth: \(basicAuthInfo)")
            }
            print("Multipart Form: \(formData)")
        }
        #endif
        
        let uploadRequest = createUploadRequest(destination,
                                                method: method,
                                                formData: formData,
                                                basicAuth: basicAuthInfo,
                                                headers: headers)
        
        let requestID = uploadRequest.id
        registerUploadRequest(uploadRequest)
        
        return uploadRequest.uploadProgress(closure: { progress in
            onStateChanged(.uploading(uploadRequestID: requestID, progress: progress.fractionCompleted))
        }).validate(validateRequest).responseData(completionHandler: { dataResponse in
            self.unregisterUploadRequest(id: requestID)
            self.processResponse(dataResponse: dataResponse, onSuccess: onSuccess, onError: onError)
        })
    }
    
    @discardableResult
    public func uploadRequest(_ destination: URLConvertible, method: HTTPMethod, formData: MultipartFormData, queryParameters: [String: Any] = [:], basicAuth basicAuthInfo: BasicAuthInfo? = nil, headers: [String: String] = [:], onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) -> UploadRequest {
        
        #if DEBUG
        print("Endpoint: \(try! destination.asURL().absoluteString)")
        if logLevel != .default {
            if let basicAuthInfo = basicAuthInfo {
                print("BasicAuth: \(basicAuthInfo)")
            }
            print("Multipart Form: \(formData)")
            if !queryParameters.isEmpty {
                print("QUERY parameters: \(queryParameters)")
            }
        }
        #endif
        
        let uploadRequest = createUploadRequest(destination,
                                                method: method,
                                                formData: formData,
                                                queryParameters: queryParameters,
                                                basicAuth: basicAuthInfo,
                                                headers: headers)
        
        let requestID = uploadRequest.id
        registerUploadRequest(uploadRequest)
        
        return uploadRequest.validate(validateRequest).responseData(completionHandler: { dataResponse in
            self.unregisterUploadRequest(id: requestID)
            self.processResponse(dataResponse: dataResponse, onSuccess: onSuccess, onError: onError)
        })
    }
    
    @discardableResult
    public func uploadRequest(_ destination: URLConvertible, method: HTTPMethod, formData: MultipartFormData, queryParameters: [String: Any] = [:], basicAuth basicAuthInfo: BasicAuthInfo? = nil, headers: [String: String] = [:], onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) -> UploadRequest {
        
        #if DEBUG
        print("Endpoint: \(try! destination.asURL().absoluteString)")
        if logLevel != .default {
            if let basicAuthInfo = basicAuthInfo {
                print("BasicAuth: \(basicAuthInfo)")
            }
            print("Multipart Form: \(formData)")
            if !queryParameters.isEmpty {
                print("QUERY parameters: \(queryParameters)")
            }
        }
        #endif
        
        let uploadRequest = createUploadRequest(destination,
                                                method: method,
                                                formData: formData,
                                                queryParameters: queryParameters,
                                                basicAuth: basicAuthInfo,
                                                headers: headers)
        
        let requestID = uploadRequest.id
        registerUploadRequest(uploadRequest)
        
        return uploadRequest.validate(validateRequest).responseData(completionHandler: { dataResponse in
            self.unregisterUploadRequest(id: requestID)
            self.processResponse(dataResponse: dataResponse, onSuccess: { _ in onSuccess() }, onError: onError)
        })
    }
    
    public func cancelUploadRequest(requestID: UUID?) {
        guard let requestID = requestID else {
            return
        }
        unregisterUploadRequest(id: requestID)
    }
    
}

fileprivate extension AlamofireWrapper {
    
    private func registerUploadRequest(_ uploadRequest: UploadRequest) {
        uploadRequests[uploadRequest.id] = uploadRequest
    }
    private func unregisterUploadRequest(id: UUID) {
        if let uploadRequest = uploadRequests.removeValue(forKey: id) {
            if !uploadRequest.isFinished && !uploadRequest.isCancelled {
                uploadRequest.cancel()
            }
        }
    }
    
    func createDataRequest(_ destination: URLConvertible, method: HTTPMethod, json: Any? = nil, queryParameters: [String: Any] = [:], basicAuth basicAuthInfo: BasicAuthInfo? = nil, headers: [String: String] = [:]) -> DataRequest {
        let url = try! destination.asURL()
        var request = try! URLRequest(url: url, method: method)
        
        if let json = json {
            request = try! JSONEncoding.default.encode(request, withJSONObject: json)
        }
        
        if !queryParameters.isEmpty {
            request = try! URLEncoding.queryString.encode(request, with: queryParameters)
        }
        
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        if let basicAuthInfo = basicAuthInfo {
            return session.request(request).authenticate(username: basicAuthInfo.username, password: basicAuthInfo.password)
        }
        
        return session.request(request)
    }
    
    func createUploadRequest(_ destination: URLConvertible, method: HTTPMethod, formData: MultipartFormData, queryParameters: [String: Any] = [:], basicAuth basicAuthInfo: BasicAuthInfo? = nil, headers: [String: String] = [:]) -> UploadRequest {
        let url = try! destination.asURL()
        var request = try! URLRequest(url: url, method: method)
        
        if !queryParameters.isEmpty {
            request = try! URLEncoding.queryString.encode(request, with: queryParameters)
        }
        
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        if let basicAuthInfo = basicAuthInfo {
            return session.upload(multipartFormData: formData, with: request).authenticate(username: basicAuthInfo.username, password: basicAuthInfo.password)
        }
        return session.upload(multipartFormData: formData, with: request)
    }
    
    func createUploadRequest(_ destination: URLConvertible, method: HTTPMethod, formData: MultipartFormData, basicAuth basicAuthInfo: BasicAuthInfo? = nil, headers: [String: String] = [:]) -> UploadRequest {
        let url = try! destination.asURL()
        var reqeust = try! URLRequest(url: url, method: method)
        
        for (key, value) in headers {
            reqeust.addValue(value, forHTTPHeaderField: key)
        }
        
        if let basicAuthInfo = basicAuthInfo {
            return session.upload(multipartFormData: formData, with: reqeust).authenticate(username: basicAuthInfo.username, password: basicAuthInfo.password)
        }
        return session.upload(multipartFormData: formData, with: reqeust)
    }
    
    func processError(_ error: Error, onSuccess: (Data) -> Void, onError: (Error) -> Void) {
        if let afError = error.asAFError {
            switch afError {
            case let .responseSerializationFailed(reason):
                if case .inputDataNilOrZeroLength = reason {
                    onSuccess(Data())
                } else {
                    onError(error)
                }
            case let .requestRetryFailed(_, originalError):
                self.processError(originalError, onSuccess: onSuccess, onError: onError)
            default:
                onError(error)
            }
        } else {
            onError(error)
        }
    }
    
    func processResponse(dataResponse: AFDataResponse<Data>, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) {
        switch dataResponse.result {
        case let .success(data):
            let statusCode = dataResponse.response?.statusCode ?? 200
            
            #if DEBUG
            print("Status code: \(statusCode)")
            if logLevel == .requestWithResponse {
                if let jsonResponse = data.prettyJSONString {
                    print("JSON response:\n\(jsonResponse)")
                }
            }
            #endif
            
            guard 200..<300 ~= statusCode  else {
                onError(AFWrapperError.api(statusCode: statusCode, data: data))
                return
            }
            
            onSuccess(data)
        case let .failure(error):
            
            #if DEBUG
            print("Error: \(error)")
            #endif
            
            processError(error, onSuccess: onSuccess, onError: onError)
        }
    }
    
}

public extension AlamofireWrapper {
    func validateRequest(_ request: URLRequest?, response: URLResponse, data: Data?) -> DataRequest.ValidationResult {
        let httpResponse = response as! HTTPURLResponse
        
        if 200..<300 ~= httpResponse.statusCode {
            return .success(())
        }
        
        return .failure(AFWrapperError.api(statusCode: httpResponse.statusCode, data: data ?? Data()))
    }
    
    func dataRequest(_ desination: URLConvertible, method: HTTPMethod, json: Any? = nil, queryParameters: [String: Any] = [:], basicAuth basicAuthInfo: BasicAuthInfo? = nil, headers: [String: String] = [:]) -> Single<Data> {
        return Single.create(subscribe: { observer in
            let dataReqeust = self.dataRequest(desination, method:
                                               method, json: json,
                                               queryParameters: queryParameters,
                                               basicAuth: basicAuthInfo,
                                               headers: headers,
                                               onSuccess: { observer(.success($0)) },
                                               onError: { observer(.error($0)) })
            
            return Disposables.create {
                dataReqeust.cancel()
            }
        })
    }
    
    func dataRequest(_ desination: URLConvertible, method: HTTPMethod, json: Any? = nil, queryParameters: [String: Any] = [:], basicAuth basicAuthInfo: BasicAuthInfo? = nil, headers: [String: String] = [:]) -> Single<Void> {
        return Single.create(subscribe: { observer in
            let dataReqeust = self.dataRequest(desination, method: method,
                                               json: json,
                                               queryParameters: queryParameters,
                                               basicAuth: basicAuthInfo,
                                               headers: headers,
                                               onSuccess: { observer(.success(())) },
                                               onError: { observer(.error($0)) })
            
            return Disposables.create {
                dataReqeust.cancel()
            }
        })
    }
    
    func uploadRequest(_ destination: URLConvertible, method: HTTPMethod, formData: MultipartFormData, basicAuth basicAuthInfo: BasicAuthInfo? = nil, headers: [String: String] = [:]) -> Observable<UploadingState> {
        return Observable.create({ observer in
            
            var requestID: UUID!
            
            let uploadReqeust = self.uploadRequest(destination, method: method, formData: formData, basicAuth: basicAuthInfo, headers: headers, onSuccess: {
                observer.onNext(.completed(uploadRequestID: requestID, data: $0))
                observer.onCompleted()
            }, onStateChanged: {
                requestID = $0.uploadRequestID
                observer.onNext($0)
            }, onError: {
                observer.onError($0)
            })
            
            return Disposables.create {
                uploadReqeust.cancel()
            }
        })
    }
    
    func uploadRequest(_ destination: URLConvertible, method: HTTPMethod, formData: MultipartFormData, queryParameters: [String: Any] = [:], basicAuth basicAuthInfo: BasicAuthInfo? = nil, headers: [String: String] = [:]) -> Single<Data> {
        return Single.create(subscribe: { observer in
            
            let uploadReqeust = self.uploadRequest(destination, method: method, formData: formData, queryParameters: queryParameters, basicAuth: basicAuthInfo, headers: headers, onSuccess: { data in
                observer(.success(data))
            }, onError: { error in
                observer(.error(error))
            })
            
            return Disposables.create {
                uploadReqeust.cancel()
            }
        })
    }
    
    func uploadRequest(_ destination: URLConvertible, method: HTTPMethod, formData: MultipartFormData, queryParameters: [String: Any] = [:], basicAuth basicAuthInfo: BasicAuthInfo? = nil, headers: [String: String] = [:]) -> Single<Void> {
        return Single.create(subscribe: { observer in
            
            let uploadReqeust = self.uploadRequest(destination, method: method, formData: formData, queryParameters: queryParameters, basicAuth: basicAuthInfo, headers: headers, onSuccess: {
                observer(.success(())) 
            }, onError: { error in
                observer(.error(error))
            })
            
            return Disposables.create {
                uploadReqeust.cancel()
            }
        })
    }
}
