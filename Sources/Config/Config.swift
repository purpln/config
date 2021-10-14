import Foundation

public class Config {
    var value: Any? = nil
    
    init(_ key: String, dictionary: [String: Any]? = nil) {
        if let value = dictionary?[key] {
            self.value = value
        }
    }
    
    init(value: Any?) {
        self.value = value
    }
    
    init(key: String) {
        if let values = value as? [String: Any] {
            self.value = values[key]
        }
    }
    
    public static subscript(index: Config?) -> Config? { index }
    
    public subscript(index: Keys) -> Config { self[index.rawValue] }
    public subscript(index: String) -> Config {
        guard let value = value as? [String: Any] else { return Config(value: nil) }
        return Config(index, dictionary: value)
    }
    public subscript(index: Int) -> Config? {
        guard let values = value as? [Any] else { return nil }
        return Config(value: values[safe: index])
    }
}

// keys and return values
public extension Config {
    enum Keys: String {
        case `default`, version, mode, dictionary
        case url, int, bool, data, color, image, array
        case selected, enabled, modified
        case type, id, key, value, tag, info, count
        case types, values, tags, range, flow, line, page
        case min, max, new, old
        case description
    }
    
    var array: [Any]? { value as? [Any] }
    var bool: Bool? { value as? Bool }
    var string: String? {
        if let value = value as? String { return value }
        if let value = value as? Int { return String(value) }
        if let value = value as? Double { return String(value) }
        return nil
    }
    var int: Int? {
        if let value = value as? Int { return value }
        if let value = value as? Double { return String(value).int }
        if let value = value as? String { return value.int }
        return nil
    }
    var double: Double? {
        if let value = value as? Double { return value }
        if let value = value as? Int { return String(value).double }
        if let value = value as? String { return value.double }
        return nil
    }
    var url: URL? { URL(string: string) }
}

// static methods
public extension Config {
    static var dictionary: [String: Any] {
        guard let path = Bundle.main.path(forResource: "config", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return [:] }
        return json
    }
    
    static subscript(index: Keys) -> Config { self[index.rawValue] }
    static subscript(index: String) -> Config { Config(value: dictionary)[index] }
    static subscript(index: URL?) -> Config? { Config(url: index) }
    
    convenience init?(url: URL?) {
        guard let url = url, let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }
        self.init(value: json)
    }
}
