<#
.SYNOPSIS
    Hướng dẫn import Power Automate flows từ file JSON.

.DESCRIPTION
    Script này hướng dẫn các bước import flow definitions vào Power Automate.
    Hiện tại Power Automate không hỗ trợ import trực tiếp qua API công khai
    nên script này cung cấp hướng dẫn step-by-step.

.NOTES
    Các file flow JSON trong thư mục flows/ chứa cấu trúc logic của flow.
    Bạn cần tạo flow thủ công trong Power Automate theo cấu trúc này,
    hoặc sử dụng Power Automate Management connector.
#>

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  HƯỚNG DẪN IMPORT POWER AUTOMATE FLOWS" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Các file flow definition nằm trong thư mục flows/:" -ForegroundColor White
Write-Host "  1. flow1-new-npp-request.json    - Quét email mở mới NPP" -ForegroundColor Yellow
Write-Host "  2. flow2-deactivate-npp.json     - Quét email ngưng hoạt động" -ForegroundColor Yellow
Write-Host "  3. flow3-reply-confirmation.json  - Xử lý email xác nhận" -ForegroundColor Yellow
Write-Host "  4. flow4-alerts.json             - Cảnh báo & nhắc nhở" -ForegroundColor Yellow
Write-Host "  5. flow5-monthly-report.json     - Báo cáo hàng tháng" -ForegroundColor Yellow
Write-Host ""
Write-Host "CÁCH 1: Import qua Power Automate Portal" -ForegroundColor Green
Write-Host "  1. Truy cập https://make.powerautomate.com" -ForegroundColor White
Write-Host "  2. Chọn 'My flows' > 'Import' > 'Import Package (Legacy)'" -ForegroundColor White
Write-Host "  3. Upload từng file .json" -ForegroundColor White
Write-Host "  4. Cấu hình connections (Outlook 365, SharePoint)" -ForegroundColor White
Write-Host "  5. Cập nhật SharePoint site URL và list name trong mỗi flow" -ForegroundColor White
Write-Host ""
Write-Host "CÁCH 2: Tạo thủ công theo cấu trúc flow" -ForegroundColor Green
Write-Host "  1. Mở từng file .json để xem cấu trúc logic" -ForegroundColor White
Write-Host "  2. Tạo flow mới trong Power Automate" -ForegroundColor White
Write-Host "  3. Thêm trigger và actions theo mô tả trong file" -ForegroundColor White
Write-Host "  4. Xem docs/deployment-guide.md để biết chi tiết" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  SAU KHI IMPORT, CẦN CẬP NHẬT:" -ForegroundColor Red
Write-Host "  - SharePoint Site URL" -ForegroundColor White
Write-Host "  - SharePoint List Name (mặc định: 'NPP Account Tracking')" -ForegroundColor White
Write-Host "  - Email connections" -ForegroundColor White
Write-Host "  - Notification recipients" -ForegroundColor White
Write-Host "============================================================" -ForegroundColor Cyan
