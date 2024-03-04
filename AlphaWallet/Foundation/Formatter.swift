//
//  Formatters.swift
//  AlphaWallet
//
//  Created by Jerome Chan on 17/1/22.
//

import Foundation

struct Formatter {

    static let currency: NumberFormatter = {
        let formatter = basicCurrencyFormatter()
        formatter.minimumFractionDigits = Constants.formatterFractionDigits
        formatter.maximumFractionDigits = Constants.formatterFractionDigits
        formatter.currencySymbol = "$"
        return formatter
    }()

    static let usd: NumberFormatter = {
        let formatter = basicCurrencyFormatter()
        formatter.positiveFormat = ",###.# " + Constants.Currency.usd
        formatter.negativeFormat = "-,###.# " + Constants.Currency.usd
        formatter.minimumFractionDigits = Constants.formatterFractionDigits
        formatter.maximumFractionDigits = Constants.formatterFractionDigits
        return formatter
    }()

    static let percent: NumberFormatter = {
        let formatter = basicCurrencyFormatter()
        formatter.positiveFormat = ",###.#"
        formatter.negativeFormat = "-,###.#"
        formatter.minimumFractionDigits = Constants.formatterFractionDigits
        formatter.maximumFractionDigits = Constants.formatterFractionDigits
        formatter.numberStyle = .percent
        return formatter
    }()

    static let shortCrypto: NumberFormatter = {
        let formatter = basicCurrencyFormatter()
        formatter.positiveFormat = ",###.#"
        formatter.negativeFormat = "-,###.#"
        formatter.minimumFractionDigits = Constants.etherFormatterFractionDigits
        formatter.maximumFractionDigits = Constants.etherFormatterFractionDigits
        formatter.numberStyle = .none
        return formatter
    }()

    static func shortCrypto(symbol: String) -> NumberFormatter {
        let formatter = basicCurrencyFormatter()
        formatter.positiveFormat = ",###.#" + " " + symbol
        formatter.negativeFormat = "-,###.#" + " " + symbol
        formatter.minimumFractionDigits = Constants.etherFormatterFractionDigits
        formatter.maximumFractionDigits = Constants.etherFormatterFractionDigits
        formatter.numberStyle = .none
        return formatter
    }

    static let priceChange: NumberFormatter = {
        let formatter = basicCurrencyFormatter()
        formatter.positiveFormat = "+$,###.#"
        formatter.negativeFormat = "-$,###.#"
        formatter.minimumFractionDigits = Constants.formatterFractionDigits
        formatter.maximumFractionDigits = Constants.formatterFractionDigits
        return formatter
    }()

    static let fiat: NumberFormatter = {
        let formatter = basicCurrencyFormatter()
        formatter.positiveFormat = "$,###.#"
        formatter.negativeFormat = "-$,###.#"
        formatter.minimumFractionDigits = Constants.formatterFractionDigits
        formatter.maximumFractionDigits = Constants.formatterFractionDigits
        return formatter
    }()

    static let `default`: NumberFormatter = {
        let formatter = NumberFormatter()
        return formatter
    }()

    static let scientificAmount: NumberFormatter = {
        let formatter = Formatter.default
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()

    static let currencyAccounting: NumberFormatter = {
        let formatter = basicCurrencyFormatter()
        formatter.currencySymbol = ""
        formatter.minimumFractionDigits = Constants.formatterFractionDigits
        formatter.maximumFractionDigits = Constants.formatterFractionDigits
        formatter.numberStyle = .currencyAccounting
        formatter.isLenient = true
        return formatter
    }()

    static let alternateAmount: NumberFormatter = {
        let formatter = basicCurrencyFormatter()
        formatter.currencySymbol = ""
        formatter.minimumFractionDigits = Constants.etherFormatterFractionDigits
        formatter.maximumFractionDigits = Constants.etherFormatterFractionDigits
        return formatter
    }()
}

fileprivate func basicCurrencyFormatter() -> NumberFormatter {
    let formatter = basicNumberFormatter()
    formatter.numberStyle = .currency
    formatter.roundingMode = .down
    return formatter
}

fileprivate func basicNumberFormatter() -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "en_US")
    formatter.generatesDecimalNumbers = true
    formatter.alwaysShowsDecimalSeparator = true
    formatter.usesGroupingSeparator = true
    formatter.isLenient = false
    formatter.isPartialStringValidationEnabled = false
    formatter.groupingSeparator = ","
    formatter.decimalSeparator = "."
    return formatter
}

extension NumberFormatter {

    func string(from source: Double) -> String? {
        return self.string(from: source as NSNumber)
    }

}
