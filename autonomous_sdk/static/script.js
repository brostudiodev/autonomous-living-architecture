const terminal = document.getElementById('terminal-output');
const cmdInput = document.getElementById('cmd-input');
const sendBtn = document.getElementById('send-btn');

// 1. Send Command Logic
async function sendCommand(query) {
    if (!query) return;
    
    // Add user message to terminal
    appendLog(query, 'user');
    cmdInput.value = '';

    try {
        const response = await fetch('/chat', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ query: query })
        });
        
        const data = await response.json();
        appendLog(data.response_text || data.report || "No response received.", 'response');
        
        // Refresh vitals after a command
        updateVitals();
    } catch (error) {
        appendLog(`Error: ${error.message}`, 'system');
    }
}

function appendLog(text, type) {
    const entry = document.createElement('div');
    entry.className = `log-entry ${type}`;
    
    if (type === 'user') {
        entry.innerText = `> ${text}`;
    } else {
        entry.innerText = text;
    }
    
    terminal.appendChild(entry);
    terminal.scrollTop = terminal.scrollHeight;
}
async function updateVitals() {
    try {
        const response = await fetch('/status');
        const rootData = await response.json();
        const data = rootData.data || {}; // Access the nested structured data
        
        document.getElementById('readiness-val').innerText = data.readiness || "--";
        document.getElementById('hrv-val').innerText = data.hrv || "--";
        document.getElementById('sleep-val').innerText = data.sleep_score || "--";
        document.getElementById('steps-val').innerText = data.steps || "--";
        document.getElementById('water-val').innerText = (data.water_ml || "0") + " ml";
        document.getElementById('caffeine-val').innerText = (data.caffeine_mg || "0") + " mg";
        document.getElementById('finance-val').innerText = data.finance_status || "Stable";
        document.getElementById('pantry-val').innerText = data.pantry_status || "Healthy";
    } catch (e) {
        console.error("Vitals update failed", e);
    }
}

// 3. System Health Light Logic
async function updateSystemHealth() {
    try {
        const response = await fetch('/system_health');
        const data = await response.json();
        const light = document.getElementById('system-status-light');

        // Reset classes
        light.className = 'status-light';

        if (data.report.includes("HEALTHY")) {
            light.classList.add('status-healthy');
            light.title = "All systems operational";
        } else if (data.report.includes("DEGRADED")) {
            light.classList.add('status-degraded');
            light.title = "Some issues detected (check /system_health)";
        } else if (data.report.includes("CRITICAL")) {
            light.classList.add('status-critical');
            light.title = "System failures detected!";
        } else {
            light.classList.add('status-unknown');
        }
    } catch (e) {
        console.error("Health check failed", e);
    }
}

// Initial Load
updateVitals();
updateSystemHealth();
setInterval(updateVitals, 60000); // Reduce polling to 60s as we have WebSockets
setInterval(updateSystemHealth, 120000); // Reduce polling to 120s

// 4. WebSocket Bridge (G04-EDT)
function connectWebSocket() {
    const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    const wsUrl = `${protocol}//${window.location.host}/ws`;
    const socket = new WebSocket(wsUrl);

    socket.onopen = () => {
        console.log("🚀 WebSocket Connected to Digital Twin Bridge");
        appendLog("System: Real-time event bridge established.", "system");
    };

    socket.onmessage = (event) => {
        try {
            const data = JSON.parse(event.data);
            console.log("📩 Event Received:", data);
            
            // Handle specific events that should trigger UI refresh
            const refreshActions = ["biometrics_updated", "state_updated", "cache_refreshed", "activity_logged"];
            if (refreshActions.includes(data.action)) {
                updateVitals();
                updateSystemHealth();
            }
            
            // Log high-severity events to terminal
            if (data.severity === "WARNING" || data.severity === "CRITICAL" || data.severity === "FAILURE") {
                const source = data.domain || data.source || "SYSTEM";
                appendLog(`⚠️ [${source.toUpperCase()}] ${data.action}: ${data.payload.details || data.payload.message || JSON.stringify(data.payload)}`, 'system');
            }
        } catch (e) {
            console.error("Error parsing WebSocket message", e);
        }
    };

    socket.onclose = () => {
        console.warn("🔌 WebSocket Disconnected. Retrying in 5s...");
        setTimeout(connectWebSocket, 5000);
    };

    socket.onerror = (err) => {
        console.error("❌ WebSocket Error:", err);
        socket.close();
    };
}

connectWebSocket();

sendBtn.addEventListener('click', () => sendCommand(cmdInput.value));
