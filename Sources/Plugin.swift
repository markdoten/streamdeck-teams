//
//  Plugin.swift
//  A plug-in for Stream Deck
//
//  Created by Jarno Le Conté on 19/10/2019.
//  Copyright © 2019 Jarno Le Conté. All rights reserved.
//

import Foundation

public class Plugin: NSObject, ESDEventsProtocol {
    var connectionManager: ESDConnectionManager?;
    var knownContexts: [Any] = [];
    
    func executeAppleScript(source: String) {
        var error: NSDictionary?
        let script = NSAppleScript(source: source);
        script?.executeAndReturnError(&error)
        if error != nil {
            NSLog("AppleScript ERROR");
        }
    }
    
    public func setConnectionManager(_ connectionManager: ESDConnectionManager) {
        self.connectionManager = connectionManager;
    }
    
    public func keyDown(forAction action: String, withContext context: Any, withPayload payload: [AnyHashable : Any], forDevice deviceID: String) {
        var keystroke = ""
        
        switch (action) {
        case "com.doten.teams.camera":
            keystroke = #"keystroke "o" using {shift down, command down}"#
            break;
        case "com.doten.teams.mute":
            keystroke = #"keystroke "m" using {shift down, command down}"#
            break;
        case "com.doten.teams.share":
            keystroke = #"keystroke "e" using {shift down, command down}"#
            break;
        default:
            break;
        }

        executeAppleScript(source: """
            set crntAppPath to (path to frontmost application as text)

            tell application "Microsoft Teams"
              activate
              tell application "System Events"
                \(keystroke)
              end tell
            end tell

            tell application crntAppPath
              activate
            end tell
        """)
    }
    
    public func keyUp(forAction action: String, withContext context: Any, withPayload payload: [AnyHashable : Any], forDevice deviceID: String) {
        // Nothing to do
    }
    
    public func willAppear(forAction action: String, withContext context: Any, withPayload payload: [AnyHashable : Any], forDevice deviceID: String) {
        // Add the context to the list of known contexts
        knownContexts.append(context)
    }
    
    public func willDisappear(forAction action: String, withContext context: Any, withPayload payload: [AnyHashable : Any], forDevice deviceID: String) {
        // Remove the context from the list of known contexts
        knownContexts.removeAll { isEqualContext($0, context) }
    }
    public func deviceDidConnect(_ deviceID: String, withDeviceInfo deviceInfo: [AnyHashable : Any]) {
        // Nothing to do
    }
    
    public func deviceDidDisconnect(_ deviceID: String) {
        // Nothing to do
    }
    
    public func applicationDidLaunch(_ applicationInfo: [AnyHashable : Any]) {
        // Nothing to do
    }
    
    public func applicationDidTerminate(_ applicationInfo: [AnyHashable : Any]) {
        // Nothing to do
    }
}

