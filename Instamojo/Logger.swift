//
//  Logger.swift
//  Instamojo
//
//  Created by Sukanya Raj on 06/02/17.
//  Copyright © 2017 Sukanya Raj. All rights reserved.
//

import Foundation

public class Logger {
    static var enableLog = true

    /**
     * Logs all the errors
     *
     * @param tag     SimpleTag
     * @param message Error message
     */
    public static func logError(tag: String, message: String) {
        print("Instamojo:" + tag + ":" + message)
    }

    /**
     * Logs debug messages if log level is <= Log.DEBUG
     *
     * @param tag     SimpleTag
     * @param message Error Message
     */
    public static func logDebug(tag: String, message: String) {
        if (enableLog) {
            print("Instamojo:" + tag + ":" + message)
        }
    }

    public static func setLogLevel(level: Bool) {
        Logger.enableLog = level
    }

}
