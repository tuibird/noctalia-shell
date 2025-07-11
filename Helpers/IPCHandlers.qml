import Quickshell.Io

IpcHandler {
    property var appLauncherPanel

    target: "globalIPC"

    // Toggle Applauncher visibility
    function toggleLauncher(): void {
        if (!appLauncherPanel) {
            console.warn("AppLauncherIpcHandler: appLauncherPanel not set!");
            return;
        }
        if (appLauncherPanel.visible) {
            appLauncherPanel.hidePanel();
        } else {
            console.log("[IPC] Applauncher show() called");
            appLauncherPanel.showAt();
        }
    }
}
