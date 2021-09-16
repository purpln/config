```swift
typealias config = Config

{
    "values": {
        "value": {
            "bool": true,
            "value": 220
        },
        "url":"https://google.com"
    }
}

extension Config {
    static var `default`: Config? {
        guard let path = Bundle.main.path(forResource: "config", ofType: "json") else { return nil }
        return Config(url: URL(fileURLWithPath: path))
    }
}

guard let config = config[.default] else { return }

config["values"][.value][.bool].bool     //true
config[.values][.value]["value"].double  //220.0
config[.values]["url"].url               //https://google.com
```
