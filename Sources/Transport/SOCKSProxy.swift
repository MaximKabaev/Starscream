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

    public init(host: String, port: Int) {
        self.host = host
        self.port = port
    }

    /// Creates a stream configuration callback that sets up SOCKS proxy on the streams
    public func streamConfiguration() -> ((InputStream, OutputStream) -> Void) {
        return { [host, port] inStream, outStream in
            let proxyConfig: [String: Any] = [
                kCFStreamPropertySOCKSProxyHost as String: host,
                kCFStreamPropertySOCKSProxyPort as String: port
            ]

            let propertyKey = CFStreamPropertyKey(rawValue: kCFStreamPropertySOCKSProxy)
            let cfProxyConfig = proxyConfig as CFDictionary

            CFReadStreamSetProperty(inStream, propertyKey, cfProxyConfig)
            CFWriteStreamSetProperty(outStream, propertyKey, cfProxyConfig)
        }
    }
}
