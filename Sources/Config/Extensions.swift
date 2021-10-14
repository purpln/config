import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension URL {
    init?(string: String?) {
        guard let string = string else { return nil }
        self.init(string: string)
    }
}

extension String {
    var double: Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = "."
        if let result =  numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            numberFormatter.decimalSeparator = ","
            if let result = numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return nil
    }
    
    var int: Int? {
        if let double = double {
            return Int(double)
        } else { return nil }
    }
}
