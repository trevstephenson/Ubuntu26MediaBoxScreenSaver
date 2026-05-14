#!/bin/bash
VIDEO_DIR="/home/tv/Videos/Aerial/aerials"
IDLE_LIMIT_MS=60000  # 60 seconds

is_inhibited() {
    local inhibitors
    inhibitors=$(gdbus call --session \
        --dest org.gnome.SessionManager \
        --object-path /org/gnome/SessionManager \
        --method org.gnome.SessionManager.IsInhibited 8 2>/dev/null)
    [[ "$inhibitors" == *"true"* ]]
}

while true; do
    IDLE_MS=$(dbus-send --session --print-reply \
        --dest=org.gnome.Mutter.IdleMonitor \
        /org/gnome/Mutter/IdleMonitor/Core \
        org.gnome.Mutter.IdleMonitor.GetIdletime \
        | awk '/uint64/ {print $2}')
    if [ -n "$IDLE_MS" ] && [ "$IDLE_MS" -ge "$IDLE_LIMIT_MS" ] && ! pgrep -x mpv > /dev/null && ! is_inhibited; then
        mpv --fullscreen --really-quiet \
            --shuffle --loop-playlist=inf \
            --no-osc --no-input-default-bindings \
            --input-conf=/dev/stdin \
	    "$VIDEO_DIR"/*.mov <<< "$(cat <<'EOF'
q quit
ESC quit
SPACE quit
ENTER quit
MBTN_LEFT quit
MBTN_RIGHT quit
MBTN_MID quit
a quit
b quit
c quit
d quit
e quit
f quit
g quit
h quit
i quit
j quit
k quit
l quit
m quit
n quit
o quit
p quit
r quit
s quit
t quit
u quit
v quit
w quit
x quit
y quit
z quit
EOF
)"
    fi
    sleep 5
done
