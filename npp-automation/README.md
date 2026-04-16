# 🏢 Tự Động Hóa Thu Thập Thông Tin Account NPP Từ Email Microsoft 365

## Tổng Quan

Giải pháp tự động hóa quy trình thu thập thông tin account Nhà Phân Phối (NPP) từ email Microsoft 365, sử dụng hoàn toàn hệ sinh thái Microsoft 365:

- **Power Automate** – Tự động quét và phân loại email
- **SharePoint List** – Lưu trữ và tổng hợp dữ liệu
- **Power BI / Excel** – Báo cáo nghiệm thu hàng tháng

## Kiến Trúc

```
Microsoft Outlook 365
        │
        ▼
  Power Automate (Flow)
   ┌────┴────┐
   │ Flow 1  │  ── Quét email mở mới NPP
   │ Flow 2  │  ── Quét email ngưng hoạt động NPP
   │ Flow 3  │  ── Quét email trả lời (xác nhận hoàn tất)
   │ Flow 4  │  ── Cảnh báo & nhắc nhở
   │ Flow 5  │  ── Báo cáo hàng tháng
   └────┬────┘
        │
        ▼
  SharePoint List
  (Bảng tổng hợp thông tin NPP)
        │
        ▼
  Power BI / Excel Report
  (Báo cáo nghiệm thu hàng tháng)
```

## Cấu Trúc Dự Án

```
npp-automation/
├── README.md                        # File này
├── docs/
│   ├── deployment-guide.md          # Hướng dẫn triển khai chi tiết
│   ├── user-guide.md                # Hướng dẫn sử dụng
│   └── troubleshooting.md           # Xử lý sự cố
├── flows/
│   ├── flow1-new-npp-request.json   # Flow quét email mở mới NPP
│   ├── flow2-deactivate-npp.json    # Flow quét email ngưng hoạt động
│   ├── flow3-reply-confirmation.json # Flow xử lý email xác nhận
│   ├── flow4-alerts.json            # Flow cảnh báo & nhắc nhở
│   └── flow5-monthly-report.json    # Flow báo cáo hàng tháng
├── scripts/
│   ├── provision-sharepoint.ps1     # Script tạo SharePoint List
│   └── import-flows.ps1            # Script import flows vào Power Automate
├── templates/
│   ├── email-new-npp-request.html   # Template email yêu cầu mở mới
│   ├── email-deactivate-request.html # Template email yêu cầu ngưng
│   └── email-confirmation-reply.html # Template email xác nhận hoàn tất
└── reports/
    └── monthly-report-template.md   # Mẫu báo cáo nghiệm thu
```

## Yêu Cầu Hệ Thống

| Thành phần | Yêu cầu |
|---|---|
| Microsoft 365 | Business Basic trở lên |
| Power Automate | Có sẵn trong M365 license |
| SharePoint Online | Có sẵn trong M365 license |
| Power BI (tùy chọn) | Free hoặc Pro |
| PnP PowerShell | Để chạy script provisioning |

## Bắt Đầu Nhanh

1. **Provision SharePoint List:**
   ```powershell
   ./scripts/provision-sharepoint.ps1 -SiteUrl "https://your-tenant.sharepoint.com/sites/your-site"
   ```

2. **Import Power Automate Flows:** Xem [Hướng dẫn triển khai](docs/deployment-guide.md)

3. **Cấu hình email templates:** Phân phối các template trong thư mục `templates/` cho team

## Tài Liệu

- [📖 **Hướng dẫn thủ công từng bước (KHÔNG cần script)**](docs/step-by-step-manual-guide.md) ⭐ Dành cho môi trường công ty
- [📘 Hướng dẫn triển khai (dùng script)](docs/deployment-guide.md)
- [📗 Hướng dẫn sử dụng](docs/user-guide.md)
- [🔧 Xử lý sự cố](docs/troubleshooting.md)
