//
//  APIClient.swift
//  PagaMe
//
//  Created by Germán Lopez on 6/8/20.
//  Copyright © 2020 Rootstrap Inc. All rights reserved.
//

import Foundation
import Alamofire

public enum SwiftBaseErrorCode: Int {
  case inputStreamReadFailed           = -6000
  case outputStreamWriteFailed         = -6001
  case contentTypeValidationFailed     = -6002
  case statusCodeValidationFailed      = -6003
  case dataSerializationFailed         = -6004
  case stringSerializationFailed       = -6005
  case jsonSerializationFailed         = -6006
  case propertyListSerializationFailed = -6007
}

public typealias SuccessCallback = (
  _ responseObject: [String: Any],
  _ responseHeaders: [AnyHashable: Any]
) -> Void

public typealias FailureCallback = (_ error: Error) -> Void

internal class APIClient {
  
  enum HTTPHeader: String {
    case accept = "Accept"
    case contentType = "Content-Type"
  }
  
  private static let emptyDataStatusCodes: Set<Int> = [204, 205]
 
  static let baseHeaders: [String: String] = [
    HTTPHeader.accept.rawValue: "application/json",
    HTTPHeader.contentType.rawValue: "application/json"
  ]
  
  fileprivate static var defaultParameters: [String: String] {
    return ["public_key": ConfigurationManager.getValue(for: "MercadoPagoKey") ?? ""]
  }
  
  class func getBaseUrl() -> String {
    return Bundle.main.object(forInfoDictionaryKey: "API URL") as? String ?? ""
  }
  
  class func defaultEncoding(forMethod method: HTTPMethod) -> ParameterEncoding {
    switch method {
    case .post, .put, .patch:
      return JSONEncoding.default
    default:
      return URLEncoding.default
    }
  }
  
  class func request(
    _ method: HTTPMethod,
    url: String,
    params: [String: Any]? = nil,
    paramsEncoding: ParameterEncoding? = nil,
    success: @escaping SuccessCallback,
    failure: @escaping FailureCallback
  ) {
    let encoding = paramsEncoding ?? defaultEncoding(forMethod: method)
    
    let requestParameters = APIClient.defaultParameters + (params ?? [:])
    
    let requestConvertible = BaseURLRequestConvertible(
      path: url,
      method: method,
      encoding: encoding,
      params: requestParameters,
      headers: APIClient.baseHeaders
    )
    
    let request = AF.request(requestConvertible)
//    request.responseString { (response) in
//      switch response.result {
//      case .success(let string):
//        print(string)
//      case .failure(let error):
//        print(error)
//      }
//
//    }
    
//    request.responseJSON { response in
//      switch response.result {
//      case .success(let dict):
//        print(dict)
//      case .failure(let error):
//        print(error)
//      }
//    }

    request.responseJSON(
      completionHandler: { result in
        validateResult(response: result, success: success, failure: failure)
      }
    )
  }
  
  //Handle rails-API-base errors if any
  class func handleCustomError(_ code: Int?, dictionary: [String: Any]) -> NSError? {
    if
      let messageDict = dictionary["errors"] as? [String: [String]],
      let firstKey = messageDict.keys.first
    {
      let errorsList = messageDict[firstKey]
      return NSError(
        domain: "\(firstKey) \(errorsList?.first ?? "")",
        code: code ?? 500,
        userInfo: nil
      )
    } else if let error = dictionary["error"] as? String {
      return NSError(domain: error, code: code ?? 500, userInfo: nil)
    } else if
      let errors = dictionary["errors"] as? [String: Any],
      let firstKey = errors.keys.first
    {
      let errorDesc = errors[firstKey] ?? ""
      return NSError(
        domain: "\(firstKey) " + "\(errorDesc)",
        code: code ?? 500,
        userInfo: nil
      )
    } else if dictionary["errors"] != nil || dictionary["error"] != nil {
      return NSError(
        domain: "Something went wrong. Try again later.",
        code: code ?? 500,
        userInfo: nil
      )
    }
    return nil
  }
  
  fileprivate class func validateResult(
    response: AFDataResponse<Any>,
    success: @escaping SuccessCallback,
    failure: @escaping FailureCallback
  ) {
    let defaultError = App.error(
      domain: .parsing,
      localizedDescription: "Error parsing response".localized
    )
  
    guard let httpResponse = response.response else {
      failure(defaultError)
      return
    }
    
    guard !validateEmptyResponse(
      response: httpResponse,
      data: response.data,
      success: success,
      failure: failure
    ) else { return }
    
    guard let data = response.data else {
      failure(defaultError)
      return
    }
    
    validateSerializationErrors(
      response: httpResponse,
      error: response.error,
      data: data,
      success: success,
      failure: failure
    )
  }
  
  fileprivate class func validateEmptyResponse(
    response: HTTPURLResponse,
    data: Data?,
    success: @escaping SuccessCallback,
    failure: @escaping FailureCallback
  ) -> Bool {
    let defaultError = App.error(
      domain: .generic,
      localizedDescription: "Unexpected empty response".localized
    )
    
    guard let data = data, !data.isEmpty else {
      let emptyResponseAllowed = emptyDataStatusCodes.contains(
        response.statusCode
      )
      emptyResponseAllowed ?
        success([:], response.allHeaderFields) : failure(defaultError)
      return true
    }
    
    return false
  }
  
  fileprivate class func validateSerializationErrors(
    response: HTTPURLResponse,
    error: Error?,
    data: Data,
    success: @escaping SuccessCallback,
    failure: @escaping FailureCallback
  ) {
    var dictionary: [String: Any]?
    var serializationError: NSError?
    do {
      dictionary = try JSONSerialization.jsonObject(
        with: data,
        options: .allowFragments
      ) as? [String: Any]
      
      if dictionary == nil {
        dictionary = [:]
        dictionary?["root"] = try JSONSerialization.jsonObject(
          with: data,
          options: .allowFragments
        ) as? [Any]
      }
      
    } catch let exceptionError as NSError {
      serializationError = exceptionError
    }
    //Check for errors in validate() or API
    if let errorOcurred = APIClient.handleCustomError(
      response.statusCode,
      dictionary: dictionary ?? [:]
    ) ?? error as NSError? {
      failure(errorOcurred)
      return
    }
    //Check for JSON serialization errors if any data received
    if let serializationError = serializationError {
      failure(serializationError)
    } else {
      success(dictionary ?? [:], response.allHeaderFields)
    }
  }
}
