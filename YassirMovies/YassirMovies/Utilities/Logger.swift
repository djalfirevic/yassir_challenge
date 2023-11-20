//
//  Logger.swift
//  YassirMovies
//
//  Created by Djuro on 11/20/23.
//

import Foundation

enum LogType: String {
	case error = "🛑"
	case info = "ℹ️"
	case debug = "💬"
	case warning = "⚠️"
	case fatal = "🔥"
	case success = "✅"
	case local = "👨‍💻"
}

final class Logger {
	
	// MARK: - Properties
	
	static var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "MM-dd-yyyy"
		formatter.locale = .current
		formatter.timeZone = .current
		
		return formatter
	}
	
	// MARK: - Public API
	
	static func log(message: String,
					type: LogType,
					fileName: String = #file,
					line: Int = #line,
					column: Int = #column,
					function: String = #function) {

#if DEBUG
		print("\(type.rawValue) -> \(message)")
#endif
	}
	
	static func log<T: Codable>(_ object: T) {
		if let data = try? JSONEncoder().encode(object) {
			let json = String(data: data, encoding: .utf8)
#if DEBUG
			print("JSON: \(json ?? "")")
#endif
		}
	}
	
	// MARK: - Private API
	
	private class func sourceFileName(filePath: String) -> String {
		let components = filePath.components(separatedBy: "/")
		return components.isEmpty ? "" : components.last!
	}
	
}
