# 🔧 Xử Lý Sự Cố NPP Automation

## Mục Lục

1. [Flow không chạy](#1-flow-không-chạy)
2. [Record không được tạo trên SharePoint](#2-record-không-được-tạo-trên-sharepoint)
3. [Thông tin trích xuất sai](#3-thông-tin-trích-xuất-sai)
4. [Email reply không cập nhật record](#4-email-reply-không-cập-nhật-record)
5. [Cảnh báo / Báo cáo không gửi](#5-cảnh-báo--báo-cáo-không-gửi)
6. [Lỗi kết nối](#6-lỗi-kết-nối)
7. [Kiểm tra log flow](#7-kiểm-tra-log-flow)

---

## 1. Flow Không Chạy

### Triệu chứng
- Gửi email nhưng không có record mới trên SharePoint
- Flow không có run history gần đây

### Nguyên nhân & giải pháp

| Nguyên nhân | Giải pháp |
|---|---|
| Flow bị tắt (Off) | Vào Power Automate > My flows > Bật flow |
| Connection bị expire | Vào flow > Edit > Fix connection |
| License hết hạn | Kiểm tra M365 license |
| Trigger bị lỗi | Xóa trigger và tạo lại |

### Cách kiểm tra
1. Vào [Power Automate](https://make.powerautomate.com)
2. Chọn **My flows**
3. Kiểm tra trạng thái flow (On/Off)
4. Xem **Run history** để biết flow có được trigger không

---

## 2. Record Không Được Tạo Trên SharePoint

### Triệu chứng
- Flow đã chạy (có trong run history) nhưng không tạo record

### Nguyên nhân & giải pháp

| Nguyên nhân | Giải pháp |
|---|---|
| Tiêu đề email không chứa từ khóa | Kiểm tra từ khóa trong tiêu đề email |
| Email bị filter là Reply (Re:) | Email gốc không nên bắt đầu bằng "Re:" |
| SharePoint connection lỗi | Cập nhật connection trong flow |
| SharePoint List URL sai | Kiểm tra URL trong flow config |
| Field required thiếu giá trị | Kiểm tra log lỗi trong run history |

### Cách debug
1. Vào flow > **Run history**
2. Click vào run gần nhất
3. Xem step nào **failed** (đỏ)
4. Click vào step failed để xem error message

---

## 3. Thông Tin Trích Xuất Sai

### Triệu chứng
- Tên NPP sai trên SharePoint
- Mã NPP trích xuất không đúng

### Nguyên nhân
- Format email không khớp với logic parse
- Tiêu đề email không theo format chuẩn "Keyword - Tên NPP"

### Giải pháp

**Cho tên NPP:**
- Đảm bảo tiêu đề email theo format: `Mở mới NPP - [Tên NPP]`
- Dấu ` - ` (space dash space) được dùng làm separator

**Cho mã NPP (Flow 3):**
- Email reply phải chứa text `Mã NPP: [code]`
- Expression hiện tại tìm 20 ký tự sau "mã npp"
- Nếu format khác, cần điều chỉnh expression trong Flow 3

**Tùy chỉnh logic parse:**
1. Mở flow cần sửa trong Power Automate
2. Tìm action "Extract" hoặc "Compose"
3. Sửa expression cho phù hợp format email thực

---

## 4. Email Reply Không Cập Nhật Record

### Triệu chứng
- IT đã reply email nhưng record SharePoint vẫn ở trạng thái "Đang chờ xử lý"

### Checklist kiểm tra

- [ ] Email reply có phải Reply thực sự không? (Reply, không phải Forward hoặc email mới)
- [ ] Tiêu đề có bắt đầu bằng "Re:" không?
- [ ] Tiêu đề có chứa từ "NPP" hoặc "account" hoặc "nhà phân phối" không?
- [ ] Conversation ID có match không? (kiểm tra trong SharePoint)
- [ ] Flow 3 có đang bật không?

### Nguyên nhân thường gặp

| Nguyên nhân | Giải pháp |
|---|---|
| Reply từ email khác (Forward) | Yêu cầu Reply email gốc |
| Tiêu đề bị sửa | Giữ nguyên tiêu đề khi reply |
| Conversation ID không match | Kiểm tra Outlook thread |
| Flow 3 filter quá strict | Nới lỏng điều kiện filter |

### Workaround
Nếu hệ thống không tự cập nhật, có thể cập nhật thủ công trên SharePoint:
1. Mở SharePoint List
2. Tìm record tương ứng
3. Cập nhật: Mã NPP, Loại Account, Ngày Hoàn Tất, Trạng Thái

---

## 5. Cảnh Báo / Báo Cáo Không Gửi

### Triệu chứng
- Không nhận được email cảnh báo hàng ngày
- Không nhận được weekly digest
- Không nhận được báo cáo hàng tháng

### Kiểm tra

1. **Flow có đang bật không?** Kiểm tra Flow 4 và Flow 5
2. **Recurrence trigger đúng không?**
   - Flow 4a: Mỗi ngày 9:00 AM
   - Flow 4b: Mỗi thứ 2 8:30 AM
   - Flow 5: Ngày 2 mỗi tháng 8:00 AM
3. **Timezone đúng không?** Phải là "SE Asia Standard Time" (UTC+7)
4. **Email recipient đúng không?** Kiểm tra email address trong flow
5. **Có data để báo cáo không?** Nếu không có yêu cầu quá hạn, Flow 4a sẽ không gửi email

---

## 6. Lỗi Kết Nối

### Outlook Connection

**Lỗi: "The connection is not valid"**
1. Vào flow > Edit
2. Click vào trigger hoặc action bị lỗi
3. Click **Fix connection** hoặc **Change connection**
4. Đăng nhập lại

### SharePoint Connection

**Lỗi: "Access denied" hoặc "List not found"**
1. Kiểm tra URL SharePoint site trong flow
2. Kiểm tra tên list (phải đúng: "NPP Account Tracking")
3. Kiểm tra quyền truy cập SharePoint site

### Teams Connection

**Lỗi: "Channel not found"**
1. Kiểm tra Team ID và Channel ID trong flow
2. Đảm bảo account có quyền post vào channel

---

## 7. Kiểm Tra Log Flow

### Cách xem Run History

1. Truy cập [Power Automate](https://make.powerautomate.com)
2. Chọn **My flows**
3. Click vào flow cần kiểm tra
4. Xem tab **Run history** (hoặc **28-day run history**)
5. Click vào một run để xem chi tiết từng step

### Ý nghĩa trạng thái

| Trạng thái | Icon | Ý nghĩa |
|---|---|---|
| Succeeded | ✅ | Flow chạy thành công |
| Failed | ❌ | Flow bị lỗi - click để xem chi tiết |
| Cancelled | ⚪ | Flow bị hủy |
| Skipped | ⏭️ | Action bị skip do condition không thỏa |

### Xuất log để phân tích

1. Trong run detail, click **Download CSV** (nếu có)
2. Hoặc chụp screenshot các step bị lỗi
3. Ghi chú: Timestamp, Error message, Input/Output values

---

## Liên Hệ Hỗ Trợ

Nếu các bước trên không giải quyết được vấn đề:
1. Kiểm tra [Deployment Guide](deployment-guide.md) để đảm bảo cấu hình đúng
2. Liên hệ admin Power Automate của tổ chức
3. Tham khảo [Power Automate Documentation](https://learn.microsoft.com/en-us/power-automate/)
