---
title: "Low-Level Design Documentation"
type: "documentation"
status: "active"
owner: "Michał"
updated: "2026-02-19"
---

# Low-Level Design Documentation

## Overview

This document provides detailed low-level design specifications for the autonomous-living ecosystem, including API contracts, database schemas, service interfaces, and implementation details.

---

## 🔗 **API SPECIFICATIONS**

### **G04 Digital Twin Router API**

#### **Telegram Webhook Endpoint**
```yaml
endpoint: /webhook/master-telegram-router
method: POST
authentication: Bot Token (Bearer)
rate_limit: 30 requests/minute
timeout: 30 seconds

request_schema:
  type: object
  properties:
    update_id:
      type: integer
      description: Unique update identifier
    message:
      type: object
      properties:
        message_id: integer
        from: object
          properties:
            id: integer
            is_bot: boolean
            first_name: string
            username: string
        chat:
          type: object
          properties:
            id: integer
            type: string
            first_name: string
            username: string
        text:
          type: string
          description: Message text content
        voice:
          type: object
          properties:
            file_id: string
            duration: integer
            mime_type: string
            file_size: integer
        document:
          type: object
          properties:
            file_id: string
            file_name: string
            mime_type: string
            file_size: integer

response_schema:
  type: object
  properties:
    method: string
    chat_id: integer
    text: string
    parse_mode: string
    reply_markup: object
```

#### **Intelligence Hub Webhook**
```yaml
endpoint: /webhook/intelligence-hub
method: POST
authentication: API Key (X-API-Key: "{{API_SECRET}}")
rate_limit: 100 requests/minute
timeout: 60 seconds

request_schema:
  type: object
  properties:
    request_id:
      type: string
      format: uuid
    source_system:
      type: string
      enum: [g01, g03, g04, g05, g07, g12]
    event_type:
      type: string
      enum: [data_update, status_change, alert, query]
    timestamp:
      type: string
      format: date-time
    payload:
      type: object
      description: Event-specific data
    metadata:
      type: object
      properties:
        priority: string
        correlation_id: string
        retry_count: integer

response_schema:
  type: object
  properties:
    request_id: string
    status: string
    enum: [success, error, processing]
    message: string
    data: object
    processing_time_ms: integer

#### **Digital Twin Status API**
```yaml
endpoint: /status
method: GET
port: 5677
authentication: Internal Network
purpose: Aggregated life state summary

response_schema:
  type: object
  properties:
    summary:
      type: string
      description: Human-readable multi-domain status
    state:
      type: object
      properties:
        health:
          type: object
          properties:
            last_workout: string
            days_since_workout: integer
            bodyweight_kg: number
            bodyfat_pct: number
        finance:
          type: object
          properties:
            mtd_net: number
            active_budget_alerts: integer
        timestamp: string
```
```

---

## 🗄️ **DATABASE SCHEMAS**

### **PostgreSQL Financial Database**

#### **Transactions Table**
```sql
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transaction_date TIMESTAMP WITH TIME ZONE NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'PLN',
    description TEXT,
    category_id UUID REFERENCES categories(id),
    merchant_id UUID REFERENCES merchants(id),
    account_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    user_id VARCHAR(50) DEFAULT 'michal',
    
    CONSTRAINT check_amount_positive CHECK (amount > 0),
    CONSTRAINT check_valid_currency CHECK (currency ~ '^[A-Z]{3}$')
) PARTITION BY RANGE (transaction_date);

-- Yearly partitions
CREATE TABLE transactions_2025 PARTITION OF transactions
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

CREATE TABLE transactions_2026 PARTITION OF transactions
    FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');
```

