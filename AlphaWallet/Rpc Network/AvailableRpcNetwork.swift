//
//  AvailableRpcNetwork.swift
//  AlphaWallet
//
//  Created by Jerome Chan on 20/12/21.
//

import Foundation

@available(iOS 13.0, *)
fileprivate let selectedCompressionAlgorithm = NSData.CompressionAlgorithm.lzma
fileprivate let chainsZipFileUrl = R.file.chainsZip()
fileprivate var networkCache: [CustomRPC]?

struct RpcNetwork: Codable {

    let chainId: Int
    let faucets: [String]
    let infoURL: String
    let name: String
    let nativeCurrency: NativeCurrency
    let network: String?
    let networkId: Int
    let rpc: [String]
    let shortName: String

    var isTestNet: Bool {
        if let network = network?.lowercased() {
            if network == "mainnet" {
                return false
            }
            if network == "testnet" {
                return true
            }
            if network == "test" {
                return true
            }
        }
        return name.lowercased().contains("testnet")
    }
    
    var customRpc: CustomRPC {
        CustomRPC(chainID: chainId, nativeCryptoTokenName: nativeCurrency.name, chainName: name, symbol: nativeCurrency.symbol, rpcEndpoint: rpc.first ?? "", explorerEndpoint: infoURL, etherscanCompatibleType: .unknown, isTestnet: isTestNet)
    }

    struct functional {

        static func availableServersFromCompressedJSONFile(filePathUrl: URL? = chainsZipFileUrl) -> [CustomRPC]? {
            if let availableRpc = networkCache {
                return availableRpc
            }
            networkCache = readFromCompressedFile(filePathUrl: filePathUrl)
            return networkCache
        }

    }

}

struct NativeCurrency: Codable {

    let name: String
    let symbol: String
    let decimals: Int

}

fileprivate func readFromCompressedFile(filePathUrl: URL?) -> [CustomRPC]? {
    guard let filePathUrl = filePathUrl, let rawData = readFileIntoMemory(url: filePathUrl), let uncompressedData = uncompressData(data: rawData), let unfilteredChainArray = decodeDataToChainEntryArray(data: uncompressedData), let chainList = filterChainAndConvertToCustomRPC(chains: unfilteredChainArray) else {
        return nil
    }
    return chainList
}

fileprivate func readFileIntoMemory(url: URL) -> Data? {
    guard let encodedFileHandle = try? FileHandle(forReadingFrom: url) else {
        return nil
    }
    return encodedFileHandle.readDataToEndOfFile()
}

fileprivate func uncompressData(data: Data) -> Data? {
    do {
        let uncompressedData = try (data as NSData).decompressed(using: selectedCompressionAlgorithm)
        return uncompressedData as Data
    } catch {
        return nil
    }
}

fileprivate func decodeDataToChainEntryArray(data: Data) -> [RpcNetwork]? {
    do {
        let decoder = JSONDecoder()
        let entries: [RpcNetwork] = try decoder.decode([RpcNetwork].self, from: data)
        return entries
    } catch {
        return nil
    }
}

fileprivate func filterChainAndConvertToCustomRPC(chains: [RpcNetwork]) -> [CustomRPC]? {
    let viewModel = SaveCustomRpcManualEntryViewModel(operation: .add)
    let filteredChain = chains.compactMap { entry -> CustomRPC? in
        switch viewModel.validate(entry: entry) {
        case .success:
            return entry.customRpc
        case .failure:
            return nil
        }
    }
    return filteredChain
}

extension SaveCustomRpcManualEntryViewModel {

    func validate(customRpc: CustomRPC) -> Result<CustomRPC, SaveCustomRpcErrors> {
        return validate(chainName: customRpc.chainName, rpcEndpoint: customRpc.rpcEndpoint, chainID: String(customRpc.chainID), symbol: customRpc.symbol ?? "", explorerEndpoint: customRpc.explorerEndpoint ?? "", isTestNet: customRpc.isTestnet)
    }

    func validate(entry: RpcNetwork) -> Result<CustomRPC, SaveCustomRpcErrors> {
        return validate(chainName: entry.name, rpcEndpoint: entry.rpc.first ?? "", chainID: String(entry.chainId), symbol: entry.nativeCurrency.symbol, explorerEndpoint: entry.infoURL, isTestNet: entry.isTestNet)
    }

}

// The following function is used to compress the chains.json file.

@available(iOS 13.0, *)
fileprivate func compressChainFile(inputFileName: String, outputFileName: String) throws {
    let inputFileHandle = FileHandle(forReadingAtPath: inputFileName)!
    let inputData = inputFileHandle.readDataToEndOfFile() as NSData
    let outputData = try inputData.compressed(using: selectedCompressionAlgorithm) as Data
    FileManager.default.createFile(atPath: outputFileName, contents: outputData, attributes: nil)
    try inputFileHandle.close()
}
