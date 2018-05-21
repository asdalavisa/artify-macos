//
//  NetworkService.swift
//  artify-core
//
//  Created by Nghia Tran on 5/20/18.
//  Copyright © 2018 com.art.artify.core. All rights reserved.
//

import Foundation
import Moya

protocol NetworkingServiceType {

    var provider: MoyaProvider<ArtifyCoreAPI> { get }
}

final class NetworkingService: NetworkingServiceType {

    // MARK: - Variable
    private let environment: Environment
    private let plugins: [PluginType] = [NetworkLoggerPlugin(verbose: true,
                                                             responseDataFormatter: NetworkingService.JSONResponseDataFormatter)]
    let provider: MoyaProvider<ArtifyCoreAPI>

    // MARK: - Init
    init(environment: Environment) {
        self.environment = environment
        self.provider = MoyaProvider<ArtifyCoreAPI>(plugins: plugins)
    }
}

// MARK: - Private
extension NetworkingService {

    fileprivate class func JSONResponseDataFormatter(_ data: Data) -> Data {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return prettyData
        } catch {
            return data // fallback to original data if it can't be serialized.
        }
    }
}