#### **Categories Table**
```sql
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    parent_category_id UUID REFERENCES categories(id),
    type VARCHAR(20) NOT NULL CHECK (type IN ('expense', 'income', 'transfer')),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Trigger for automatic category creation
CREATE OR REPLACE FUNCTION auto_create_merchant()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO categories (name, type)
    VALUES (NEW.description, 'expense')
    ON CONFLICT (name) DO NOTHING;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

#### **Budgets Table**
```sql
CREATE TABLE budgets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID REFERENCES categories(id),
    year INTEGER NOT NULL,
    month INTEGER NOT NULL,
    budget_amount DECIMAL(15,2) NOT NULL,
    spent_amount DECIMAL(15,2) DEFAULT 0,
    alert_threshold DECIMAL(3,2) DEFAULT 0.80,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(category_id, year, month)
);
```

#### **Digital Twin Updates Table**
```sql
CREATE TABLE digital_twin_updates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_type VARCHAR(50) NOT NULL,
    entity_id UUID NOT NULL,
    update_data JSONB NOT NULL,
    source_system VARCHAR(50) NOT NULL,
    update_type VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    processed_at TIMESTAMP WITH TIME ZONE,
    
    CONSTRAINT valid_entity_type CHECK (entity_type IN ('person', 'goal', 'health', 'training', 'finance', 'pantry'))
);

-- Indexes for efficient querying
CREATE INDEX idx_digital_twin_updates_entity ON digital_twin_updates(entity_type, entity_id);
CREATE INDEX idx_digital_twin_updates_source ON digital_twin_updates(source_system, created_at);
CREATE INDEX idx_digital_twin_updates_gin_data ON digital_twin_updates USING GIN(update_data);
```

---

## 🛠️ **SERVICE INTERFACES**

### **G01 Training Metrics Exporter**
```python
# g01-exporter.py Interface Specification

class TrainingMetricsExporter:
    """Prometheus metrics exporter for G01 training system"""
    
    def __init__(self, port: int = 8081):
        self.port = port
        self.app = make_wsgi_app()
        
    # Prometheus Metrics
    def setup_metrics(self):
        """Initialize all Prometheus metrics"""
        
        # Body Fat Metrics
        self.body_fat_gauge = Gauge(
            'g01_body_fat_percentage',
            'Current body fat percentage (7-day moving average)',
            ['workout_type', 'measurement_source']
        )
        
        # Workout Frequency
        self.workout_counter = Counter(
            'g01_workout_total',
            'Total number of workouts completed',
            ['workout_type', 'intensity_level', 'quarter']
        )
        
        # Training Volume
        self.training_volume_gauge = Gauge(
            'g01_training_volume_total',
            'Total training volume (weight × reps × sets)',
            ['exercise_category', 'muscle_group', 'week']
        )
        
        # TUT Compliance
        self.tut_compliance_gauge = Gauge(
            'g01_tut_compliance_percentage',
            'Time Under Tension compliance percentage',
            ['exercise_type', 'target_range']
        )
    
    def load_training_data(self) -> List[TrainingSession]:
        """Load training data from Google Sheets"""
        # Returns list of TrainingSession objects
        
    def calculate_moving_averages(self, data: List[TrainingSession]) -> Dict[str, float]:
        """Calculate 7-day moving averages for body fat"""
        
    def update_metrics(self):
        """Update all Prometheus metrics with latest data"""
        
    def start_server(self):
        """Start the HTTP server for metrics scraping"""
```

#### **TrainingSession Data Model**
```python
@dataclass
class TrainingSession:
    id: str
    workout_date: datetime
    workout_type: str  # HIT_upper, HIT_lower, HIT_fullbody
    duration_minutes: int
    exercises: List[Exercise]
    body_fat_percentage: Optional[float] = None
    perceived_exertion: Optional[int] = None  # 1-10 scale
    
    def calculate_total_volume(self) -> float:
        """Calculate total training volume"""
        return sum(exercise.weight * exercise.reps * exercise.sets for exercise in self.exercises)

@dataclass
class Exercise:
    name: str
    category: str
    muscle_group: str
    weight: float
    reps: int
    sets: int
    tut_seconds: int
    form_rating: int  # 1-5 scale
    rest_seconds: int
```

---

### **G03 Pantry AI Service**
```python
# pantry_ai_service.py Interface Specification

