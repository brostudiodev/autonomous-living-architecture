#!/usr/bin/env python3
"""
Autonomous Living Goals Exporter for Prometheus
Scrapes task data from all EXECUTION.md files and exports metrics
"""

import os
import re
import yaml
import time
from pathlib import Path
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse
import json

class GoalsMetrics:
    def __init__(self):
        self.goals_dir = Path("/docs/10_GOALS")
        self.metrics = {}
        self.last_scan = 0
        
    def parse_execution_files(self):
        """Parse all EXECUTION.md files and extract task metrics"""
        self.metrics = {}
        
        for goal_dir in self.goals_dir.glob("G*_*/"):
            execution_file = goal_dir / "EXECUTION.md"
            if execution_file.exists():
                goal_id = goal_dir.name.split("_")[0]
                goal_name = goal_dir.name.replace("_", " ").replace("-", " ")
                
                with open(execution_file, 'r') as f:
                    content = f.read()
                
                # Parse frontmatter
                if content.startswith('---'):
                    try:
                        frontmatter_end = content.find('---', 3)
                        frontmatter = content[3:frontmatter_end]
                        metadata = yaml.safe_load(frontmatter)
                        
                        self.metrics[goal_id] = {
                            'name': goal_name,
                            'phase': metadata.get('current_phase', 'Unknown'),
                            'progress': metadata.get('phase_progress', 0),
                            'priority': metadata.get('priority', 'P3'),
                            'total_tasks': 0,
                            'completed_tasks': 0,
                            'p1_tasks': 0,
                            'p2_tasks': 0,
                            'p3_tasks': 0,
                            'blocked_tasks': 0,
                            'tasks': []
                        }
                    except:
                        continue
                
                # Parse tasks
                task_pattern = r'- \[([ x])\] \*\*([^*]+?)\*\* `(G\d+-T\d+)` `(\d+m)`(?:\s`[^`]+`)*\s`#(p\d+)`'
                for match in re.finditer(task_pattern, content):
                    status, task_name, task_id, time_est, priority = match.groups()
                    completed = status == 'x'
                    minutes = int(time_est.replace('m', ''))
                    
                    task_info = {
                        'id': task_id,
                        'name': task_name,
                        'completed': completed,
                        'minutes': minutes,
                        'priority': priority
                    }
                    
                    self.metrics[goal_id]['tasks'].append(task_info)
                    self.metrics[goal_id]['total_tasks'] += 1
                    
                    if completed:
                        self.metrics[goal_id]['completed_tasks'] += 1
                    if priority == 'p1':
                        self.metrics[goal_id]['p1_tasks'] += 1
                    elif priority == 'p2':
                        self.metrics[goal_id]['p2_tasks'] += 1
                    elif priority == 'p3':
                        self.metrics[goal_id]['p3_tasks'] += 1
                    
                    # Check if blocked (has "depends:" in task line)
                    task_line = match.group(0)
                    if 'depends:' in task_line and not completed:
                        self.metrics[goal_id]['blocked_tasks'] += 1

    def get_prometheus_metrics(self):
        """Convert metrics to Prometheus format"""
        if not self.metrics:
            self.parse_execution_files()
        
        lines = []
        
        # Overall metrics
        total_goals = len(self.metrics)
        total_tasks = sum(g['total_tasks'] for g in self.metrics.values())
        total_completed = sum(g['completed_tasks'] for g in self.metrics.values())
        total_p1 = sum(g['p1_tasks'] for g in self.metrics.values())
        total_p2 = sum(g['p2_tasks'] for g in self.metrics.values())
        total_p3 = sum(g['p3_tasks'] for g in self.metrics.values())
        
        lines.append(f"# HELP autonomous_goals_total Total number of goals")
        lines.append(f"# TYPE autonomous_goals_total gauge")
        lines.append(f"autonomous_goals_total {total_goals}")
        
        lines.append(f"# HELP autonomous_tasks_total Total number of tasks")
        lines.append(f"# TYPE autonomous_tasks_total gauge")
        lines.append(f"autonomous_tasks_total {total_tasks}")
        
        lines.append(f"# HELP autonomous_tasks_completed Total number of completed tasks")
        lines.append(f"# TYPE autonomous_tasks_completed gauge")
        lines.append(f"autonomous_tasks_completed {total_completed}")
        
        lines.append(f"# HELP autonomous_tasks_priority Tasks by priority level")
        lines.append(f"# TYPE autonomous_tasks_priority gauge")
        lines.append(f"autonomous_tasks_priority{{priority=\"p1\"}} {total_p1}")
        lines.append(f"autonomous_tasks_priority{{priority=\"p2\"}} {total_p2}")
        lines.append(f"autonomous_tasks_priority{{priority=\"p3\"}} {total_p3}")
        
        # Per-goal metrics
        for goal_id, goal_data in self.metrics.items():
            goal_name = goal_data['name'].replace('"', '\\"')
            phase = goal_data['phase']
            progress = goal_data['progress']
            priority = goal_data['priority']
            
            lines.append(f"# HELP autonomous_goal_progress Progress percentage for goal")
            lines.append(f"# TYPE autonomous_goal_progress gauge")
            lines.append(f'autonomous_goal_progress{{goal="{goal_id}",name="{goal_name}",phase="{phase}",priority="{priority}"}} {progress}')
            
            lines.append(f"# HELP autonomous_goal_tasks Task counts for goal")
            lines.append(f"# TYPE autonomous_goal_tasks gauge")
            lines.append(f'autonomous_goal_tasks{{goal="{goal_id}",name="{goal_name}",status="total"}} {goal_data["total_tasks"]}')
            lines.append(f'autonomous_goal_tasks{{goal="{goal_id}",name="{goal_name}",status="completed"}} {goal_data["completed_tasks"]}')
            lines.append(f'autonomous_goal_tasks{{goal="{goal_id}",name="{goal_name}",status="blocked"}} {goal_data["blocked_tasks"]}')
            
            completion_rate = 0
            if goal_data['total_tasks'] > 0:
                completion_rate = (goal_data['completed_tasks'] / goal_data['total_tasks']) * 100
            
            lines.append(f'autonomous_goal_completion_rate{{goal="{goal_id}",name="{goal_name}"}} {completion_rate:.1f}')
        
        return '\n'.join(lines) + '\n'

class MetricsHandler(BaseHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        self.metrics = GoalsMetrics()
        super().__init__(*args, **kwargs)
    
    def do_GET(self):
        parsed_path = urlparse(self.path)
        
        if parsed_path.path == '/metrics':
            self.send_response(200)
            self.send_header('Content-Type', 'text/plain')
            self.end_headers()
            self.wfile.write(self.metrics.get_prometheus_metrics().encode())
        elif parsed_path.path == '/goals':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.metrics.parse_execution_files()
            self.wfile.write(json.dumps(self.metrics.metrics, indent=2).encode())
        else:
            self.send_response(404)
            self.end_headers()
    
    def log_message(self, format, *args):
        pass  # Suppress logging

if __name__ == '__main__':
    try:
        server = HTTPServer(('0.0.0.0', 8080), MetricsHandler)
        print("Goals Metrics Exporter starting on http://localhost:8082")
        print("Metrics available at: http://localhost:8082/metrics")
        print("Goals JSON available at: http://localhost:8082/goals")
        server.serve_forever()
    except Exception as e:
        print(f"Error starting server: {e}")