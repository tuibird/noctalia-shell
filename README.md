# Noctalia

**_quiet by design_**

A sleek, minimal, and thoughtfully crafted setup for Wayland using **Quickshell**. This setup includes a status bar, notification system, control panel, wifi & bluetooth indicators, power profiles, lockscreen, tray, workspaces, and more — all styled with a warm lavender palette.

## Preview

<details>
<summary>Click to expand preview images</summary>

![Main](https://i.imgur.com/5mOIGD2.jpeg)  
</br>

![Control Panel](https://i.imgur.com/fJmCV6m.jpeg)  
</br>

![Applauncher](https://i.imgur.com/9OPV30q.jpeg)

</details>
<br>

---

> ⚠️ **Note:**  
> This setup currently requires **Niri** as your compositor, mainly due to its custom workspace indicator integration. However if you want, you can just adapt the Workspace.qml to your own compositor.

---

## Features

- **Status Bar:** Modular and informative with smooth animations.
- **Notifications:** Non-intrusive alerts styled to blend naturally.
- **Control Panel:** Centralized system controls for quick adjustments.
- **Connectivity:** Easy management of WiFi and Bluetooth devices.
- **Power Profiles:** Quick toggles for performance and battery modes.
- **Lockscreen:** Secure and visually consistent lock experience.
- **Tray & Workspaces:** Efficient workspace switching and tray icons.
- **Applauncher:** Stylized Applauncher to fit into the setup.

---

<details>
<summary><strong>Theme Colors</strong></summary>

| Color Role                                                                                                                 | Color       | Description                                       |
| -------------------------------------------------------------------------------------------------------------------------- | ----------- | ------------------------------------------------- |
| <span style="display:inline-block;width:15px;height:15px;border-radius:50%;background:#0C0D11;margin-right:8px;"></span>   | `#0C0D11`   | Background Primary — Deep indigo-black            |
| <span style="display:inline-block;width:15px;height:15px;border-radius:50%;background:#151720;margin-right:8px;"></span>   | `#151720`   | Background Secondary — Slightly lifted dark       |
| <span style="display:inline-block;width:15px;height:15px;border-radius:50%;background:#1D202B;margin-right:8px;"></span>   | `#1D202B`   | Background Tertiary — Soft contrast surface       |
| <span style="display:inline-block;width:15px;height:15px;border-radius:50%;background:#1A1C26;margin-right:8px;"></span>   | `#1A1C26`   | Surface — Material-like base layer                |
| <span style="display:inline-block;width:15px;height:15px;border-radius:50%;background:#2A2D3A;margin-right:8px;"></span>   | `#2A2D3A`   | Surface Variant — Lightly elevated                |
| <span style="display:inline-block;width:15px;height:15px;border-radius:50%;background:#CACEE2;margin-right:8px;"></span>   | `#CACEE2`   | Text Primary — Gentle off-white                   |
| <span style="display:inline-block;width:15px;height:15px;border-radius:50%;background:#B7BBD0;margin-right:8px;"></span>   | `#B7BBD0`   | Text Secondary — Muted lavender-blue              |
| <span style="display:inline-block;width:15px;height:15px;border-radius:50%;background:#6B718A;margin-right:8px;"></span>   | `#6B718A`   | Text Disabled — Dimmed blue-gray                  |
| <span style="display:inline-block;width:15px;height:15px;border-radius:50%;background:#A8AEFF;margin-right:8px;"></span>   | `#A8AEFF`   | Accent Primary — Light enchanted lavender         |
| <span style="display:inline-block;width:15px;height:15px;border-radius:50%;background:#9EA0FF;margin-right:8px;"></span>   | `#9EA0FF`   | Accent Secondary — Softer lavender hue            |
| <span style="display:inline-block;width:15px;height:15px;border-radius:50%;background:#8EABFF;margin-right:8px;"></span>   | `#8EABFF`   | Accent Tertiary — Warm golden glow (from lantern) |
| <span style="display:inline-block;width:15px;height:15px;border-radius:50%;background:#FF6B81;margin-right:8px;"></span>   | `#FF6B81`   | Error — Soft rose red                             |
| <span style="display:inline-block;width:15px;height:15px;border-radius:50%;background:#FFBB66;margin-right:8px;"></span>   | `#FFBB66`   | Warning — Candlelight amber-orange                |
| <span style="display:inline-block;width:15px;height:15px;border-radius:50%;background:#E3C2FF;margin-right:8px;"></span>   | `#E3C2FF`   | Highlight — Bright magical lavender               |
| <span style="display:inline-block;width:15px;height:15px;border-radius:50%;background:#F3DEFF;margin-right:8px;"></span>   | `#F3DEFF`   | Ripple Effect — Gentle soft splash                |
| <span style="display:inline-block;width:15px;height:15px;border-radius:50%;background:#1A1A1A;margin-right:8px;"></span>   | `#1A1A1A`   | On Accent — Text on accent background             |
| <span style="display:inline-block;width:15px;height:15px;border-radius:50%;background:#44485A;margin-right:8px;"></span>   | `#44485A`   | Outline — Subtle bluish-gray line                 |
| <span style="display:inline-block;width:15px;height:15px;border-radius:50%;background:#000000B3;margin-right:8px;"></span> | `#000000B3` | Shadow — Standard soft black shadow               |
| <span style="display:inline-block;width:15px;height:15px;border-radius:50%;background:#11121ACC;margin-right:8px;"></span> | `#11121ACC` | Overlay — Deep bluish overlay                     |

</details>

---

## Installation & Usage

<details>
<summary><strong>Installation</strong></summary>

Install quickshell:

```
yay -S quickshell-git
```

or use any other way of installing quickshell-git (flake, paru etc).

_Git clone the repo:_

```
git clone https://github.com/Ly-sec/Noctalia.git
```

_Move content to ~/.config/quickshell_

```
cd Noctalia && mv * ~/.config/quickshell/
```

</details>
</br>

<details>
<summary><strong>Usage</strong></summary>

### Start quickshell:

```
qs
```

(If you want to autostart it, just add it to your niri configuration.)

### Settings:

To make the weather widget, wallpaper manager and record button work you will have to open up the settings menu in to right panel (top right button to open panel) and edit said things accordingly.

</details>

</br>
<details>
<summary><strong>Keybinds</strong></summary>

### Open Applauncher:

```
 qs ipc call globalIPC toggleLauncher
```

You can keybind it however you want in your niri setup.

</details>

---

## Known issues

Currently the brightness indicator is very opiniated (using ddcutil with a script to log current brightness). This will be fixed **asap**!

---

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

---

## License

This project is licensed under the terms of the [MIT License](./LICENSE).
