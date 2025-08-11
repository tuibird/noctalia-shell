import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import qs.Services
import qs.Widgets

Item {
  id: root
  property real scaling: 1
  readonly property string tabIcon: "info"
  readonly property string tabLabel: "About"
  readonly property int tabIndex: 8
  anchors.fill: parent

  property string latestVersion: "Unknown"
  property string currentVersion: "Unknown"
  property var contributors: []
  property string githubDataPath: Settings.configDir + "github_data.json"

  function loadFromFile() {
    const now = Date.now()
    const data = githubData
    if (!data.timestamp || (now - data.timestamp > 3600 * 1000)) { // 1h cache
      fetchFromGitHub()
      return
    }
    if (data.version) root.latestVersion = data.version
    if (data.contributors) root.contributors = data.contributors
  }

  function fetchFromGitHub() {
    versionProcess.running = true
    contributorsProcess.running = true
  }

  function saveData() {
    githubData.timestamp = Date.now()
    Qt.callLater(function () { githubDataFile.writeAdapter() })
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: Style.marginLarge * scaling
    spacing: Style.marginMedium * scaling

    // Header
    NText { text: "Noctalia: quiet by design"; font.weight: Style.fontWeightBold; color: Colors.textPrimary }
    NText { text: "It may just be another quickshell setup but it won't get in your way."; color: Colors.textSecondary }

    // Versions grid
    RowLayout {
      spacing: Style.marginLarge * scaling
      ColumnLayout { NText { text: "Latest Version:"; color: Colors.textSecondary }; NText { text: root.latestVersion; font.weight: Style.fontWeightBold; color: Colors.textPrimary } }
      ColumnLayout { NText { text: "Installed Version:"; color: Colors.textSecondary }; NText { text: root.currentVersion; font.weight: Style.fontWeightBold; color: Colors.textPrimary } }
      Item { Layout.fillWidth: true }
      NIconButton {
        icon: "system_update"
        tooltipText: "Open latest release"
        onClicked: Quickshell.execDetached(["xdg-open", "https://github.com/Ly-sec/Noctalia/releases/latest"]) }
    }

    NDivider { Layout.fillWidth: true }

    // Contributors
    RowLayout { spacing: Style.marginSmall * scaling
      NText { text: "Contributors"; font.weight: Style.fontWeightBold; color: Colors.textPrimary }
      NText { text: "(" + root.contributors.length + ")"; color: Colors.textSecondary }
    }

    GridView {
      id: contributorsGrid
      Layout.fillWidth: true
      Layout.fillHeight: true
      cellWidth: 200 * scaling
      cellHeight: 100 * scaling
      model: root.contributors
      delegate: Rectangle {
        width: contributorsGrid.cellWidth - 8 * scaling
        height: contributorsGrid.cellHeight - 4 * scaling
        radius: Style.radiusLarge * scaling
        color: contributorArea.containsMouse ? Colors.highlight : "transparent"
        RowLayout {
          anchors.fill: parent
          anchors.margins: Style.marginSmall * scaling
          spacing: Style.marginSmall * scaling
          Item {
            Layout.preferredWidth: 40 * scaling
            Layout.preferredHeight: 40 * scaling
            Image { id: avatarImage; anchors.fill: parent; source: modelData.avatar_url || ""; asynchronous: true; visible: false; fillMode: Image.PreserveAspectCrop }
            MultiEffect { anchors.fill: parent; source: avatarImage; maskEnabled: true; maskSource: mask }
            Item { id: mask; anchors.fill: parent; visible: false; Rectangle { anchors.fill: parent; radius: width / 2 } }
            NText { anchors.centerIn: parent; text: "person"; font.family: "Material Symbols Outlined"; color: contributorArea.containsMouse ? Colors.backgroundPrimary : Colors.textPrimary; visible: !avatarImage.source || avatarImage.status !== Image.Ready }
          }
          ColumnLayout { Layout.fillWidth: true; spacing: 2 * scaling
            NText { text: modelData.login || "Unknown"; color: contributorArea.containsMouse ? Colors.backgroundPrimary : Colors.textPrimary }
            NText { text: (modelData.contributions || 0) + " commits"; color: contributorArea.containsMouse ? Colors.backgroundPrimary : Colors.textSecondary }
          }
        }
        MouseArea { id: contributorArea; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: if (modelData.html_url) Quickshell.execDetached(["xdg-open", modelData.html_url]) }
      }
    }

    Item { Layout.fillHeight: true }
  }

  // Processes and persistence
  Process {
    id: currentVersionProcess
    command: ["sh", "-c", "cd " + Quickshell.shellDir + " && git describe --tags --abbrev=0 2>/dev/null || echo 'Unknown'"]
    Component.onCompleted: running = true
    stdout: StdioCollector {
      onStreamFinished: {
        const version = text.trim()
        if (version && version !== "Unknown") {
          root.currentVersion = version
        } else {
          currentVersionProcess.command = ["sh", "-c", "cd " + Quickshell.shellDir + " && cat package.json 2>/dev/null | grep '\"version\"' | cut -d'\"' -f4 || echo 'Unknown'"]
          currentVersionProcess.running = true
        }
      }
    }
  }

  FileView {
    id: githubDataFile
    path: root.githubDataPath
    blockLoading: true
    printErrors: true
    watchChanges: true
    onFileChanged: githubDataFile.reload()
    onLoaded: loadFromFile()
    onLoadFailed: {
      githubData.version = "Unknown"; githubData.contributors = []; githubData.timestamp = 0; githubDataFile.writeAdapter(); fetchFromGitHub()
    }
    Component.onCompleted: { if (path) reload() }
    JsonAdapter { id: githubData; property string version: "Unknown"; property var contributors: []; property double timestamp: 0 }
  }

  Process {
    id: versionProcess
    command: ["curl", "-s", "https://api.github.com/repos/Ly-sec/Noctalia/releases/latest"]
    stdout: StdioCollector {
      onStreamFinished: {
        try {
          const data = JSON.parse(text)
          if (data.tag_name) { const version = data.tag_name; githubData.version = version; root.latestVersion = version }
          saveData()
        } catch (e) { console.error("Failed to parse version:", e) }
      }
    }
  }

  Process {
    id: contributorsProcess
    command: ["curl", "-s", "https://api.github.com/repos/Ly-sec/Noctalia/contributors?per_page=100"]
    stdout: StdioCollector {
      onStreamFinished: {
        try {
          const data = JSON.parse(text)
          githubData.contributors = data || []
          root.contributors = githubData.contributors
          saveData()
        } catch (e) { console.error("Failed to parse contributors:", e); root.contributors = [] }
      }
    }
  }
}
