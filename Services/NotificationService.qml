import QtQuick
import qs.Services
import Quickshell.Services.Notifications


QtObject {
    id: root
    
    // Notification server instance
    property NotificationServer server: NotificationServer {
        id: notificationServer
        
        // Server capabilities
        keepOnReload: false
        imageSupported: true
        actionsSupported: true
        actionIconsSupported: true
        bodyMarkupSupported: true
        bodySupported: true
        persistenceSupported: true
        inlineReplySupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        
        // Signal when notification is received
        onNotification: function(notification) {
            
            // Track the notification
            notification.tracked = true
            
            // Connect to closed signal for cleanup
            notification.closed.connect(function() {
                root.removeNotification(notification)
            })
            
            // Add to our model
            root.addNotification(notification)
        }
    }
    
    // List model to hold notifications
    property ListModel notificationModel: ListModel { }
    
    // Maximum visible notifications
    property int maxVisible: 5
    
    // Auto-hide timer
    property Timer hideTimer: Timer {
        interval: 5000 // 5 seconds
        repeat: true
        running: notificationModel.count > 0
        
        onTriggered: {
            if (notificationModel.count === 0) {
                return
            }
            
            // Always remove the oldest notification (last in the list)
            let oldestNotification = notificationModel.get(notificationModel.count - 1).rawNotification
            if (oldestNotification && !oldestNotification.transient) {
                // Trigger animation signal instead of direct dismiss
                animateAndRemove(oldestNotification, notificationModel.count - 1)
            }
        }
    }
    
    // Function to add notification to model
    function addNotification(notification) {
        notificationModel.insert(0, {
            rawNotification: notification,
            summary: notification.summary,
            body: notification.body,
            appName: notification.appName,
            urgency: notification.urgency,
            timestamp: new Date()
        })
        
        // Remove oldest notifications if we exceed maxVisible
        while (notificationModel.count > maxVisible) {
            let oldestNotification = notificationModel.get(notificationModel.count - 1).rawNotification
            if (oldestNotification) {
                oldestNotification.dismiss()
            }
            notificationModel.remove(notificationModel.count - 1)
        }
    }
    
    // Signal to trigger animation before removal
    signal animateAndRemove(var notification, int index)
    
    // Function to remove notification from model
    function removeNotification(notification) {
        for (let i = 0; i < notificationModel.count; i++) {
            if (notificationModel.get(i).rawNotification === notification) {
                // Emit signal to trigger animation first
                animateAndRemove(notification, i)
                break
            }
        }
    }
    
    // Function to actually remove notification after animation
    function forceRemoveNotification(notification) {
        for (let i = 0; i < notificationModel.count; i++) {
            if (notificationModel.get(i).rawNotification === notification) {
                notificationModel.remove(i)
                break
            }
        }
    }
    
    // Function to format timestamp
    function formatTimestamp(timestamp) {
        if (!timestamp) return ""
        
        const now = new Date()
        const diff = now - timestamp
        
        // Less than 1 minute
        if (diff < 60000) {
            return "now"
        }
        // Less than 1 hour
        else if (diff < 3600000) {
            const minutes = Math.floor(diff / 60000)
            return `${minutes}m ago`
        }
        // Less than 24 hours
        else if (diff < 86400000) {
            const hours = Math.floor(diff / 3600000)
            return `${hours}h ago`
        }
        // More than 24 hours
        else {
            const days = Math.floor(diff / 86400000)
            return `${days}d ago`
        }
    }
} 