class PantryAIService:
    """AI-powered pantry management service using Google Gemini"""
    
    def __init__(self, gemini_api_key: "{{API_SECRET}}"):
        self.gemini_client = genai.configure(api_key: "{{API_SECRET}}")
        self.setup_gemini_tools()
        
    def setup_gemini_tools(self):
        """Configure 6 custom tools for Gemini AI"""
        
        self.tools = [
            Tool(
                name="check_inventory",
                description="Check current pantry inventory",
                parameters={
                    "item_name": "string",
                    "category": "string"
                }
            ),
            Tool(
                name="update_inventory",
                description="Update pantry item quantity",
                parameters={
                    "item_name": "string",
                    "quantity_change": "integer",
                    "operation": "string"  # add, remove, set
                }
            ),
            Tool(
                name="generate_shopping_list",
                description="Generate grocery shopping list",
                parameters={
                    "budget_constraint": "float",
                    "days_ahead": "integer",
                    "preferences": "array"
                }
            ),
            Tool(
                name="check_expiry_alerts",
                description="Check for items expiring soon",
                parameters={
                    "days_ahead": "integer"
                }
            ),
            Tool(
                name="get_nutrition_info",
                description="Get nutritional information for items",
                parameters={
                    "item_name": "string"
                }
            ),
            Tool(
                name="analyze_consumption_patterns",
                description="Analyze household consumption patterns",
                parameters={
                    "time_period": "string",
                    "category": "string"
                }
            )
        ]
    
    def process_natural_language_input(self, input_text: str, language: str = "pl") -> AIResponse:
        """Process natural language input in Polish or English"""
        
    def synthesize_polish_responses(self, ai_response: str) -> str:
        """Generate culturally appropriate Polish responses"""
        
    def check_budget_constraints(self, shopping_list: List[ShoppingItem]) -> BudgetCheckResult:
        """Validate shopping list against financial constraints"""
        
    def optimize_shopping_route(self, items: List[ShoppingItem]) -> RouteOptimization:
        """Optimize store routing for shopping efficiency"""

@dataclass
class AIResponse:
    intent: str
    entities: Dict[str, Any]
    tool_calls: List[ToolCall]
    natural_response: str
    confidence_score: float
    requires_clarification: bool
```

---

## 🔄 **WORKFLOW SPECIFICATIONS**

### **n8n WF001 Digital Twin Router**
```yaml
workflow_id: WF001_Agent_Router
name: Digital Twin Intelligence Router
schedule: webhook_trigger
description: Central router for all AI-powered interactions

nodes:
  - id: trigger
    type: webhook
    webhook_id: master-telegram-router
    path: /webhook/master-telegram-router
    
  - id: input_parser
    type: function
    function: |
      // Parse incoming webhook data
      const data = $input.first().json;
      const message = data.message || data.edited_message;
      
      if (!message) return [];
      
      return {
        json: {
          message_id: message.message_id,
          chat_id: message.chat.id,
          user_id: message.from.id,
          text: message.text || '',
          voice: message.voice || null,
          document: message.document || null,
          photo: message.photo || null,
          command: parseCommand(message.text),
          input_type: detectInputType(message)
        }
      };
    
  - id: command_router
    type: switch
    conditions:
      - condition: '{{$json.input_type === "command"}}'
        path: command_handler
      - condition: '{{$json.input_type === "capture"}}'
        path: ai_analysis
      - condition: '{{$json.input_type === "question"}}'
        path: llm_chat
      - condition: '{{$json.input_type === "conversation"}}'
        path: greeting_handler
      - condition: '{{$json.input_type === "task"}}'
        path: task_creator
      - condition: '{{$json.input_type === "callback"}}'
        path: callback_handler
      default: greeting_handler
    
  - id: ai_analysis
    type: http_request
    method: POST
    url: https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent
    headers:
      Authorization: Bearer {{ $credentials.gemini_api_key }}
      Content-Type: application/json
    body: |
      {
        "contents": [
          {
            "parts": [
              {
                "text": "Process this content for autonomous living system: {{$json.text}}"
              }
            ]
          }
        ],
        "tools": [
          {
            "function_declarations": [
              {
                "name": "extract_information",
                "description": "Extract structured information",
                "parameters": {
                  "type": "object",
                  "properties": {
                    "entities": {"type": "array"},
                    "topics": {"type": "array"},
                    "actions": {"type": "array"}
                  }
                }
              }
            }
            ]
          }
        ]
      }
    
  - id: github_sync
    type: http_request
    method: POST
    url: https://api.github.com/repos/brostudiodev/michal-second-brain-obsidian/contents/AI-Processed/{{$json.timestamp}}.md
    headers:
      Authorization: token {{ $credentials.github_token }}
      Accept: application/vnd.github.v3+json
    body: |
      {
        "message": "AI processed content - {{$json.timestamp}}",
        "content": "{{base64($json.processed_content)}}",
        "branch": "main"
      }
    
  - id: telegram_response
    type: telegram_bot
    chat_id: '{{$json.chat_id}}'
    text: |
      🤖 *Digital Twin Response*
      
      {{$json.response_text}}
      
      ────────
      📊 Processed: {{$json.processing_time}}ms
      🎯 Intent: {{$json.detected_intent}}
    parse_mode: Markdown

