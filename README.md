- 👋 Hi, I'm @anhdp2311
- 👀 I'm interested in iOT, Crypto
- 🌱 I'm currently learning Data analysis
- 💞️ I'm looking to collaborate on ...
- 📫 How to reach me ...

<!---
anhdp2311/anhdp2311 is a ✨ special ✨ repository because its `README.md` (this file) appears on your GitHub profile.
You can click the Preview link to take a look at your changes.
--->

---

## 🤖 eService AI Agent (Copilot Studio + iTop)

Dự án xây dựng AI Agent tích hợp **Microsoft Copilot Studio** với hệ thống **iTop (eService)** để quản lý và theo dõi ticket hỗ trợ trong **Microsoft Teams**.

### ✨ Tính Năng

| Tính năng | Mô tả |
|-----------|-------|
| 📊 **Báo cáo định kỳ** | Tự động gửi tổng hợp ticket chưa xử lý vào Teams lúc 8h, 12h, 17h |
| 🚨 **Cảnh báo SLA** | Phát hiện và cảnh báo ticket vi phạm hoặc sắp vi phạm SLA mỗi 30 phút |
| 🔍 **Tra cứu nhanh** | `@eService Agent tra cứu R-001234` - xem chi tiết ticket tức thì |
| 📋 **Ticket cá nhân** | `@eService Agent ticket của tôi` - danh sách ticket được assign |
| 📈 **Dashboard** | `@eService Agent thống kê hôm nay` - tổng quan tình trạng hệ thống |
| 📝 **Tạo ticket** | `@eService Agent tạo ticket` - tạo yêu cầu mới ngay trong chat |

### 🏗️ Kiến Trúc

```
Microsoft Teams (Group Chat)
        ↓ @mention
Copilot Studio Agent
        ↓ Action call
Power Automate Flow
        ↓ HTTP POST
iTop REST API (/webservices/rest.php)
```

### 📁 Cấu Trúc Dự Án

```
├── docs/
│   ├── setup-guide.md               # Hướng dẫn triển khai từng bước
│   └── architecture.md              # Kiến trúc hệ thống chi tiết
├── power-automate/
│   ├── flow1-daily-summary.json     # Flow báo cáo định kỳ (8h/12h/17h)
│   ├── flow2-sla-breach-check.json  # Flow kiểm tra SLA (mỗi 30 phút)
│   └── flow3-ticket-lookup.json     # Flow tra cứu on-demand
├── adaptive-cards/
│   ├── daily-summary-card.json      # Template card báo cáo ngày
│   ├── sla-breach-alert-card.json   # Template card cảnh báo SLA
│   └── ticket-detail-card.json      # Template card chi tiết ticket
└── copilot-studio/
    ├── agent-config.yaml            # Cấu hình agent
    └── topics/
        ├── ticket-lookup.yaml       # Tra cứu theo mã ticket
        ├── my-tickets.yaml          # Xem ticket cá nhân
        ├── today-stats.yaml         # Thống kê tổng hợp
        └── create-ticket.yaml       # Tạo ticket mới
```

### 🚀 Quick Start

1. **Đọc hướng dẫn triển khai:** [`docs/setup-guide.md`](docs/setup-guide.md)
2. **Import flows** vào Power Automate từ thư mục `power-automate/`
3. **Tạo agent** trong Copilot Studio và import topics từ `copilot-studio/topics/`
4. **Publish** và thêm agent vào Teams Group Chat

### 🛠️ Yêu Cầu

- Microsoft 365 (Teams + Power Automate + Copilot Studio)
- iTop 3.0+ với REST API enabled
- Network connectivity: Power Automate → iTop URL
