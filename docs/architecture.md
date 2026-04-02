# Kiến Trúc Hệ Thống - eService AI Agent

## Tổng Quan

```
┌─────────────────────────────────────────────────────────────┐
│                    Microsoft Teams                           │
│  ┌─────────────────┐    ┌──────────────────────────────┐   │
│  │   Group Chat    │    │      Direct Message          │   │
│  │  @eService Agent│    │    (Personal 1:1)            │   │
│  └────────┬────────┘    └──────────────┬───────────────┘   │
└───────────┼──────────────────────────────┼────────────────────┘
            │                              │
            ▼                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  Copilot Studio Agent                        │
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌──────────────────┐   │
│  │   Topic:    │  │   Topic:    │  │     Topic:       │   │
│  │ Tra cứu    │  │ Ticket của  │  │  Thống kê /      │   │
│  │  Ticket    │  │    tôi      │  │  Tạo ticket      │   │
│  └──────┬──────┘  └──────┬──────┘  └────────┬─────────┘   │
│         └────────────────┴──────────────────┘              │
│                          │                                  │
│              ┌───────────┴───────────┐                     │
│              │  Power Automate       │                     │
│              │  Action Connector     │                     │
│              └───────────┬───────────┘                     │
└──────────────────────────┼──────────────────────────────────┘
                           │
            ┌──────────────┼──────────────┐
            │              │              │
            ▼              ▼              ▼
┌─────────────────────────────────────────────────────────────┐
│                  Power Automate Flows                        │
│                                                             │
│  ┌───────────────┐ ┌───────────────┐ ┌───────────────────┐ │
│  │   Flow 1      │ │   Flow 2      │ │      Flow 3       │ │
│  │ Daily Summary │ │ SLA Breach    │ │  Ticket Lookup    │ │
│  │  (Scheduled   │ │   Check       │ │  (HTTP Trigger)   │ │
│  │  8h/12h/17h)  │ │ (Every 30min) │ │   On-Demand       │ │
│  └──────┬────────┘ └───────┬───────┘ └────────┬──────────┘ │
└─────────┼──────────────────┼──────────────────┼────────────┘
          │                  │                  │
          └──────────────────┴──────────────────┘
                             │
                             ▼ HTTP POST
┌─────────────────────────────────────────────────────────────┐
│                  iTop REST API                               │
│           /webservices/rest.php                             │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐ │
│  │ UserRequest  │  │  Incident    │  │     Change       │ │
│  │  (Tickets)   │  │              │  │                  │ │
│  └──────────────┘  └──────────────┘  └──────────────────┘ │
│                                                             │
│              iTop Database (MySQL/MariaDB)                  │
└─────────────────────────────────────────────────────────────┘
```

## Luồng Dữ Liệu

### 1. Tra Cứu Ticket (On-Demand)

```
User @mention Agent trong Teams
    │
    ▼
Copilot Studio nhận message
    │
    ▼
Topic "Tra cứu ticket" được trigger
    │
    ▼
Agent hỏi mã ticket (nếu chưa có)
    │
    ▼
Invoke Flow 3 (HTTP POST)
    │  Body: { queryType: "ticket_ref", queryValue: "R-001234" }
    ▼
Flow 3 gọi iTop REST API
    │  POST /webservices/rest.php
    │  Query: SELECT UserRequest WHERE ref = 'R-001234'
    ▼
iTop trả về JSON
    │
    ▼
Flow 3 xử lý + tính SLA status
    │
    ▼
Copilot Studio nhận kết quả
    │
    ▼
Render Adaptive Card
    │
    ▼
Hiển thị cho user trong Teams
```

### 2. Cảnh Báo SLA (Scheduled)

```
Power Automate Recurrence (mỗi 30 phút)
    │
    ▼
Flow 2 chạy 3 queries song song:
    ├── Query 1: Tickets quá hạn SLA (ttr_deadline < NOW())
    ├── Query 2: Tickets sắp hết hạn (< 1 giờ)
    └── Query 3: Tickets P1/P2 không update > 4 giờ
    │
    ▼
Với mỗi ticket vi phạm:
    │
    ▼
Tạo Adaptive Card (SLA Breach Alert)
    │
    ▼
Post vào Teams Channel
    │
    ▼
Agent phụ trách nhận @mention cảnh báo
```

### 3. Báo Cáo Định Kỳ (Daily)

```
Recurrence Trigger (8h, 12h, 17h)
    │
    ▼
Flow 1 gọi iTop API lấy tất cả ticket mở
    │
    ▼
Nhóm theo agent/team
    │
    ▼
Đếm SLA breach, warning
    │
    ▼
Build Daily Summary Adaptive Card
    │
    ▼
Post vào Teams Channel
```

## Cấu Trúc Thư Mục

```
eservice-agent/
├── README.md                          # Overview & quick start
├── docs/
│   ├── setup-guide.md                 # Hướng dẫn triển khai chi tiết
│   └── architecture.md                # Tài liệu kiến trúc (file này)
│
├── power-automate/
│   ├── flow1-daily-summary.json       # Flow báo cáo định kỳ
│   ├── flow2-sla-breach-check.json    # Flow kiểm tra SLA
│   └── flow3-ticket-lookup.json       # Flow tra cứu on-demand
│
├── adaptive-cards/
│   ├── daily-summary-card.json        # Template card báo cáo ngày
│   ├── sla-breach-alert-card.json     # Template card cảnh báo SLA
│   └── ticket-detail-card.json        # Template card chi tiết ticket
│
└── copilot-studio/
    ├── agent-config.yaml              # Cấu hình tổng thể agent
    └── topics/
        ├── ticket-lookup.yaml          # Topic tra cứu ticket
        ├── my-tickets.yaml             # Topic xem ticket cá nhân
        ├── today-stats.yaml            # Topic thống kê
        └── create-ticket.yaml          # Topic tạo ticket mới
```

## Bảo Mật

| Thành phần | Phương pháp bảo mật |
|-----------|-------------------|
| iTop API Token | Lưu trong Azure Key Vault, đọc qua Environment Variables |
| Teams Connection | OAuth 2.0 qua Microsoft Identity Platform |
| HTTP Trigger URL | URL dạng SAS token, không chia sẻ công khai |
| User Data | Chỉ agent/manager mới thấy ticket của nhau |

## Mở Rộng

### Thêm chức năng Escalation tự động

```
Flow: SLA P1 Escalation
├── Trigger: Recurrence (mỗi 15 phút)
├── Query: P1 tickets unassigned > 30 phút
├── Action: Update ticket escalation_flag = true
└── Action: @mention manager trong Teams
```

### Tích hợp Power BI Dashboard

```
Power BI Dataset ← iTop Database (qua Power BI Gateway)
    │
    ▼
Embedded Dashboard trong Teams Tab
    │
    ▼
Agent có thể share link dashboard khi được hỏi
```

### Tích hợp Azure OpenAI (Nâng cao)

```
User: "Tóm tắt ticket R-001234 bằng tiếng Việt"
    │
    ▼
Flow 3 lấy nội dung ticket từ iTop
    │
    ▼
Gọi Azure OpenAI API (GPT-4)
    │  Prompt: "Tóm tắt ticket sau bằng tiếng Việt: {ticket_content}"
    ▼
Trả về tóm tắt cho user
```
