# 🤖 Hướng Dẫn Triển Khai eService Agent

## Mục Lục
1. [Yêu cầu hệ thống](#yêu-cầu-hệ-thống)
2. [Bước 1: Cấu hình iTop API](#bước-1-cấu-hình-itop-api)
3. [Bước 2: Import Power Automate Flows](#bước-2-import-power-automate-flows)
4. [Bước 3: Tạo Agent trong Copilot Studio](#bước-3-tạo-agent-trong-copilot-studio)
5. [Bước 4: Thêm Agent vào Teams Group Chat](#bước-4-thêm-agent-vào-teams-group-chat)
6. [Bước 5: Test và xác nhận](#bước-5-test-và-xác-nhận)
7. [Troubleshooting](#troubleshooting)

---

## Yêu Cầu Hệ Thống

| Thành phần | Yêu cầu |
|-----------|---------|
| Microsoft 365 | License E3/E5 hoặc Teams Essentials |
| Copilot Studio | License riêng hoặc bundled với M365 |
| Power Automate | Included trong M365 |
| iTop | Version 3.0+ với REST API enabled |
| Network | Power Automate có thể kết nối tới iTop URL |

> ⚠️ **Lưu ý:** Nếu iTop đặt trong mạng nội bộ (on-premise), cần cài [On-premises data gateway](https://learn.microsoft.com/en-us/data-integration/gateway/service-gateway-install) và sử dụng connector "HTTP with Azure AD" hoặc custom connector.

---

## Bước 1: Cấu Hình iTop API

### 1.1 Tạo API User trong iTop

1. Đăng nhập iTop với quyền Administrator
2. Vào **Admin Console** → **User Management** → **Create a new Person**
3. Tạo user mới:
   - **Login:** `api_copilot_agent`
   - **Password:** (đặt password mạnh)
   - **Profile:** Nhóm đọc dữ liệu (`Support Agent` hoặc tạo profile riêng)
4. Vào **Admin Console** → **REST Services** → **Enable REST API**
5. Gán profile cho user với quyền:
   - `UserRequest`: Read, List
   - `Incident`: Read, List  
   - `Change`: Read, List
   - `Person`: Read (để lấy thông tin agent)
   - `Team`: Read

### 1.2 Test API Connection

Mở browser và truy cập URL sau (thay `YOUR_ITOP_URL`):

```
https://YOUR_ITOP_URL/webservices/rest.php?version=1.3&auth_user=api_copilot_agent&auth_pwd=YOUR_PASSWORD&json_data={"operation":"core/get","class":"UserRequest","key":"SELECT UserRequest WHERE status != 'closed' LIMIT 5","output_fields":"ref,title,status"}
```

Kết quả mong đợi:
```json
{
  "code": 0,
  "message": "Found: 5",
  "objects": { ... }
}
```

### 1.3 Lấy API Token (Khuyến nghị)

iTop 3.x hỗ trợ token-based authentication:
1. Vào **My Account** → **API Token**
2. Tạo token mới với thời hạn phù hợp
3. Lưu token vào **Azure Key Vault** hoặc **Power Automate Environment Variables**

---

## Bước 2: Import Power Automate Flows

### 2.1 Chuẩn bị

1. Truy cập [Power Automate](https://make.powerautomate.com)
2. Chọn đúng **Environment** của tổ chức

### 2.2 Tạo Environment Variables

Vào **Solutions** → **New Solution** → tạo Solution tên `eService Agent`:

| Variable Name | Value | Loại |
|--------------|-------|------|
| `itop_base_url` | `https://your-itop.company.com` | Text |
| `itop_api_user` | `api_copilot_agent` | Text |
| `itop_api_token` | `[token từ bước 1.3]` | Secret |
| `teams_team_id` | `[ID Teams]` | Text |
| `teams_channel_id` | `[ID Channel]` | Text |

> 💡 **Lấy Teams Team ID và Channel ID:**
> Vào Teams → click (...) trên channel → **Get link to channel** → parse URL:
> `https://teams.microsoft.com/l/channel/[CHANNEL_ID]/...?groupId=[TEAM_ID]`

### 2.3 Import Flow 1 - Daily Summary

1. Vào **My flows** → **Import** → **Import Package**
2. Upload file `power-automate/flow1-daily-summary.json`
3. Cập nhật connections: Microsoft Teams
4. Cập nhật parameters trong flow:
   - `itopBaseUrl`: URL iTop
   - `itopApiUser`: `api_copilot_agent`  
   - `itopApiToken`: Token/Password
   - `teamsTeamId` và `teamsChannelId`
5. **Lưu và bật flow**

> 📅 Flow 1 chạy lúc **8:00, 12:00, 17:00** các ngày trong tuần (múi giờ Hà Nội - SE Asia Standard Time)
> 
> Để thêm lịch 12h và 17h: Duplicate flow và thay đổi giờ trong Recurrence trigger

### 2.4 Import Flow 2 - SLA Breach Check

1. Import file `power-automate/flow2-sla-breach-check.json`
2. Cấu hình giống Flow 1
3. Điều chỉnh ngưỡng cảnh báo:
   - `slaWarningThresholdMinutes`: Mặc định 60 (cảnh báo khi còn 1 giờ)
   - `noUpdateThresholdHours`: Mặc định 4 (cảnh báo ticket P1/P2 không update 4 giờ)
4. **Lưu và bật flow** (chạy mỗi 30 phút)

### 2.5 Import Flow 3 - Ticket Lookup (Quan trọng nhất)

1. Import file `power-automate/flow3-ticket-lookup.json`
2. Cấu hình connections và parameters
3. **Lưu flow**
4. Mở flow → Xem trigger **"When a HTTP request is received"**
5. **Copy HTTP POST URL** (dạng: `https://prod-XX.westus.logic.azure.com:443/workflows/...`)
6. Lưu URL này để dùng trong Copilot Studio

---

## Bước 3: Tạo Agent Trong Copilot Studio

### 3.1 Tạo Agent Mới

1. Truy cập [Copilot Studio](https://copilotstudio.microsoft.com)
2. Click **+ New agent**
3. Chọn **Skip to configure** 
4. Điền thông tin:
   - **Name:** `eService Agent`
   - **Description:** `Trợ lý AI quản lý ticket iTop - Hỗ trợ tra cứu, thông báo SLA và quản lý yêu cầu hỗ trợ`
   - **Instructions:** Paste nội dung từ section dưới đây

### 3.2 System Instructions cho Agent

```
Bạn là eService Agent - trợ lý AI hỗ trợ quản lý ticket hệ thống iTop.

Ngôn ngữ: Trả lời bằng tiếng Việt, có thể hiểu tiếng Anh.

Nhiệm vụ chính:
1. Tra cứu thông tin ticket theo mã số (R-XXXXXX)
2. Hiển thị danh sách ticket cá nhân của user
3. Cung cấp thống kê và báo cáo tổng hợp
4. Cảnh báo về vi phạm SLA
5. Hỗ trợ tạo ticket mới

Quy tắc:
- Luôn xưng là "eService Agent" 
- Không chia sẻ thông tin nhạy cảm của user khác
- Khi không tìm được ticket, hướng dẫn user kiểm tra lại mã
- Ưu tiên dùng Adaptive Cards để hiển thị thông tin trực quan
- Cảnh báo ngay khi phát hiện ticket vi phạm hoặc sắp vi phạm SLA
```

### 3.3 Kết Nối Power Automate Flow

1. Vào tab **Actions** → **+ Add action**
2. Chọn **Call an action** → **Power Automate**
3. Tìm **Flow3 - Ticket Lookup**
4. Cấu hình input/output mapping

### 3.4 Tạo Topics

Import hoặc tạo thủ công các topics từ thư mục `copilot-studio/topics/`:

| File | Topic | Mô tả |
|------|-------|-------|
| `ticket-lookup.yaml` | Tra cứu ticket | Tìm kiếm theo mã |
| `my-tickets.yaml` | Ticket của tôi | Danh sách cá nhân |
| `today-stats.yaml` | Thống kê hôm nay | Dashboard tổng hợp |
| `create-ticket.yaml` | Tạo ticket mới | Tạo yêu cầu mới |

**Cách tạo topic thủ công:**
1. Tab **Topics** → **+ Add topic** → **Create from blank**
2. Tạo trigger phrases từ file YAML
3. Thêm các action nodes theo cấu trúc trong YAML
4. Kết nối Power Automate flow tại node **"Call an action"**

### 3.5 Test Agent

1. Dùng **Test panel** ở góc phải
2. Thử các câu lệnh:
   - `tra cứu R-001234`
   - `ticket của tôi`
   - `thống kê hôm nay`
   - `tạo ticket`

---

## Bước 4: Thêm Agent Vào Teams Group Chat

### 4.1 Publish Agent

1. Click **Publish** → **Publish**
2. Chờ khoảng 2-3 phút để publish hoàn tất

### 4.2 Kết Nối Teams Channel

1. Tab **Channels** → Click **Microsoft Teams**
2. Click **Turn on Teams**
3. Click **Open agent in Teams** để test

### 4.3 Thêm Vào Group Chat

**Phương án 1: Thêm trực tiếp**
1. Mở Group Chat trong Teams
2. Click biểu tượng **người dùng** (Add members)
3. Tìm kiếm `eService Agent`
4. Click **Add**

**Phương án 2: Qua Teams Admin Center** (nếu cần approve)
1. Vào [Teams Admin Center](https://admin.teams.microsoft.com)
2. **Teams apps** → **Manage apps**
3. Tìm agent → **Allow** 

### 4.4 Cấu Hình Trigger Trong Group Chat

Sau khi add vào group chat, agent sẽ phản hồi khi:
- Được **@mention**: `@eService Agent tra cứu R-001234`
- Nhắn tin trực tiếp vào **Direct Message** của agent

---

## Bước 5: Test và Xác Nhận

### Checklist kiểm tra

- [ ] Flow 1 gửi báo cáo đúng giờ (8h/12h/17h)
- [ ] Flow 2 phát hiện và cảnh báo SLA breach
- [ ] Agent trả lời `tra cứu R-XXXXXX` đúng
- [ ] Agent hiển thị `ticket của tôi` theo email đăng nhập Teams
- [ ] Adaptive Cards hiển thị đẹp trong Teams
- [ ] Agent có thể được @mention trong group chat
- [ ] Cảnh báo SLA hiển thị đúng màu/icon

### Test Cases

| Lệnh | Kết quả mong đợi |
|------|-----------------|
| `@eService Agent tra cứu R-001234` | Hiển thị chi tiết ticket |
| `@eService Agent ticket của tôi` | Danh sách ticket của user |
| `@eService Agent thống kê hôm nay` | Dashboard tổng hợp |
| `@eService Agent tạo ticket` | Bắt đầu flow tạo ticket |
| `@eService Agent tìm ticket màn hình` | Tìm kiếm theo từ khóa |
| `@eService Agent R-999999` | Thông báo không tìm thấy |

---

## Troubleshooting

### ❌ Flow không kết nối được iTop

**Nguyên nhân:** iTop nằm trong mạng nội bộ  
**Giải pháp:** 
1. Cài On-premises data gateway
2. Hoặc mở firewall cho Power Automate IP ranges: [https://learn.microsoft.com/en-us/connectors/common/outbound-ip-addresses](https://learn.microsoft.com/en-us/connectors/common/outbound-ip-addresses)

### ❌ Agent không hiểu tiếng Việt

**Nguyên nhân:** Language model chưa được cấu hình đúng  
**Giải pháp:**
1. Trong Agent Settings → Language → thêm `Vietnamese (vi-VN)`
2. Thêm nhiều trigger phrases tiếng Việt hơn vào mỗi topic

### ❌ Adaptive Cards không hiển thị trong Teams

**Nguyên nhân:** Version Adaptive Card không tương thích  
**Giải pháp:** Sử dụng version `1.4` hoặc thấp hơn (Teams hỗ trợ tới 1.5)

### ❌ Flow 3 không trả về dữ liệu

**Nguyên nhân:** iTop API query syntax lỗi  
**Giải pháp:**
1. Test API trực tiếp qua browser
2. Kiểm tra iTop OQL syntax trong flow
3. Xem Flow run history để debug

### ❌ Agent không phản hồi trong Group Chat

**Nguyên nhân:** Teams app chưa được approve bởi admin  
**Giải pháp:**
1. Liên hệ Teams Admin để approve app
2. Hoặc dùng personal bot thay vì group chat bot

---

## Tài Liệu Tham Khảo

- [iTop REST API Documentation](https://www.itophub.io/wiki/page?id=latest%3Aadvancedtopics%3Arest_json)
- [Copilot Studio Documentation](https://learn.microsoft.com/en-us/microsoft-copilot-studio/)
- [Power Automate HTTP Action](https://learn.microsoft.com/en-us/azure/connectors/connectors-native-http)
- [Adaptive Cards Designer](https://adaptivecards.io/designer/)
- [Teams Bot Framework](https://learn.microsoft.com/en-us/microsoftteams/platform/bots/what-are-bots)
