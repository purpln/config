import Foundation

public class Config {
    var value: Any?
    
    init(value: Any?) { self.value = value }
    
    public static subscript(index: Config?) -> Config? { index }
    
    public subscript(index: Keys) -> Config { self[index.rawValue] }
    public subscript(index: String) -> Self {
        guard let values = value as? [String: Any], let value = values[index] else { return self }
        self.value = value
        return self
    }
    public subscript(index: Int) -> Self? {
        guard let values = value as? [Any], let value = values[safe: index] else { return nil }
        self.value = value
        return self
    }
}

// keys and return values
public extension Config {
    enum Keys: String {
        case `default`, version, mode, dictionary, none
        case url, int, bool, data, color, image, array, line
        case type, id, key, value, tag, count, state
        case types, values, tags, range, flow, lines, docs, files
        case description, page, link, list, api, map
        case json, xml, tsv, csv, mp4, png, gif, doc
        case selected, enabled, modified, updated, initialized
        case min, max, new, old, token, tokens, auth, support
        case location, time, date, device, search, model
        case unavailable, unknown, wait, warning, error, expiration
        case web, linux, android, windows, macos, ios, ipados
        case info, terms, about, `private`, personal, control
        case background, foreground, controller, router, view
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
