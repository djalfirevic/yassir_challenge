//
//  API.swift
//  YassirMovies
//
//  Created by Djuro on 11/20/23.
//

import Foundation
import os.log
import SystemConfiguration

enum HTTPMethod {
	case delete
	case get
	case patch
	case post
	case put
	case multipart(filename: String, data: Data, mimeType: String, formData: [String: String]?)
}

enum HTTPScheme: String {
	case http
	case https
}

enum HTTPHeaderField: String {
	case contentType = "Content-Type"
	case accept = "Accept"
	case authorization = "Authorization"
}

enum APIError: LocalizedError {
	case invalidURL
	case unknown
	case unauthorized
	case network(Error)
	case error(reason: String)
	
	var errorDescription: String? {
		switch self {
		case .invalidURL:
			return "Invalid URL"
		case .unknown:
			return "Unknown error"
		case .unauthorized:
			return "Unauthorized"
		case let .network(error):
			return error.localizedDescription
		case let .error(reason):
			return reason
		}
	}
}

enum ResponseStatus {
	case informational
	case success
	case redirect
	case clientError
	case serverError
	case systemError
	case unauthorized
	
	// MARK: - Initialization
	
	init(statusCode: Int) {
		switch statusCode {
		case 100...199: self = .informational
		case 200...299: self = .success
		case 300...399: self = .redirect
		case 400...499:
			if statusCode == 401 {
				self = .unauthorized
			} else {
				self = .clientError
			}
		case 500...599: self = .serverError
		default: self = .systemError
		}
	}
}

/// The API protocol allows us to separate the task of constructing a URL,
/// its parameters, and HTTP method from the act of executing the URL request
/// and parsing the response.
protocol API {
	
	var scheme: HTTPScheme { get }
	var baseURL: String { get }
	var path: String { get }
	var parameters: [URLQueryItem] { get }
	var method: HTTPMethod { get }
	var headerTypes: [HTTPHeaderField: String] { get }
	var body: Data? { get }
	
}

struct DataResponse<T: Any> {
	
	// MARK: - Properties
	
	let request: URLRequest?
	let response: HTTPURLResponse?
	var result: Result<T, APIError>
	let data: Data?
	var value: T? {
		switch result {
		case .success(let value):
			return value
		case .failure:
			return nil
		}
	}
	var error: Error? {
		switch result {
		case .success:
			return nil
		case .failure(let error):
			return error
		}
	}
	var statusCode: Int? { response?.statusCode }
	
	// MARK: - Initialization
	
	init(request: URLRequest?, response: HTTPURLResponse?, result: Result<T, APIError>, data: Data?) {
		self.request = request
		self.response = response
		self.result = result
		self.data = data
	}
	
}

struct APILogger {
	
	// MARK: - Public API
	
	static func logDataResponse<T>(_ response: DataResponse<T>) {
		var console = ""
		
		if let url = response.request?.url?.absoluteString.removingPercentEncoding, let method = response.request?.httpMethod {
			var requestURL = url
			if requestURL.last == "?" {
				requestURL.removeLast()
			}
			console.append("\n🚀 \(method) \(requestURL)")
		}
		if let headers = response.request?.allHTTPHeaderFields, headers.count > 0 {
			//let headers = headers.map({ "\($0.key): \($0.value)" }).joined(separator: "\n   ")
			let headers = headers
				.map { item in
					if item.value.hasPrefix("Bearer") {
						return "\(item.key): \(item.value.prefix(15))..."
					}
					
					return "\(item.key): \(item.value)"
				}
				.joined(separator: "\n   ")
			console.append("\n🤯 \(headers)")
		}
		if let body = response.request?.httpBody, let body = String(data: body, encoding: String.Encoding.utf8), body.count > 0 {
			console.append("\n📤 \(body)")
		}
		if let response = response.response {
			switch response.statusCode {
			case 200 ..< 300:
				console.append("\n✅ \(response.statusCode)")
			default:
				console.append("\n❌ \(response.statusCode)")
			}
		}
		if let data = response.data, let payload = String(data: data, encoding: String.Encoding.utf8), payload.count > 0 {
			console.append("\n📦 \(payload)")
		}
		if let error = response.error as NSError? {
			console.append("\n‼️ [\(error.domain) \(error.code)] \(error.localizedDescription)")
		} else if let error = response.error {
			console.append("\n‼️ \(error.localizedDescription)")
		}
		
		Logger.log(message: console, type: .debug)
	}
	
}

extension OSLog {
	
	static let network: OSLog = {
		OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "network")
	}()
	
}

final class Reachability {
	
	// MARK: - Public API
	
	static func isConnectedToNetwork() -> Bool {
		var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
		zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
		zeroAddress.sin_family = sa_family_t(AF_INET)
		
		let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
			$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
				SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
			}
		}
		
		var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
		if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
			return false
		}
		
		let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
		let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
		
		return (isReachable && !needsConnection)
	}
	
}

extension Data {
	
	init?(multipartFilename filename: String, data fileData: Data, fileContentType: String, formData: [String: String] = [:], boundary: String) {
		self.init()
		
		var formFields = formData
		formFields["content-type"] = fileContentType
		formFields.forEach { key, value in
			append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
			append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
			append("\(value)".data(using: .utf8)!)
		}
		
		append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
		append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
		append("Content-Type: \(fileContentType)\r\n\r\n".data(using: .utf8)!)
		append(fileData)
		
		append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
	}
	
}