connections:
  trigger -> input_parser
  input_parser -> command_router
  command_router.command_handler -> command_handler
  command_router.ai_analysis -> ai_analysis
  command_router.llm_chat -> llm_chat
  command_router.greeting_handler -> greeting_handler
  ai_analysis -> github_sync
  github_sync -> telegram_response
  command_handler -> telegram_response
  greeting_handler -> telegram_response
```

---

## 📊 **METRICS SPECIFICATIONS**

### **Prometheus Metrics Catalog**

#### **G01 Training Metrics**
```python
# Gauge metrics
g01_body_fat_percentage = Gauge(
    'g01_body_fat_percentage',
    'Current body fat percentage (7-day moving average)',
    ['workout_type', 'measurement_source', 'quarter']
)

g01_training_volume = Gauge(
    'g01_training_volume_total',
    'Total training volume for period',
    ['exercise_category', 'muscle_group', 'week', 'month']
)

g01_tut_compliance = Gauge(
    'g01_tut_compliance_percentage',
    'Time Under Tension compliance percentage',
    ['exercise_type', 'target_range', 'session_type']
)

# Counter metrics
g01_workout_total = Counter(
    'g01_workout_total',
    'Total number of workouts completed',
    ['workout_type', 'intensity_level', 'quarter']
)

g01_exercise_total = Counter(
    'g01_exercise_total',
    'Total number of exercises performed',
    ['exercise_name', 'category', 'muscle_group']
)

# Histogram metrics
g01_workout_duration = Histogram(
    'g01_workout_duration_seconds',
    'Workout duration in seconds',
    ['workout_type', 'intensity_level'],
    buckets=[600, 900, 1200, 1500, 1800, 2400, 3600]  # 10min to 1hr
)
```

#### **Goals Progress Metrics**
```python
goals_completion_percentage = Gauge(
    'goals_completion_percentage',
    'Progress towards goal completion',
    ['goal_id', 'goal_category', 'quarter', 'year']
)

goals_activity_frequency = Counter(
    'goals_activity_frequency_total',
    'Number of goal-related activities',
    ['goal_id', 'activity_type', 'success_status']
)

goals_integration_coverage = Gauge(
    'goals_integration_coverage_percentage',
    'Percentage of systems integrated',
    ['integration_type', 'system_id', 'status']
)

goals_system_health_score = Gauge(
    'goals_system_health_score',
    'Overall system health indicator',
    ['system_id', 'health_category', 'severity']
)
```

---

## 🔧 **CONFIGURATION MANAGEMENT**

### **Environment Variables**
```bash
# Database Configuration
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=autonomous_finance
POSTGRES_USER=michal
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}

