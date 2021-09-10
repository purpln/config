import Foundation

public class Config {
    var value: Any? = nil
    
    init(_ key: String, dictionary: [String: Any]? = nil) {
        if let value = dictionary?[key] {
            self.value = value
        } else {
            value = Self.get(key)
        }
    }
    
    public init?(url: URL?) {
        guard let url = url, let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }
        value = json
    }
    
    public static subscript(file: Config?) -> Config? { file }
    
    public static subscript(index: Keys) -> Config { self[index.rawValue] }
    public static subscript(index: String) -> Config { Config(index) }
    
    public subscript(index: Keys) -> Config { self[index.rawValue] }
    public subscript(index: String) -> Config {
        if let value = value as? [String: Any] {
            return Config(index, dictionary: value)
        } else {
            return Config(index)
        }
    }
}

public extension Config {
    enum Keys: String {
        case url, int, bool, type, flow, version, value, values, data
    }
    
    var bool: Bool? { value as? Bool }
    var string: String? { value as? String }
    var int: Int? { value as? Int }
    var double: Double? { value as? Double }
    var url: URL? { URL(string: string) }
    
    static var dictionary: [String: Any] {
        guard let path = Bundle.main.path(forResource: "config", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return [:] }
        return json
    }
    
    static func get(_ key: String) -> Any {
        dictionary[key] ?? ""
    }
}

private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

private extension URL {
    init?(string: String?) {
        guard let string = string else { return nil }
        self.init(string: string)
    }
}
