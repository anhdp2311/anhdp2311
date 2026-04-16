# 📘 Hướng Dẫn Triển Khai NPP Automation

## Mục Lục

1. [Yêu cầu trước khi bắt đầu](#1-yêu-cầu-trước-khi-bắt-đầu)
2. [Giai đoạn 1: Thiết lập SharePoint List](#2-giai-đoạn-1-thiết-lập-sharepoint-list)
3. [Giai đoạn 2: Tạo Power Automate Flows](#3-giai-đoạn-2-tạo-power-automate-flows)
4. [Giai đoạn 3: Cấu hình cảnh báo & báo cáo](#4-giai-đoạn-3-cấu-hình-cảnh-báo--báo-cáo)
5. [Giai đoạn 4: Test & tinh chỉnh](#5-giai-đoạn-4-test--tinh-chỉnh)
6. [Cấu hình nâng cao](#6-cấu-hình-nâng-cao)

---

## 1. Yêu Cầu Trước Khi Bắt Đầu

### License
- **Microsoft 365 Business Basic** trở lên (đã bao gồm Power Automate, SharePoint Online)
- **Power Automate per user** hoặc **Power Automate Premium** (nếu muốn dùng AI Builder)
- **Power BI Free** hoặc **Pro** (nếu muốn tạo dashboard)

### Quyền truy cập
- Quyền tạo SharePoint List trên site cần dùng
- Quyền tạo Power Automate flows
- Quyền đọc email (Outlook connector)

### Công cụ
- **PnP PowerShell** (để chạy script provisioning)
  ```powershell
  Install-Module -Name PnP.PowerShell -Scope CurrentUser
  ```

### Thông tin cần chuẩn bị
- URL SharePoint site: `https://your-tenant.sharepoint.com/sites/your-site`
- Email nhận notification: `your-email@company.com`
- Teams channel ID (nếu muốn notification qua Teams)

---

## 2. Giai Đoạn 1: Thiết Lập SharePoint List

> 💡 **Không chạy được script?** Xem [Hướng dẫn thủ công từng bước](step-by-step-manual-guide.md) – hướng dẫn chi tiết từng click, không cần PowerShell.

### Cách 1: Dùng script tự động (khuyến nghị)

1. Mở PowerShell (Run as Administrator)
2. Chạy script:
   ```powershell
   cd npp-automation/scripts
   ./provision-sharepoint.ps1 -SiteUrl "https://your-tenant.sharepoint.com/sites/your-site"
   ```
3. Đăng nhập bằng tài khoản Microsoft 365 khi được yêu cầu
4. Script sẽ tự động tạo list và các cột

### Cách 2: Tạo thủ công

1. Truy cập SharePoint site
2. Chọn **New** > **List** > **Blank list**
3. Đặt tên: `NPP Account Tracking`
4. Thêm các cột theo bảng sau:

| Tên Cột | Internal Name | Kiểu | Bắt buộc | Giá trị |
|---|---|---|---|---|
| Loại Yêu Cầu | LoaiYeuCau | Choice | Có | Mở mới, Ngưng hoạt động |
| Tên NPP | TenNPP | Single line text | Có | |
| Mã NPP | MaNPP | Single line text | Không | |
| Loại Account | LoaiAccount | Choice | Không | Dùng chung, Dùng riêng |
| Ngày Yêu Cầu | NgayYeuCau | Date | Có | |
| Ngày Hoàn Tất | NgayHoanTat | Date | Không | |
| Trạng Thái | TrangThai | Choice | Có | Đang chờ xử lý, Hoàn tất, Thiếu thông tin |
| Người Yêu Cầu | NguoiYeuCau | Person | Không | |
| Email Người Yêu Cầu | EmailNguoiYeuCau | Text | Không | |
| Conversation ID | ConversationId | Text | Không | |
| Message ID | MessageId | Text | Không | |
| Link Email Gốc | LinkEmailGoc | Hyperlink | Không | |
| Tháng Báo Cáo | ThangBaoCao | Text | Không | Format: yyyy-MM |
| Ghi Chú | GhiChu | Multiple lines | Không | |

5. Tạo các view:
   - **Tất cả yêu cầu** (default view)
   - **Đang chờ xử lý** (filter: Trạng Thái = "Đang chờ xử lý")
   - **Mở mới tháng này** (filter: Loại Yêu Cầu = "Mở mới" AND Ngày Yêu Cầu >= 30 ngày trước)
   - **Ngưng hoạt động tháng này** (filter tương tự)

---

## 3. Giai Đoạn 2: Tạo Power Automate Flows

### Flow 1: Quét email mở mới NPP

1. Truy cập [Power Automate](https://make.powerautomate.com)
2. Chọn **Create** > **Automated cloud flow**
3. Đặt tên: `NPP - Flow 1 - Phát hiện mở mới`
4. Chọn trigger: **When a new email arrives (V3)** (Office 365 Outlook)

**Cấu hình trigger:**
- Folder: Inbox
- Include Attachments: No

**Thêm actions theo thứ tự:**

```
Trigger: When a new email arrives (V3)
│
├── Condition: Check subject keywords
│   Expression (OR):
│   - contains(triggerOutputs()?['body/subject'], 'mở mới NPP')
│   - contains(triggerOutputs()?['body/subject'], 'tạo account NPP')
│   - contains(triggerOutputs()?['body/subject'], 'tạo tài khoản NPP')
│   - contains(triggerOutputs()?['body/subject'], 'yêu cầu mở NPP')
│   - contains(triggerOutputs()?['body/subject'], 'đăng ký NPP')
│   - contains(triggerOutputs()?['body/subject'], 'tạo NPP')
│
│   If yes:
│   ├── Condition: Not a reply (subject doesn't start with "Re:")
│   │   If yes:
│   │   ├── Compose: Extract NPP name from subject
│   │   │   Expression: if(greater(indexOf(subject, ' - '), -1), trim(substring(subject, add(indexOf(subject, ' - '), 3))), subject)
│   │   ├── Create item (SharePoint)
│   │   │   - Site: [Your SharePoint Site]
│   │   │   - List: NPP Account Tracking
│   │   │   - LoaiYeuCau: "Mở mới"
│   │   │   - TenNPP: [Extracted name]
│   │   │   - NgayYeuCau: [Email received date]
│   │   │   - TrangThai: "Đang chờ xử lý"
│   │   │   - EmailNguoiYeuCau: [Sender email]
│   │   │   - ConversationId: [Email conversation ID]
│   │   │   - MessageId: [Email message ID]
│   │   │   - ThangBaoCao: formatDateTime(receivedDateTime, 'yyyy-MM')
│   │   └── [Optional] Post message to Teams channel
│   │
│   If no (is a reply): Do nothing (handled by Flow 3)
│
│   If no (no keywords): Do nothing
```

> 💡 Xem chi tiết cấu trúc flow trong file `flows/flow1-new-npp-request.json`

### Flow 2: Quét email ngưng hoạt động NPP

Tương tự Flow 1, thay đổi:
- Tên: `NPP - Flow 2 - Phát hiện ngưng hoạt động`
- Từ khóa: `"ngưng hoạt động NPP"`, `"khóa account NPP"`, `"hủy NPP"`, `"ngừng NPP"`, `"đóng account NPP"`
- LoaiYeuCau: `"Ngưng hoạt động"`

> 💡 Xem chi tiết trong file `flows/flow2-deactivate-npp.json`

### Flow 3: Xử lý email reply xác nhận

Đây là flow phức tạp nhất, cần xử lý:

1. **Trigger:** When a new email arrives (V3)
2. **Condition 1:** Email là reply (subject bắt đầu bằng "Re:") VÀ chứa từ khóa NPP
3. **Action:** Lấy Conversation ID từ email
4. **Action:** Tìm record trong SharePoint List theo Conversation ID
5. **Condition 2:** Có tìm thấy record không?
6. **Action:** Trích xuất Mã NPP từ body email
7. **Action:** Phát hiện Loại Account (dùng chung/dùng riêng) từ body
8. **Action:** Cập nhật record trong SharePoint:
   - MaNPP: [Extracted code]
   - LoaiAccount: [Detected type]
   - NgayHoanTat: [Email received date hoặc ngày trích xuất]
   - TrangThai: "Hoàn tất" hoặc "Thiếu thông tin"
9. **Condition 3:** Nếu thiếu thông tin → gửi email cảnh báo

> 💡 Xem chi tiết trong file `flows/flow3-reply-confirmation.json`

**Logic trích xuất Mã NPP:**
```
Expression: if(
  greater(indexOf(toLower(bodyPreview), 'mã npp'), -1),
  trim(substring(bodyPreview, add(indexOf(toLower(bodyPreview), 'mã npp'), 8), 20)),
  ''
)
```
*Lưu ý: Cần tinh chỉnh expression dựa trên format email thực tế*

**Logic phát hiện Loại Account:**
```
Expression: if(
  or(contains(toLower(body), 'dùng chung'), contains(toLower(body), 'shared')),
  'Dùng chung',
  if(
    or(contains(toLower(body), 'dùng riêng'), contains(toLower(body), 'dedicated')),
    'Dùng riêng',
    ''
  )
)
```

---

## 4. Giai Đoạn 3: Cấu Hình Cảnh Báo & Báo Cáo

### Flow 4a: Cảnh báo yêu cầu quá hạn (hàng ngày)

1. **Trigger:** Recurrence - Chạy mỗi ngày lúc 9:00 AM (SE Asia Standard Time)
2. **Action:** Lấy items từ SharePoint List có:
   - TrangThai = "Đang chờ xử lý"
   - NgayYeuCau <= 3 ngày trước
3. **Condition:** Có items quá hạn?
4. **Action:** Tạo bảng HTML và gửi email cảnh báo

> 💡 Xem chi tiết trong file `flows/flow4-alerts.json`

### Flow 4b: Weekly Digest (mỗi thứ 2)

1. **Trigger:** Recurrence - Chạy mỗi thứ 2 lúc 8:30 AM
2. **Action:** Lấy danh sách pending + hoàn tất trong tuần
3. **Action:** Tạo bảng tổng hợp và gửi email

### Flow 5: Báo cáo nghiệm thu hàng tháng

1. **Trigger:** Recurrence - Chạy ngày 2 mỗi tháng lúc 8:00 AM
2. **Action:** Lấy tất cả records có ThangBaoCao = tháng trước
3. **Action:** Phân loại: Mở mới vs Ngưng hoạt động
4. **Action:** Tính thống kê tổng hợp
5. **Action:** Tạo bảng HTML chi tiết
6. **Action:** [Optional] Tạo file Excel trên SharePoint
7. **Action:** Gửi email báo cáo

> 💡 Xem chi tiết trong file `flows/flow5-monthly-report.json`

---

## 5. Giai Đoạn 4: Test & Tinh Chỉnh

### Checklist test

- [ ] Gửi email test với tiêu đề "Mở mới NPP - Test Company" → Kiểm tra record được tạo trong SharePoint
- [ ] Gửi email test với tiêu đề "Ngưng hoạt động NPP - Test Company" → Kiểm tra record
- [ ] Reply email test với nội dung chứa "Mã NPP: TEST001, Loại: Dùng riêng" → Kiểm tra record được cập nhật
- [ ] Đợi 3 ngày (hoặc điều chỉnh cutoff date) → Kiểm tra email cảnh báo
- [ ] Chạy test Flow 5 → Kiểm tra email báo cáo

### Tinh chỉnh

1. **Từ khóa tìm kiếm:** Thêm/bớt từ khóa dựa trên email thực tế
2. **Logic trích xuất:** Điều chỉnh expression parse Mã NPP dựa trên format thực
3. **Thời gian cảnh báo:** Điều chỉnh số ngày cutoff (mặc định 3 ngày)
4. **Người nhận báo cáo:** Cập nhật danh sách email recipients

---

## 6. Cấu Hình Nâng Cao

### Sử dụng AI Builder (Power Platform Premium)

Nếu tổ chức có license Premium, có thể thay thế logic parse thủ công bằng AI Builder:

1. Trong Power Automate, thêm action **AI Builder - Extract information from emails**
2. Train model với mẫu email thực tế
3. Model sẽ tự động nhận diện: Tên NPP, Mã NPP, Loại Account, Ngày

### Sử dụng Azure OpenAI (cho email không có format cố định)

1. Tạo Azure OpenAI resource trong Azure Portal
2. Deploy model GPT-4
3. Trong Power Automate, thêm HTTP action gọi Azure OpenAI API:
   ```json
   {
     "messages": [
       {
         "role": "system",
         "content": "Trích xuất thông tin NPP từ email. Trả về JSON: {ten_npp, ma_npp, loai_account, ngay_hoan_tat}"
       },
       {
         "role": "user",
         "content": "[Nội dung email]"
       }
     ]
   }
   ```
4. Parse JSON response và cập nhật SharePoint

### Kết nối Power BI

1. Mở Power BI Desktop
2. Chọn **Get Data** > **SharePoint Online List**
3. Nhập URL SharePoint site
4. Chọn list `NPP Account Tracking`
5. Tạo các visual:
   - Card: Tổng NPP mở mới, ngưng hoạt động
   - Bar chart: Số lượng theo tháng
   - Table: Danh sách chi tiết
   - Slicer: Lọc theo tháng, trạng thái, loại yêu cầu
6. Publish lên Power BI Service
7. Cấu hình Schedule Refresh (hàng ngày)

---

## Cần Hỗ Trợ?

- Xem [Troubleshooting Guide](troubleshooting.md)
- Xem [User Guide](user-guide.md)
