//////////////////////////////////////////////////////////////////////////////////////////////////
//
//  SOCKSProxy.swift
//  Starscream
//
//  Custom SOCKS proxy configuration for WebSocket connections.
//
//////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation

/// Configuration for SOCKS proxy
public struct SOCKSProxyConfig {
    public let host: String
    public let port: Int
    public let user: String?
    public let password: String?

    public init(host: String, port: Int, user: String? = nil, password: String? = nil) {
        self.host = host
        self.port = port
        self.user = user
        self.password = password
    }

    /// Creates a stream configuration callback that sets up SOCKS proxy on the streams
    public func streamConfiguration() -> ((InputStream, OutputStream) -> Void) {
        return { [host, port, user, password] inStream, outStream in
            var proxyConfig: [String: Any] = [
                kCFStreamPropertySOCKSProxyHost as String: host,
                kCFStreamPropertySOCKSProxyPort as String: port
            ]

            if let user, let password {
                proxyConfig[kCFStreamPropertySOCKSUser as String] = user
                proxyConfig[kCFStreamPropertySOCKSPassword as String] = password
            }

            let propertyKey = CFStreamPropertyKey(rawValue: kCFStreamPropertySOCKSProxy)
            let cfProxyConfig = proxyConfig as CFDictionary

            CFReadStreamSetProperty(inStream, propertyKey, cfProxyConfig)
            CFWriteStreamSetProperty(outStream, propertyKey, cfProxyConfig)
        }
    }
}