# API Keys
GEMINI_API_KEY=${GEMINI_API_KEY}
OPENAI_API_KEY=${OPENAI_API_KEY}
TELEGRAM_BOT_TOKEN=${TELEGRAM_BOT_TOKEN}
SLACK_BOT_TOKEN=${SLACK_BOT_TOKEN}

# Service Configuration
N8N_HOST=localhost
N8N_PORT=5678
GRAFANA_PORT=3003
PROMETHEUS_PORT=9090

# Google Services
GOOGLE_APPLICATION_CREDENTIALS=/app/credentials/google-credentials.json
GITHUB_TOKEN=${GITHUB_TOKEN}

# Monitoring
ENABLE_METRICS=true
METRICS_PORT=8080
LOG_LEVEL=INFO
```

### **Docker Configuration**
```yaml
# docker-compose.yml
version: '3.8'

services:
  postgresql:
    image: postgres:15-alpine
    container_name: autonomous-postgres
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    ports:
      - "${POSTGRES_PORT:-5432}:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./infrastructure/database/init.sql:/docker-entrypoint-initdb.d/init.sql
    restart: unless-stopped
    networks:
      - autonomous-network

  grafana:
    image: grafana/grafana:latest
    container_name: autonomous-grafana
    ports:
      - "${GRAFANA_PORT:-3003}:3000"
    environment:
      GF_SECURITY_ADMIN_PASSWORD: ${GRAFANA_PASSWORD}
      GF_INSTALL_PLUGINS: grafana-clock-panel,grafana-simple-json-datasource
    volumes:
      - grafana_data:/var/lib/grafana
      - ./infrastructure/grafana/provisioning:/etc/grafana/provisioning
    depends_on:
      - prometheus
    restart: unless-stopped
    networks:
      - autonomous-network

volumes:
  postgres_data:
  grafana_data:
  prometheus_data:

networks:
  autonomous-network:
    driver: bridge
```

---

## 🛡️ **SECURITY IMPLEMENTATION**

### **API Authentication**
```python
# security.py
from functools import wraps
from flask import request, jsonify
import jwt
import os

