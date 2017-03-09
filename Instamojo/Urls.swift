//
//  Urls.swift
//  Instamojo
//
//  Created by Sukanya Raj on 06/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import Foundation

public class Urls {

    static var baseUrl = Constants.DEFAULT_BASE_URL

    /**
     * @return Order Create URL
     */
    public static func getOrderCreateUrl() -> String {
        return baseUrl + "v2/gateway/orders/"
    }

    /**
     * @return default redirect URL
     */
    public static func getDefaultRedirectUrl() -> String {
        return baseUrl + "integrations/android/redirect/"
    }

    /**
     * @return Order Fetch URL
     */
    public static func getOrderFetchURL(orderID: String) -> String {
        return baseUrl + "v2/gateway/orders/" + orderID + "/payment-options/"
    }

    /**
     * Set the base url
     *
     * @param baseUrl Base url for all network calls
     */
    public static func setBaseUrl(baseUrl: String) {
        let endPoint = formatUrl(url: baseUrl)

        if(endPoint.contains("test")) {
            Logger.logDebug(tag: "Urls", message : "Using a test base url. Use https://api.instamojo.com/ for production")
        }
        Urls.baseUrl = endPoint
        Logger.logDebug(tag: "Urls", message: "Base URL - " + Urls.baseUrl)
    }

    /**
     * @return baseUrl
     */
    public static func getBaseUrl() -> String {
        return baseUrl
    }

    /**
     * @return endUrlRegex
     */
    public static func getEndUrlRegex() -> [Any] {
        return [getDefaultRedirectUrl()+"/*"]
    }

    private static func formatUrl(url: String?) -> String {
        var endPoint: String = url!
        if (((url ?? "").isEmpty) || (url?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).isEmpty)!) {
            endPoint = Constants.DEFAULT_BASE_URL
        }

        if !(endPoint.hasSuffix("/")) {
            endPoint += "/"
        }

        return endPoint
    }
}
