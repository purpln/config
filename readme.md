# config

## example

extension Config {
    static var `default`: Config? {
        guard let path = Bundle.main.path(forResource: "config", ofType: "json") else { return nil }
        return Config(url: URL(fileURLWithPath: path))
    }
}
guard let config = config[.default] else { return }
print(config["values"][.value][.bool].bool,
      config[.values][.value]["value"].double,
      config[.values]["url"].url)