class SecurityManager:
    def __init__(self):
        self.secret_key = os.getenv('JWT_SECRET_KEY')
        self.api_keys = {
            'telegram': os.getenv('TELEGRAM_BOT_TOKEN'),
            'slack': os.getenv('SLACK_BOT_TOKEN'),
            'n8n': os.getenv('N8N_API_KEY')
        }
    
    def validate_api_key(self, service: str, provided_key: str) -> bool:
        """Validate API key for specific service"""
        expected_key = self.api_keys.get(service)
        return expected_key and expected_key == provided_key
    
    def generate_jwt_token(self, user_id: str, permissions: list) -> str:
        """Generate JWT token: "{{API_SECRET}}" internal authentication"""
        payload = {
            'user_id': user_id,
            'permissions': permissions,
            'exp': datetime.utcnow() + timedelta(hours=24),
            'iat': datetime.utcnow()
        }
        return jwt.encode(payload, self.secret_key, algorithm='HS256')
    
    def verify_jwt_token(self, token: "{{API_SECRET}}") -> dict:
        """Verify JWT token: "{{API_SECRET}}" return payload"""
        try:
            payload = jwt.decode(token, self.secret_key, algorithms=['HS256'])
            return payload
        except jwt.ExpiredSignatureError:
            raise AuthenticationError('Token: "{{API_SECRET}}")
        except jwt.InvalidTokenError:
            raise AuthenticationError('Invalid token')

def require_api_key(service: str):
    """Decorator to require API key authentication"""
    def decorator(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            api_key: "{{API_SECRET}}".headers.get('X-API-Key') or request.args.get('api_key')
            if not api_key: "{{API_SECRET}}" jsonify({'error': 'API key required'}), 401
            
            if not security_manager.validate_api_key(service, api_key):
                return jsonify({'error': 'Invalid API key'}), 401
            
            return f(*args, **kwargs)
        return decorated_function
    return decorator
```

---

## 📈 **PERFORMANCE OPTIMIZATION**

### **Database Query Optimization**
```sql
-- Optimized queries with proper indexing

-- Efficient budget performance query
CREATE MATERIALIZED VIEW budget_performance_mview AS
SELECT 
    b.year,
    b.month,
    c.name as category_name,
    b.budget_amount,
    COALESCE(SUM(t.amount), 0) as spent_amount,
    ROUND((COALESCE(SUM(t.amount), 0) / b.budget_amount) * 100, 2) as percentage_used,
    CASE 
        WHEN COALESCE(SUM(t.amount), 0) > b.budget_amount * b.alert_threshold THEN 'over_budget'
        WHEN COALESCE(SUM(t.amount), 0) > b.budget_amount * 0.8 THEN 'warning'
        ELSE 'on_track'
    END as budget_status
FROM budgets b
LEFT JOIN categories c ON b.category_id = c.id
LEFT JOIN transactions t ON b.category_id = t.category_id 
    AND EXTRACT(YEAR FROM t.transaction_date) = b.year
    AND EXTRACT(MONTH FROM t.transaction_date) = b.month
WHERE b.is_active = true
GROUP BY b.year, b.month, c.name, b.budget_amount, b.alert_threshold;

-- Refresh schedule
CREATE OR REPLACE FUNCTION refresh_budget_performance()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY budget_performance_mview;
END;
$$ LANGUAGE plpgsql;

-- Automated refresh
SELECT cron.schedule('refresh-budget-performance', '0 0,12 * * *', 'SELECT refresh_budget_performance();');
```

---

## 🔍 **MONITORING & OBSERVABILITY**

### **Custom Prometheus Exporter Template**
```python
# exporter_template.py
from prometheus_client import start_http_server, Gauge, Counter, Histogram, Info
import time
import logging

class BaseExporter:
    """Base class for custom Prometheus exporters"""
    
    def __init__(self, port: int, metrics_prefix: str):
        self.port = port
        self.metrics_prefix = metrics_prefix
        self.logger = logging.getLogger(self.__class__.__name__)
        self.setup_logging()
        self.setup_metrics()
    
    def setup_logging(self):
        """Setup logging configuration"""
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
    
    def setup_metrics(self):
        """Setup Prometheus metrics - override in subclasses"""
        self.info_metric = Info(f'{self.metrics_prefix}_info', 'Exporter information')
        self.up_metric = Gauge(f'{self.metrics_prefix}_up', 'Exporter status')
        self.export_duration = Histogram(f'{self.metrics_prefix}_export_duration_seconds', 
                                      'Export duration in seconds')
        
        # Set static labels
        self.info_metric.info({
            'version': '1.0.0',
            'exporter': self.__class__.__name__,
            'python_version': f"{sys.version_info.major}.{sys.version_info.minor}"
        })
        self.up_metric.set(1)
    
    def collect_metrics(self):
        """Collect metrics - override in subclasses"""
        raise NotImplementedError("Subclasses must implement collect_metrics()")
    
    def start_server(self):
        """Start the HTTP server for metrics collection"""
        start_http_server(self.port)
        self.logger.info(f"Started {self.__class__.__name__} on port {self.port}")
        
        while True:
            start_time = time.time()
            try:
                self.collect_metrics()
                duration = time.time() - start_time
                self.export_duration.observe(duration)
            except Exception as e:
                self.logger.error(f"Error collecting metrics: {e}")
                self.up_metric.set(0)
            
            time.sleep(15)  # Collect every 15 seconds
```

---

## 🔄 **ERROR HANDLING & RESILIENCE**

### **Circuit Breaker Pattern**
```python
# circuit_breaker.py
import time
from enum import Enum
from typing import Callable, Any

class CircuitState(Enum):
    CLOSED = "closed"
    OPEN = "open"
    HALF_OPEN = "half_open"

class CircuitBreaker:
    def __init__(self, 
                 failure_threshold: int = 5,
                 timeout: int = 60,
                 expected_exception: type = Exception):
        self.failure_threshold = failure_threshold
        self.timeout = timeout
        self.expected_exception = expected_exception
        
        self.failure_count = 0
        self.last_failure_time = None
        self.state = CircuitState.CLOSED
    
    def __call__(self, func: Callable) -> Callable:
        def wrapper(*args, **kwargs):
            if self.state == CircuitState.OPEN:
                if time.time() - self.last_failure_time > self.timeout:
                    self.state = CircuitState.HALF_OPEN
                else:
                    raise Exception("Circuit breaker is OPEN")
            
            try:
                result = func(*args, **kwargs)
                self.reset()
                return result
            except self.expected_exception as e:
                self.record_failure()
                raise e
        
        return wrapper
    
    def record_failure(self):
        self.failure_count += 1
        self.last_failure_time = time.time()
        
        if self.failure_count >= self.failure_threshold:
            self.state = CircuitState.OPEN
    
    def reset(self):
        self.failure_count = 0
        self.last_failure_time = None
        self.state = CircuitState.CLOSED

# Usage example
@circuit_breaker(failure_threshold=3, timeout=30)
def call_external_api():
    # External API call that might fail
    pass
```

---

## 📋 **DEPLOYMENT PROCEDURES**

### **Blue-Green Deployment Script**
```bash
#!/bin/bash
# deploy.sh - Blue-Green deployment for services

set -e

SERVICE_NAME=${1}
NEW_VERSION=${2}
BLUE_PORT=${3}
GREEN_PORT=${4}

echo "Deploying ${SERVICE_NAME} version ${NEW_VERSION}"
echo "Blue port: ${BLUE_PORT}, Green port: ${GREEN_PORT}"

# Check which color is currently active
CURRENT_COLOR=$(docker ps --filter "name=${SERVICE_NAME}" --format "{{.Names}}" | grep -E "(blue|green)" | head -1 | cut -d'-' -f3)

if [[ $CURRENT_COLOR == "blue" ]]; then
    TARGET_COLOR="green"
    TARGET_PORT=$GREEN_PORT
    ACTIVE_PORT=$BLUE_PORT
else
    TARGET_COLOR="blue"
    TARGET_PORT=$BLUE_PORT
    ACTIVE_PORT=$GREEN_PORT
fi

echo "Deploying to ${TARGET_COLOR} (port ${TARGET_PORT})"

# Build new version
docker build -t ${SERVICE_NAME}:${NEW_VERSION} .

# Deploy to target color
docker-compose -f docker-compose.${TARGET_COLOR}.yml up -d

# Health check
echo "Performing health check..."
for i in {1..30}; do
    if curl -f http://localhost:${TARGET_PORT}/health; then
        echo "Health check passed"
        break
    else
        echo "Health check failed, retrying... ($i/30)"
        sleep 2
    fi
done

# Switch traffic
echo "Switching traffic to ${TARGET_COLOR}"
docker network disconnect autonomous-network ${SERVICE_NAME}-${CURRENT_COLOR}
docker network connect autonomous-network ${SERVICE_NAME}-${TARGET_COLOR}

# Update load balancer
sed -i "s/localhost:${ACTIVE_PORT}/localhost:${TARGET_PORT}/g" nginx.conf
docker-compose -f nginx.yml up -d

# Wait and cleanup
echo "Waiting 60 seconds before cleanup..."
sleep 60

docker-compose -f docker-compose.${CURRENT_COLOR}.yml down

echo "Deployment completed successfully"
```

---

## Conclusion

This low-level design documentation provides the technical specifications needed to understand, maintain, and extend the autonomous-living ecosystem. All components follow industry best practices for:

- **API Design:** RESTful with proper authentication and error handling
- **Database Design:** Normalized schemas with proper indexing and partitioning
- **Service Architecture:** Microservices with clear interfaces and contracts
- **Monitoring:** Comprehensive observability with custom metrics
- **Security:** Defense-in-depth with proper authentication and authorization
- **Reliability:** Circuit breakers, retries, and graceful degradation

The system is designed for scalability, maintainability, and operational excellence while maintaining the sophisticated integration between all 12 goals and supporting infrastructure.

*Last updated: 2026-02-11*