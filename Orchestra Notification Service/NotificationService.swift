//
//  NotificationService.swift
//  Orchestra Notification Service
//
//  Created by Mukesh Shakya on 25/08/2022.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler : ((UNNotificationContent) -> Void)?
    var content        : UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest,
                             withContentHandler contentHandler:
        @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        self.content        = (request.content.mutableCopy()
            as? UNMutableNotificationContent)
        if self.content != nil {
            func save(_ identifier: String,
                      data: Data, options: [AnyHashable: Any]?)
                -> UNNotificationAttachment? {
                    let directory = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString,
                                                                                                        isDirectory: true)
                    do {
                        try FileManager.default.createDirectory(at: directory,
                                                                withIntermediateDirectories: true,
                                                                attributes: nil)
                        let fileURL = directory.appendingPathComponent(identifier)
                        try data.write(to: fileURL, options: [])
                        return try UNNotificationAttachment.init(identifier: identifier,
                                                                 url: fileURL,
                                                                 options: options)
                    } catch {}
                    return nil
            }
            func exitGracefully(_ reason: String = "") {
                let bca    = request.content.mutableCopy()
                    as? UNMutableNotificationContent
                bca!.title = reason
                contentHandler(bca!)
            }
            DispatchQueue.main.async {
                guard let content = (request.content.mutableCopy() as? UNMutableNotificationContent) else {
                    return exitGracefully()
                }
                let userInfo: [AnyHashable: Any] = request.content.userInfo
                guard let fcmOptions = userInfo["fcm_options"] as? [String: Any] else {
                    return exitGracefully()
                }
                guard let attachmentURL = fcmOptions["image"] as? String else {
                    return exitGracefully()
                }
                guard let imageData = try? Data(contentsOf: URL(string: attachmentURL)!) else {
                    return exitGracefully()
                }
                guard let attachment = save("image.png", data: imageData, options: nil) else {
                    return exitGracefully()
                }
                content.attachments = [attachment]
                contentHandler(content)
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bca =  self.content {
            contentHandler(bca)
        }
    }
    
}
