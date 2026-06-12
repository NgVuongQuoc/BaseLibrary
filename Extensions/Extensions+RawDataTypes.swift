//
//  Extensions+RawDataTypes.swift
//  InternalSports
//
//  Created by Nguyen Vuong Quoc on 12/6/26.
//

import Foundation
import UIKit
import CryptoKit
import CommonCrypto

public extension Double {
    public var isZero: Bool {
        return self == 0
    }
}

public extension Int {
    public var isZero: Bool {
        return self == 0
    }
    
    public var toString: String {
        return "\(self)"
    }
    
    public func formatUsingAbbrevation () -> String {
        let numFormatter = NumberFormatter()
        
        typealias Abbrevation = (threshold: Double, divisor: Double, suffix: String)
        let abbreviations: [Abbrevation] = [(0, 1, ""),
                                            (1000.0, 1000.0, "K"),
                                            (100_000.0, 1_000_000.0, "M"),
                                            (100_000_000.0, 1_000_000_000.0, "B")]
        // you can add more !
        
        let startValue = Double (abs(self))
        let abbreviation:Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if (startValue < tmpAbbreviation.threshold) {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        } ()
        
        let value = Double(self) / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1
        
        return numFormatter.string(from: NSNumber (value:value))!
    }

}

public extension String {
    
    static func format(decimal: Float, _ maximumDigits: Int = 1, _ minimumDigits: Int = 1) -> String? {
        let number = NSNumber(value: decimal)
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = maximumDigits
        numberFormatter.minimumFractionDigits = minimumDigits
        return numberFormatter.string(from: number)
    }
    
    func MD5() -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        
        if let data = data(using: .utf8) {
            _ = data.withUnsafeBytes { body in
                CC_MD5(body.baseAddress, CC_LONG(data.count), &digest)
            }
        }
        
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
    
    var isEmail: Bool {
        let emailRegEx = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@" + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    var isOnlyLetters: Bool {
        validate(withRegex: "[a-zA-Z_]+")
    }
    
    var isAlphanumeric: Bool {
        validate(withRegex: "[a-zA-Z0-9_]+")
    }
    
    var isNumeric: Bool {
        validate(withRegex: "^(?:[0-9])+$")
    }
    
    func validate(withRegex regexString: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regexString)
            let result = regex.firstMatch(
                in: self,
                options: NSRegularExpression.MatchingOptions(rawValue: 0),
                range: NSRange(location: 0, length: count)
            ) != nil
            return result
        } catch {
            return false
        }
    }
    
    var isWhiteSpaceOrEmpty: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func trimming() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isPngFile: Bool {
        contains(".png")
    }
    
    var toInt: Int {
        Int(self) ?? 0
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )
        return ceil(boundingBox.width)
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes).width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes).height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    func convertStringToDate(string: String) -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        return dateFormat.date(from: string) ?? Date()
    }
    
    func convertString(string: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        if dateFormat.date(from: string) != nil {
            return string
        }
        return "Change date"
    }
    
    func getImage(completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: self) else { return }
        getData(from: url) { data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else { return }
            completion(image)
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func convertBase64StringToImage() -> UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .init(rawValue: 0)) else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
    func convertBase64StringToImage(completion: @escaping (UIImage?) -> Void) {
        completion(convertBase64StringToImage())
    }
}

public extension URL {
    func convertToRedirectURL(scheme: String) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        let schemeCopy = components?.scheme ?? ""
        components?.scheme = schemeCopy + scheme
        return components?.url
    }
    
    func convertFromRedirectURL(prefix: String) -> URL? {
        guard var comps = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return nil }
        guard let scheme = comps.scheme else { return nil }
        comps.scheme = scheme.replacingOccurrences(of: prefix, with: "")
        return comps.url
    }
}
