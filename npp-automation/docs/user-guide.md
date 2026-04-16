# 📗 Hướng Dẫn Sử Dụng NPP Automation System

## Mục Lục

1. [Tổng quan](#1-tổng-quan)
2. [Gửi yêu cầu mở mới NPP](#2-gửi-yêu-cầu-mở-mới-npp)
3. [Gửi yêu cầu ngưng hoạt động NPP](#3-gửi-yêu-cầu-ngưng-hoạt-động-npp)
4. [Trả lời xác nhận hoàn tất](#4-trả-lời-xác-nhận-hoàn-tất-dành-cho-it)
5. [Xem trạng thái trên SharePoint](#5-xem-trạng-thái-trên-sharepoint)
6. [Hiểu email cảnh báo & báo cáo](#6-hiểu-email-cảnh-báo--báo-cáo)

---

## 1. Tổng Quan

Hệ thống NPP Automation tự động:
- **Phát hiện** email yêu cầu mở mới / ngưng hoạt động NPP
- **Theo dõi** email reply xác nhận hoàn tất
- **Tổng hợp** dữ liệu vào SharePoint List
- **Cảnh báo** khi yêu cầu chưa được xử lý
- **Tạo báo cáo** nghiệm thu hàng tháng tự động

> ⚠️ **Quan trọng:** Hệ thống hoạt động dựa trên **tiêu đề email** và **conversation thread**. Vui lòng tuân thủ format email để đảm bảo hệ thống nhận diện chính xác.

---

## 2. Gửi Yêu Cầu Mở Mới NPP

### Format tiêu đề email

```
Mở mới NPP - [Tên Nhà Phân Phối]
```

**Ví dụ:**
- `Mở mới NPP - Công ty TNHH ABC`
- `Tạo account NPP - NPP Đại Phát`
- `Yêu cầu mở NPP - Chi nhánh Hà Nội`

### Các từ khóa được nhận diện

Tiêu đề email chứa **một trong** các từ khóa sau sẽ được tự động nhận:
- `mở mới NPP`
- `tạo account NPP`
- `tạo tài khoản NPP`
- `yêu cầu mở NPP`
- `đăng ký NPP`
- `mở NPP mới`
- `tạo NPP`

### Nội dung email

Sử dụng template `email-new-npp-request.html` trong thư mục `templates/`. Điền đầy đủ:
- **Tên NPP** (bắt buộc)
- **Loại Account**: Dùng chung / Dùng riêng
- **Người yêu cầu**
- **Thông tin bổ sung**

### Sau khi gửi

- Hệ thống tự động tạo record trong SharePoint với trạng thái **"Đang chờ xử lý"**
- Bạn có thể kiểm tra trên SharePoint List
- Nếu sau 3 ngày chưa có reply xác nhận, bạn sẽ nhận email nhắc nhở

---

## 3. Gửi Yêu Cầu Ngưng Hoạt Động NPP

### Format tiêu đề email

```
Ngưng hoạt động NPP - [Tên NPP]
```

**Ví dụ:**
- `Ngưng hoạt động NPP - Công ty XYZ`
- `Khóa account NPP - NPP Miền Bắc`
- `Hủy NPP - Chi nhánh Đà Nẵng`

### Các từ khóa được nhận diện

- `ngưng hoạt động NPP`
- `khóa account NPP`
- `hủy NPP`
- `ngừng NPP`
- `tạm ngưng NPP`
- `vô hiệu hóa NPP`
- `đóng account NPP`

---

## 4. Trả Lời Xác Nhận Hoàn Tất (Dành cho IT)

### Quy tắc quan trọng

1. ✅ **PHẢI Reply email gốc** (nhấn Reply, không tạo email mới)
2. ✅ **GIỮ NGUYÊN tiêu đề** (Re: Mở mới NPP - ...)
3. ✅ **GHI RÕ thông tin** trong nội dung reply

### Thông tin cần ghi trong email reply

```
Đã tạo xong account:
- Mã NPP: [MÃ NPP]
- Loại account: [Dùng chung / Dùng riêng]
- Ngày hoàn tất: [DD/MM/YYYY]
```

### Ví dụ reply

```
Xin thông báo đã tạo xong account NPP:
- Mã NPP: NPP2026001
- Loại account: Dùng riêng
- Ngày hoàn tất: 15/03/2026

Trân trọng,
Phòng IT
```

### Từ khóa hệ thống nhận diện

**Loại account:**
- "dùng chung", "shared", "chung" → **Dùng chung**
- "dùng riêng", "dedicated", "riêng" → **Dùng riêng**

**Trạng thái hoàn tất:**
- "đã tạo xong", "đã mở xong", "đã hoàn tất", "đã tạo account"

> Sử dụng template `email-confirmation-reply.html` để đảm bảo format chuẩn

---

## 5. Xem Trạng Thái Trên SharePoint

### Truy cập
Mở link SharePoint List: `[URL SharePoint]/Lists/NPP%20Account%20Tracking`

### Các view có sẵn

| View | Mô tả |
|---|---|
| **Tất cả yêu cầu** | Hiển thị toàn bộ records |
| **Đang chờ xử lý** | Chỉ hiển thị yêu cầu chưa hoàn tất |
| **Mở mới tháng này** | NPP mở mới trong 30 ngày gần nhất |
| **Ngưng hoạt động tháng này** | NPP ngưng trong 30 ngày gần nhất |

### Ý nghĩa trạng thái

| Trạng Thái | Ý Nghĩa | Hành Động |
|---|---|---|
| 🟡 Đang chờ xử lý | Đã nhận yêu cầu, chưa có xác nhận | Chờ IT reply hoặc follow up |
| 🟢 Hoàn tất | Đã trích xuất đủ thông tin từ email reply | Không cần thêm hành động |
| 🔴 Thiếu thông tin | Email reply thiếu mã NPP hoặc loại account | Cập nhật thủ công trên SharePoint |

### Cập nhật thủ công

Nếu hệ thống không trích xuất đủ thông tin, bạn có thể chỉnh sửa trực tiếp trên SharePoint:
1. Click vào record cần sửa
2. Cập nhật: Mã NPP, Loại Account, Ngày Hoàn Tất
3. Đổi Trạng Thái sang "Hoàn tất"
4. Save

---

## 6. Hiểu Email Cảnh Báo & Báo Cáo

### Email cảnh báo quá hạn (hàng ngày, 9:00 AM)

- **Khi nào nhận:** Khi có yêu cầu NPP chờ xử lý > 3 ngày
- **Nội dung:** Danh sách yêu cầu quá hạn
- **Hành động:** Follow up với IT hoặc kiểm tra email reply

### Weekly Digest (thứ 2, 8:30 AM)

- **Khi nào nhận:** Mỗi thứ 2 hàng tuần
- **Nội dung:** Tổng hợp yêu cầu pending + hoàn tất trong tuần

### Báo cáo hàng tháng (ngày 2, 8:00 AM)

- **Khi nào nhận:** Ngày 2 mỗi tháng
- **Nội dung:** Báo cáo nghiệm thu đầy đủ tháng trước
  - Thống kê tổng quan
  - Danh sách NPP mở mới
  - Danh sách NPP ngưng hoạt động
  - Link SharePoint để xem chi tiết

---

## FAQ

**Q: Tôi gửi email nhưng không thấy record trên SharePoint?**
- Kiểm tra tiêu đề email có chứa từ khóa đúng không
- Kiểm tra email có phải Reply (Re:) không - nếu là email gốc mà tiêu đề bắt đầu bằng "Re:" thì hệ thống sẽ bỏ qua
- Chờ 1-2 phút vì Power Automate có độ trễ

**Q: Record có trạng thái "Thiếu thông tin" - phải làm gì?**
- Mở record trên SharePoint
- Điền thủ công: Mã NPP, Loại Account, Ngày Hoàn Tất
- Đổi trạng thái sang "Hoàn tất"

**Q: Tôi muốn thêm từ khóa mới?**
- Liên hệ admin Power Automate
- Hoặc xem hướng dẫn trong [Deployment Guide](deployment-guide.md)
