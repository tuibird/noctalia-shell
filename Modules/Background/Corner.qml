import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import qs.Services

ShellRoot {
  id: root

  // Visible ring color
  property color ringColor: Colors.backgroundPrimary
  // The amount subtracted from full size for the inner cutout
  // Inner size = full size - borderWidth (per axis)
  property int borderWidth: Style.borderMedium
  // Rounded radius for the inner cutout
  property int innerRadius: 20

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property ShellScreen modelData

      anchors {
        top: true
        bottom: true
        left: true
        right: true
      }
      margins {
        top: Math.round(Style.barHeight * Scaling.scale(screen))
      }
      color: "transparent"
      screen: modelData
      WlrLayershell.exclusionMode: ExclusionMode.Ignore
      WlrLayershell.namespace: "quickshell-corner"
      // Do not take keyboard focus and make the surface click-through
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
      mask: Region {}

      // Source we want to show only as a ring
      Rectangle {
        id: overlaySource
        anchors.fill: parent
        color: root.ringColor
      }

      // Texture for overlaySource
      ShaderEffectSource {
        id: overlayTexture
        anchors.fill: parent
        sourceItem: overlaySource
        hideSource: true
        live: true
        visible: false
      }

      // Mask via Canvas: paint opaque white, then punch rounded inner hole
      Canvas {
        id: maskSource
        anchors.fill: parent
        antialiasing: true
        renderTarget: Canvas.FramebufferObject
        onPaint: function() {
          const ctx = getContext("2d");
          ctx.reset();
          ctx.clearRect(0, 0, width, height);
          // Solid white base (alpha=1)
          ctx.globalCompositeOperation = "source-over";
          ctx.fillStyle = "#ffffffff";
          ctx.fillRect(0, 0, width, height);

          // Punch hole using destination-out with rounded rect path
          const x = Math.round(root.borderWidth / 2);
          const y = Math.round(root.borderWidth / 2);
          const w = Math.max(0, width - root.borderWidth);
          const h = Math.max(0, height - root.borderWidth);
          const r = Math.max(0, Math.min(root.innerRadius, Math.min(w, h) / 2));

          ctx.globalCompositeOperation = "destination-out";
          ctx.fillStyle = "#ffffffff";
          ctx.beginPath();
          // rounded rectangle path using arcTo
          ctx.moveTo(x + r, y);
          ctx.lineTo(x + w - r, y);
          ctx.arcTo(x + w, y, x + w, y + r, r);
          ctx.lineTo(x + w, y + h - r);
          ctx.arcTo(x + w, y + h, x + w - r, y + h, r);
          ctx.lineTo(x + r, y + h);
          ctx.arcTo(x, y + h, x, y + h - r, r);
          ctx.lineTo(x, y + r);
          ctx.arcTo(x, y, x + r, y, r);
          ctx.closePath();
          ctx.fill();
        }
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
      }

      // Repaint mask when properties change
      Connections {
        target: root
        function onBorderWidthChanged() { maskSource.requestPaint() }
        function onRingColorChanged() { /* no-op for mask */ }
        function onInnerRadiusChanged() { maskSource.requestPaint() }
      }

      // Texture for maskSource; hides the original
      ShaderEffectSource {
        id: maskTexture
        anchors.fill: parent
        sourceItem: maskSource
        hideSource: true
        live: true
        visible: false
      }

      // Apply mask to show only the ring area
      MultiEffect {
        anchors.fill: parent
        source: overlayTexture
        maskEnabled: true
        maskSource: maskTexture
        maskInverted: false
      }
    }
  }
}

