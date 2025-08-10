import QtQuick
import Quickshell
import Quickshell.Io

// Lightweight system monitor using standard Linux interfaces.
// Provides cpu usage %, cpu temperature (°C), and memory usage %.
// No external helpers; uses /proc and /sys via a shell loop.
Item {
  id: root

  // Public values
  property real cpuUsage: 0
  property real cpuTemp: 0
  property real memoryUsagePer: 0
  property real diskUsage: 0

  // Interval in seconds between updates
  property int intervalSeconds: 1

  // Background process emitting one JSON line per sample
  Process {
    id: reader
    running: true
    command: [
      "sh", "-c",
      // Outputs: {"cpu":<int>,"memper":<int>,"cputemp":<int>}
      "interval=" + intervalSeconds + "; " +
      "while true; do " +
        // First /proc/stat snapshot
        "read _ u1 n1 s1 id1 iw1 ir1 si1 st1 gs1 < /proc/stat; " +
        "t1=$((u1+n1+s1+id1+iw1+ir1+si1+st1)); i1=$((id1+iw1)); " +
        "sleep $interval; " +
        // Second /proc/stat snapshot
        "read _ u2 n2 s2 id2 iw2 ir2 si2 st2 gs2 < /proc/stat; " +
        "t2=$((u2+n2+s2+id2+iw2+ir2+si2+st2)); i2=$((id2+iw2)); " +
        "dt=$((t2 - t1)); di=$((i2 - i1)); " +
        "cpu=$(( (100*(dt - di)) / (dt>0?dt:1) )); " +
        // Memory percent via /proc/meminfo (kB)
        "mt=$(awk '/MemTotal/ {print $2}' /proc/meminfo); " +
        "ma=$(awk '/MemAvailable/ {print $2}' /proc/meminfo); " +
        "mm=$((mt - ma)); mp=$(( (100*mm) / (mt>0?mt:1) )); " +
        // Temperature: scan hwmon and thermal zones, choose max; convert m°C → °C
        "ct=0; " +
        "for f in /sys/class/hwmon/hwmon*/temp*_input /sys/class/thermal/thermal_zone*/temp; do " +
          "[ -r \"$f\" ] || continue; v=$(cat \"$f\" 2>/dev/null); " +
          "[ -z \"$v\" ] && continue; " +
          "if [ \"$v\" -gt 1000 ] 2>/dev/null; then v=$((v/1000)); fi; " +
          "[ \"$v\" -gt \"$ct\" ] 2>/dev/null && ct=$v; " +
        "done; " +
        // Disk usage percent for root filesystem
        "dp=$(df -P / 2>/dev/null | awk 'NR==2{gsub(/%/,\"\",$5); print $5}'); " +
        "[ -z \"$dp\" ] && dp=0; " +
        // Emit JSON line
        "echo \"{\\\"cpu\\\":$cpu,\\\"memper\\\":$mp,\\\"cputemp\\\":$ct,\\\"diskper\\\":$dp}\"; " +
      "done"
    ]

    stdout: SplitParser {
      onRead: function (line) {
        try {
          const data = JSON.parse(line)
          root.cpuUsage = +data.cpu
          root.cpuTemp = +data.cputemp
          root.memoryUsagePer = +data.memper
          root.diskUsage = +data.diskper
        } catch (e) {
          // ignore malformed lines
        }
      }
    }
  }
}

