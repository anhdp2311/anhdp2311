# 📖 HƯỚNG DẪN THỦ CÔNG TỪNG BƯỚC - KHÔNG CẦN CHẠY SCRIPT

> **Dành cho môi trường công ty không cho phép chạy PowerShell script.**
> Tất cả các bước đều thực hiện trên trình duyệt web (Edge/Chrome).

---

## 📑 MỤC LỤC

| Phần | Nội dung | Thời gian ước tính |
|------|----------|--------------------|
| [PHẦN A](#phần-a-tạo-sharepoint-list) | Tạo SharePoint List | ~15 phút |
| [PHẦN B](#phần-b-tạo-các-view-cho-list) | Tạo các View cho List | ~10 phút |
| [PHẦN C](#phần-c-tạo-flow-1--quét-email-mở-mới-npp) | Flow 1 – Quét email mở mới NPP | ~20 phút |
| [PHẦN D](#phần-d-tạo-flow-2--quét-email-ngưng-hoạt-động-npp) | Flow 2 – Quét email ngưng hoạt động NPP | ~10 phút |
| [PHẦN E](#phần-e-tạo-flow-3--xử-lý-email-reply-xác-nhận) | Flow 3 – Xử lý email reply xác nhận | ~30 phút |
| [PHẦN F](#phần-f-tạo-flow-4a--cảnh-báo-quá-hạn-hàng-ngày) | Flow 4a – Cảnh báo quá hạn | ~15 phút |
| [PHẦN G](#phần-g-tạo-flow-4b--weekly-digest-mỗi-thứ-2) | Flow 4b – Weekly Digest | ~15 phút |
| [PHẦN H](#phần-h-tạo-flow-5--báo-cáo-nghiệm-thu-hàng-tháng) | Flow 5 – Báo cáo hàng tháng | ~20 phút |
| [PHẦN I](#phần-i-test-hệ-thống) | Test hệ thống | ~15 phút |

**Tổng thời gian: ~2.5 giờ** (lần đầu setup, sau đó không cần làm lại)

---

## PHẦN A: TẠO SHAREPOINT LIST

### Bước A1: Mở SharePoint Site

1. Mở trình duyệt, vào: `https://TEN-CONG-TY.sharepoint.com`
2. Tìm và click vào **site** bạn muốn tạo list (VD: "Operations", "IT", hoặc site team của bạn)
3. Nếu chưa có site, hỏi IT admin tạo giúp một **Team Site**

### Bước A2: Tạo List mới

1. Ở trang chủ SharePoint site, click **⚙️ Settings** (bánh răng góc phải trên)
2. Chọn **Site contents**
3. Click **+ New** → **List**
4. Chọn **Blank list**
5. Nhập tên: `NPP Account Tracking`
6. Mô tả (tùy chọn): `Bảng theo dõi account NPP tự động từ email`
7. Click **Create**

### Bước A3: Thêm cột "Loại Yêu Cầu"

1. Trong list vừa tạo, click **+ Add column** (góc phải header)
2. Chọn **Choice**
3. Điền:
   - **Name:** `Loại Yêu Cầu`
   - **Choices:**
     - Gõ `Mở mới` rồi Enter
     - Gõ `Ngưng hoạt động` rồi Enter
   - **Require that this column contains information:** ✅ Bật (Yes)
   - **Default value:** Để trống
4. Click **Save**

### Bước A4: Thêm cột "Tên NPP"

1. Click **+ Add column** → **Single line of text**
2. Điền:
   - **Name:** `Tên NPP`
   - **Require that this column contains information:** ✅ Bật (Yes)
3. Click **Save**

### Bước A5: Thêm cột "Mã NPP"

1. Click **+ Add column** → **Single line of text**
2. Điền:
   - **Name:** `Mã NPP`
   - **Require:** Không bắt buộc (để tắt)
3. Click **Save**

### Bước A6: Thêm cột "Loại Account"

1. Click **+ Add column** → **Choice**
2. Điền:
   - **Name:** `Loại Account`
   - **Choices:**
     - Gõ `Dùng chung` rồi Enter
     - Gõ `Dùng riêng` rồi Enter
   - **Require:** Không bắt buộc
3. Click **Save**

### Bước A7: Thêm cột "Ngày Yêu Cầu"

1. Click **+ Add column** → **Date and time**
2. Điền:
   - **Name:** `Ngày Yêu Cầu`
   - **Include time:** Không (chỉ Date)
   - **Require that this column contains information:** ✅ Bật (Yes)
3. Click **Save**

### Bước A8: Thêm cột "Ngày Hoàn Tất"

1. Click **+ Add column** → **Date and time**
2. Điền:
   - **Name:** `Ngày Hoàn Tất`
   - **Include time:** Không
   - **Require:** Không bắt buộc
3. Click **Save**

### Bước A9: Thêm cột "Trạng Thái"

1. Click **+ Add column** → **Choice**
2. Điền:
   - **Name:** `Trạng Thái`
   - **Choices:**
     - Gõ `Đang chờ xử lý` rồi Enter
     - Gõ `Hoàn tất` rồi Enter
     - Gõ `Thiếu thông tin` rồi Enter
   - **Default value:** Chọn `Đang chờ xử lý`
   - **Require that this column contains information:** ✅ Bật (Yes)
3. Click **Save**

### Bước A10: Thêm cột "Email Người Yêu Cầu"

1. Click **+ Add column** → **Single line of text**
2. Điền:
   - **Name:** `Email Người Yêu Cầu`
   - **Require:** Không bắt buộc
3. Click **Save**

### Bước A11: Thêm cột "Conversation ID"

1. Click **+ Add column** → **Single line of text**
2. Điền:
   - **Name:** `Conversation ID`
   - **Require:** Không bắt buộc
3. Click **Save**

> 💡 **Mẹo:** Cột này rất quan trọng! Nó dùng để liên kết email yêu cầu với email xác nhận.

### Bước A12: Thêm cột "Message ID"

1. Click **+ Add column** → **Single line of text**
2. Điền:
   - **Name:** `Message ID`
   - **Require:** Không bắt buộc
3. Click **Save**

### Bước A13: Thêm cột "Link Email Gốc"

1. Click **+ Add column** → **Hyperlink**
2. Điền:
   - **Name:** `Link Email Gốc`
3. Click **Save**

### Bước A14: Thêm cột "Tháng Báo Cáo"

1. Click **+ Add column** → **Single line of text**
2. Điền:
   - **Name:** `Tháng Báo Cáo`
   - **Description (mô tả):** `Format: yyyy-MM (ví dụ: 2026-04)`
3. Click **Save**

### Bước A15: Thêm cột "Ghi Chú"

1. Click **+ Add column** → **Multiple lines of text**
2. Điền:
   - **Name:** `Ghi Chú`
   - **Use enhanced rich text:** Không cần
3. Click **Save**

### ✅ Kiểm tra: List bây giờ phải có các cột sau:

| # | Tên Cột | Loại |
|---|---------|------|
| 1 | Title (có sẵn) | Text |
| 2 | Loại Yêu Cầu | Choice |
| 3 | Tên NPP | Text |
| 4 | Mã NPP | Text |
| 5 | Loại Account | Choice |
| 6 | Ngày Yêu Cầu | Date |
| 7 | Ngày Hoàn Tất | Date |
| 8 | Trạng Thái | Choice |
| 9 | Email Người Yêu Cầu | Text |
| 10 | Conversation ID | Text |
| 11 | Message ID | Text |
| 12 | Link Email Gốc | Hyperlink |
| 13 | Tháng Báo Cáo | Text |
| 14 | Ghi Chú | Multiple lines |

> 💡 Cột "Title" là cột mặc định của SharePoint, có thể ẩn đi hoặc để trống.

---

## PHẦN B: TẠO CÁC VIEW CHO LIST

### Bước B1: Tạo View "Đang chờ xử lý"

1. Trong SharePoint List, click vào dropdown **All Items ▾** (góc trái trên, cạnh tên list)
2. Chọn **Create new view**
3. Đặt tên: `Đang chờ xử lý`
4. Chọn kiểu view: **List**
5. Trong phần **Columns**, chọn hiển thị:
   - ☑️ Loại Yêu Cầu
   - ☑️ Tên NPP
   - ☑️ Ngày Yêu Cầu
   - ☑️ Trạng Thái
   - ☑️ Email Người Yêu Cầu
6. Trong phần **Filter**, thiết lập:
   - **Show items only when the following is true:**
   - Column: `Trạng Thái` | is equal to | `Đang chờ xử lý`
7. Click **OK** hoặc **Save**

### Bước B2: Tạo View "Mở mới tháng này"

1. Click dropdown view → **Create new view**
2. Đặt tên: `Mở mới tháng này`
3. Columns hiển thị:
   - ☑️ Tên NPP, Mã NPP, Loại Account, Ngày Yêu Cầu, Ngày Hoàn Tất, Trạng Thái
4. Filter:
   - `Loại Yêu Cầu` is equal to `Mở mới`
   - AND `Ngày Yêu Cầu` is greater than or equal to `[Today]-30`
5. Sort: `Ngày Yêu Cầu` descending (mới nhất lên trên)
6. Click **Save**

### Bước B3: Tạo View "Ngưng hoạt động tháng này"

1. Tương tự Bước B2, thay đổi:
   - Tên: `Ngưng hoạt động tháng này`
   - Filter: `Loại Yêu Cầu` is equal to `Ngưng hoạt động`
2. Click **Save**

---

## PHẦN C: TẠO FLOW 1 – QUÉT EMAIL MỞ MỚI NPP

### Bước C1: Mở Power Automate

1. Mở trình duyệt, vào: **https://make.powerautomate.com**
2. Đăng nhập bằng tài khoản Microsoft 365 công ty

### Bước C2: Tạo Flow mới

1. Ở menu bên trái, click **+ Create**
2. Chọn **Automated cloud flow**
3. Điền:
   - **Flow name:** `NPP - Flow 1 - Phát hiện mở mới`
   - **Choose your flow's trigger:** tìm và chọn **"When a new email arrives (V3)"** (Office 365 Outlook)
4. Click **Create**

### Bước C3: Cấu hình Trigger

Trong trigger **"When a new email arrives (V3)"**:

1. Click vào trigger để mở cấu hình
2. Thiết lập:
   - **Folder:** Inbox
   - **To:** (để trống - nhận tất cả)
   - **From:** (để trống)
   - **Include Attachments:** No
   - **Subject Filter:** (để trống - sẽ filter bằng Condition)
   - **Importance:** Any

### Bước C4: Thêm Condition kiểm tra từ khóa

1. Click **+ New step**
2. Tìm và chọn **Condition** (Control)
3. Ở mục **Choose a value** bên trái, click vào ô → chọn tab **Expression** → gõ:

```
toLower(triggerOutputs()?['body/subject'])
```

4. Nhấn **OK**
5. Operator: chọn **contains**
6. Ở ô bên phải, gõ: `mở mới npp`

> ⚠️ **QUAN TRỌNG:** Vì cần kiểm tra NHIỀU từ khóa, ta cần dùng cách khác:

**Cách làm đúng cho nhiều từ khóa:**

1. **Xóa** condition vừa tạo
2. Click **+ New step** → tìm **Condition**
3. Click vào chữ **"Or"** ở góc trên phải của Condition (mặc định là "And")
4. Đổi thành **Or**
5. Thêm **hàng 1:**
   - Choose a value: click **Expression** → gõ `toLower(triggerOutputs()?['body/subject'])` → OK
   - Operator: **contains**
   - Value: `mở mới npp`
6. Click **+ Add** → **Add row** để thêm hàng mới
7. Thêm **hàng 2:**
   - Expression: `toLower(triggerOutputs()?['body/subject'])`
   - contains
   - `tạo account npp`
8. Thêm **hàng 3:**
   - Expression: `toLower(triggerOutputs()?['body/subject'])`
   - contains
   - `tạo tài khoản npp`
9. Thêm **hàng 4:**
   - Expression: `toLower(triggerOutputs()?['body/subject'])`
   - contains
   - `yêu cầu mở npp`
10. Thêm **hàng 5:**
    - Expression: `toLower(triggerOutputs()?['body/subject'])`
    - contains
    - `đăng ký npp`
11. Thêm **hàng 6:**
    - Expression: `toLower(triggerOutputs()?['body/subject'])`
    - contains
    - `tạo npp`

### Bước C5: Thêm Condition lọc bỏ Reply (trong nhánh If yes)

1. Trong nhánh **If yes** của Condition trên
2. Click **Add an action**
3. Tìm và chọn **Condition**
4. Thiết lập:
   - Choose a value: Expression → `toLower(triggerOutputs()?['body/subject'])`
   - Operator: **does not start with**
   - Value: `re:`

### Bước C6: Thêm action Compose trích xuất tên NPP (trong If yes → If yes)

1. Trong nhánh **If yes** (bên trong, lọc bỏ reply)
2. Click **Add an action**
3. Tìm **Compose** (Data Operation)
4. Trong ô **Inputs**, click **Expression** và paste:

```
if(greater(indexOf(triggerOutputs()?['body/subject'], ' - '), -1), trim(substring(triggerOutputs()?['body/subject'], add(indexOf(triggerOutputs()?['body/subject'], ' - '), 3))), triggerOutputs()?['body/subject'])
```

5. Click **OK**
6. Đổi tên action (click "..." → Rename): `Extract_NPP_Name`

> 💡 Expression này tách tên NPP từ tiêu đề. VD: "Mở mới NPP - Công ty ABC" → "Công ty ABC"

### Bước C7: Thêm action tạo record SharePoint

1. Tiếp tục trong nhánh **If yes**
2. Click **Add an action**
3. Tìm **Create item** (SharePoint)
4. Cấu hình:
   - **Site Address:** Chọn SharePoint site của bạn từ dropdown
   - **List Name:** Chọn `NPP Account Tracking`
5. Sau khi chọn list, các field sẽ hiện ra. Điền như sau:

| Field | Giá trị | Cách nhập |
|-------|---------|-----------|
| **Title** | (để trống hoặc gõ "Auto") | Gõ text |
| **Loại Yêu Cầu Value** | `Mở mới` | Gõ text |
| **Tên NPP** | Click Dynamic content → chọn **Outputs** từ action `Extract_NPP_Name` | Dynamic content |
| **Ngày Yêu Cầu** | Click Dynamic content → chọn **Received Time** từ trigger | Dynamic content |
| **Trạng Thái Value** | `Đang chờ xử lý` | Gõ text |
| **Email Người Yêu Cầu** | Click Dynamic content → chọn **From** từ trigger | Dynamic content |
| **Conversation ID** | Click Dynamic content → chọn **Conversation ID** từ trigger | Dynamic content |
| **Message ID** | Click Dynamic content → chọn **Message ID** từ trigger | Dynamic content |
| **Tháng Báo Cáo** | Click **Expression** → gõ: `formatDateTime(triggerOutputs()?['body/receivedDateTime'], 'yyyy-MM')` | Expression |
| **Ghi Chú** | Click **Expression** → gõ: `concat('Tự động tạo từ email: ', triggerOutputs()?['body/subject'])` | Expression |

6. Cho **Link Email Gốc** (nếu field hiện ra):
   - Description: `Email gốc`
   - URL: Expression → `concat('https://outlook.office365.com/mail/inbox/id/', triggerOutputs()?['body/id'])`

### Bước C8: Save và Test

1. Click **Save** (góc phải trên)
2. Click **Test** → **Manually** → **Test**
3. Gửi một email test đến inbox của bạn với tiêu đề: `Mở mới NPP - Công ty Test ABC`
4. Quay lại Power Automate xem flow có chạy thành công không
5. Kiểm tra SharePoint List có record mới không

---

## PHẦN D: TẠO FLOW 2 – QUÉT EMAIL NGƯNG HOẠT ĐỘNG NPP

> Flow 2 gần giống hệt Flow 1, chỉ thay đổi từ khóa và loại yêu cầu.

### Bước D1: Tạo Flow mới

1. Vào Power Automate → **+ Create** → **Automated cloud flow**
2. Tên: `NPP - Flow 2 - Phát hiện ngưng hoạt động`
3. Trigger: **When a new email arrives (V3)**

### Bước D2: Cấu hình Condition từ khóa

Tương tự Bước C4, nhưng thay đổi từ khóa:

| Hàng | Expression | Operator | Value |
|------|-----------|----------|-------|
| 1 | `toLower(triggerOutputs()?['body/subject'])` | contains | `ngưng hoạt động npp` |
| 2 | `toLower(triggerOutputs()?['body/subject'])` | contains | `khóa account npp` |
| 3 | `toLower(triggerOutputs()?['body/subject'])` | contains | `hủy npp` |
| 4 | `toLower(triggerOutputs()?['body/subject'])` | contains | `ngừng npp` |
| 5 | `toLower(triggerOutputs()?['body/subject'])` | contains | `tạm ngưng npp` |
| 6 | `toLower(triggerOutputs()?['body/subject'])` | contains | `đóng account npp` |

Nhớ chọn **Or** cho condition!

### Bước D3: Các bước còn lại

Giống Flow 1, chỉ thay đổi:
- **Loại Yêu Cầu Value:** `Ngưng hoạt động` (thay vì "Mở mới")
- Phần còn lại giữ nguyên

### Bước D4: Save và Test

Gửi email test: `Ngưng hoạt động NPP - Công ty Test XYZ`

---

## PHẦN E: TẠO FLOW 3 – XỬ LÝ EMAIL REPLY XÁC NHẬN

> ⚠️ **Đây là flow phức tạp nhất.** Hãy đọc kỹ từng bước.

### Bước E1: Tạo Flow mới

1. Power Automate → **+ Create** → **Automated cloud flow**
2. Tên: `NPP - Flow 3 - Xử lý reply xác nhận`
3. Trigger: **When a new email arrives (V3)**

### Bước E2: Condition 1 – Kiểm tra email là Reply về NPP

1. **+ New step** → **Condition**
2. Chọn **And** (giữ mặc định)
3. **Hàng 1** (kiểm tra bắt đầu bằng "Re:"):
   - Choose a value: Expression → `toLower(triggerOutputs()?['body/subject'])`
   - Operator: **starts with**
   - Value: `re:`
4. Click **+ Add** → **Add group**
5. Trong group mới, đổi thành **Or**
6. Thêm các hàng trong group:

| Hàng | Expression | Operator | Value |
|------|-----------|----------|-------|
| 1 | `toLower(triggerOutputs()?['body/subject'])` | contains | `npp` |
| 2 | `toLower(triggerOutputs()?['body/subject'])` | contains | `account` |
| 3 | `toLower(triggerOutputs()?['body/subject'])` | contains | `nhà phân phối` |

> Kết quả: Email bắt đầu bằng "Re:" VÀ (chứa "npp" HOẶC "account" HOẶC "nhà phân phối")

### Bước E3: Tìm record trong SharePoint (trong If yes)

1. Trong nhánh **If yes**
2. **Add an action** → tìm **Get items** (SharePoint)
3. Cấu hình:
   - **Site Address:** Chọn SharePoint site
   - **List Name:** `NPP Account Tracking`
   - **Filter Query:** click vào ô và gõ/paste:

```
Conversation ID eq '
```

Rồi click **Dynamic content** → chọn **Conversation ID** từ trigger → tiếp tục gõ `'`

Kết quả filter phải trông như:
```
Conversation ID eq 'Conversation ID'
```

*(Trong đó "Conversation ID" thứ hai là dynamic content màu xanh)*

   - **Top Count:** `1`

4. Đổi tên action: `Find_Matching_Record`

### Bước E4: Condition 2 – Kiểm tra có tìm thấy record không

1. **Add an action** → **Condition**
2. Thiết lập:
   - Choose a value: Expression → `length(outputs('Find_Matching_Record')?['body/value'])`
   - Operator: **is greater than**
   - Value: `0`

### Bước E5: Trích xuất Mã NPP (trong If yes)

1. **Add an action** → **Compose**
2. Inputs: click **Expression** → paste:

```
if(greater(indexOf(toLower(triggerOutputs()?['body/bodyPreview']), 'mã npp'), -1), trim(substring(triggerOutputs()?['body/bodyPreview'], add(indexOf(toLower(triggerOutputs()?['body/bodyPreview']), 'mã npp'), 8), 20)), '')
```

3. Click **OK**
4. Đổi tên: `Extract_NPP_Code`

> 💡 Expression này tìm text "mã npp" trong email body và lấy 20 ký tự tiếp theo.
> VD: Email chứa "Mã NPP: ABC123..." → trích xuất "ABC123..."
> Có thể cần tinh chỉnh số 20 tùy theo format mã NPP thực tế.

### Bước E6: Phát hiện Loại Account

1. **Add an action** → **Compose**
2. Inputs: Expression →

```
if(or(contains(toLower(triggerOutputs()?['body/bodyPreview']), 'dùng chung'), contains(toLower(triggerOutputs()?['body/bodyPreview']), 'shared')), 'Dùng chung', if(or(contains(toLower(triggerOutputs()?['body/bodyPreview']), 'dùng riêng'), contains(toLower(triggerOutputs()?['body/bodyPreview']), 'dedicated')), 'Dùng riêng', ''))
```

3. Đổi tên: `Detect_Account_Type`

### Bước E7: Cập nhật record SharePoint

1. **Add an action** → tìm **Update item** (SharePoint)
2. Cấu hình:
   - **Site Address:** Chọn SharePoint site
   - **List Name:** `NPP Account Tracking`
   - **Id:** Click **Expression** → paste:

```
first(outputs('Find_Matching_Record')?['body/value'])?['ID']
```

3. Điền các field:

| Field | Giá trị |
|-------|---------|
| **Mã NPP** | Dynamic content → **Outputs** từ `Extract_NPP_Code` |
| **Loại Account Value** | Dynamic content → **Outputs** từ `Detect_Account_Type` |
| **Ngày Hoàn Tất** | Dynamic content → **Received Time** từ trigger |
| **Trạng Thái Value** | Expression → paste bên dưới ⬇️ |

Expression cho Trạng Thái:
```
if(and(not(empty(outputs('Extract_NPP_Code'))), not(empty(outputs('Detect_Account_Type')))), 'Hoàn tất', 'Thiếu thông tin')
```

> Logic: Nếu trích xuất được CẢ mã NPP VÀ loại account → "Hoàn tất", nếu thiếu → "Thiếu thông tin"

### Bước E8: Thêm Condition gửi cảnh báo thiếu thông tin

1. **Add an action** → **Condition**
2. Thiết lập (Or):
   - Hàng 1: Expression → `outputs('Extract_NPP_Code')` | is equal to | (để trống)
   - Hàng 2: Expression → `outputs('Detect_Account_Type')` | is equal to | (để trống)
3. Chọn **Or**

### Bước E9: Gửi email cảnh báo (trong If yes của Condition trên)

1. **Add an action** → **Send an email (V2)** (Office 365 Outlook)
2. Cấu hình:
   - **To:** `email-cua-ban@company.com` ← **THAY bằng email thật**
   - **Subject:** `⚠️ NPP Automation - Thiếu thông tin từ email xác nhận`
   - **Body:** Click biểu tượng **</>** (Code View) và paste HTML:

```html
<h3>Cảnh báo: Không thể trích xuất đầy đủ thông tin</h3>
<p><b>Email gốc:</b> @{triggerOutputs()?['body/subject']}</p>
<p><b>Từ:</b> @{triggerOutputs()?['body/from']}</p>
<p><b>Mã NPP trích xuất:</b> @{outputs('Extract_NPP_Code')}</p>
<p><b>Loại account:</b> @{outputs('Detect_Account_Type')}</p>
<p>Vui lòng kiểm tra và cập nhật thủ công trong SharePoint List.</p>
```

   - **Importance:** High

### Bước E10: Save và Test

1. **Save** flow
2. Test bằng cách:
   - Dùng Flow 1 tạo một record test (gửi email "Mở mới NPP - Test")
   - Reply email đó với nội dung: `Đã tạo xong. Mã NPP: TEST001, Loại: Dùng riêng`
   - Kiểm tra SharePoint List xem record có được cập nhật không

---

## PHẦN F: TẠO FLOW 4a – CẢNH BÁO QUÁ HẠN (HÀNG NGÀY)

### Bước F1: Tạo Flow mới

1. Power Automate → **+ Create** → **Scheduled cloud flow**
2. Điền:
   - **Flow name:** `NPP - Flow 4a - Cảnh báo quá hạn`
   - **Starting:** Chọn ngày hôm nay
   - **Repeat every:** `1` Day
3. Click **Create**

### Bước F2: Chỉnh trigger Recurrence

1. Click vào trigger **Recurrence**
2. Thiết lập:
   - **Frequency:** Day
   - **Interval:** 1
   - **Time zone:** (UTC+07:00) Bangkok, Hanoi, Jakarta
   - **At these hours:** `9` (chạy lúc 9:00 sáng)
   - **At these minutes:** `0`

### Bước F3: Compose tính ngày cutoff

1. **+ New step** → **Compose**
2. Inputs: Expression →

```
formatDateTime(addDays(utcNow(), -3), 'yyyy-MM-ddTHH:mm:ssZ')
```

3. Đổi tên: `Cutoff_Date`

### Bước F4: Lấy danh sách yêu cầu quá hạn

1. **+ New step** → **Get items** (SharePoint)
2. Cấu hình:
   - **Site Address:** SharePoint site
   - **List Name:** `NPP Account Tracking`
   - **Filter Query:**

```
Trạng Thái eq 'Đang chờ xử lý'
```

> ⚠️ **Lưu ý:** SharePoint OData filter có thể yêu cầu dùng internal name. Nếu "Trạng Thái" không hoạt động, thử dùng `TrangThai` hoặc `Tr_x1ea1_ng_x0020_Th_x00e1_i`. Cách tìm internal name: Vào List Settings → click vào cột → xem URL, phần `Field=...` chính là internal name.

3. Đổi tên: `Get_Overdue_Items`

### Bước F5: Condition kiểm tra có item quá hạn

1. **+ New step** → **Condition**
2. Choose a value: Expression → `length(outputs('Get_Overdue_Items')?['body/value'])`
3. Operator: **is greater than**
4. Value: `0`

### Bước F6: Tạo bảng HTML (trong If yes)

1. **Add an action** → tìm **Create HTML table** (Data Operations)
2. Cấu hình:
   - **From:** Dynamic content → **value** từ `Get_Overdue_Items`
   - **Columns:** Chọn **Custom**
   - Thêm các cột:

| Header | Value |
|--------|-------|
| Loại Yêu Cầu | Dynamic → `Loại Yêu Cầu Value` |
| Tên NPP | Dynamic → `Tên NPP` |
| Ngày Yêu Cầu | Dynamic → `Ngày Yêu Cầu` |
| Email Người YC | Dynamic → `Email Người Yêu Cầu` |

3. Đổi tên: `Build_Alert_Table`

> ⚠️ Khi chọn Dynamic content từ `Get_Overdue_Items`, Power Automate tự động tạo **Apply to each**. Điều này bình thường.

### Bước F7: Gửi email cảnh báo (trong If yes)

1. **Add an action** → **Send an email (V2)**
2. Cấu hình:
   - **To:** `email-cua-ban@company.com` ← **THAY email thật**
   - **Subject:** `🔔 NPP Automation - Có yêu cầu NPP đang chờ xử lý quá 3 ngày`
   - **Body:** Click **</>** Code View → paste:

```html
<h2>⚠️ Cảnh báo: Yêu cầu NPP quá hạn</h2>
<p>Các yêu cầu NPP dưới đây đã chờ xử lý quá 3 ngày mà chưa có email xác nhận hoàn tất.</p>
<h3>Chi tiết:</h3>
@{body('Build_Alert_Table')}
<br/>
<p>Vui lòng kiểm tra và follow-up các yêu cầu trên.</p>
```

   - **Importance:** High

### Bước F8: Save

---

## PHẦN G: TẠO FLOW 4b – WEEKLY DIGEST (MỖI THỨ 2)

### Bước G1: Tạo Flow

1. **+ Create** → **Scheduled cloud flow**
2. Tên: `NPP - Flow 4b - Weekly Digest`
3. Repeat every: `1` Week
4. On these days: ☑️ **Monday**
5. Click **Create**

### Bước G2: Chỉnh Recurrence

- Time zone: (UTC+07:00) Bangkok, Hanoi, Jakarta
- At these hours: `8`
- At these minutes: `30`

### Bước G3: Lấy items Pending

1. **+ New step** → **Get items** (SharePoint)
2. Site & List: như trên
3. Filter Query: `Trạng Thái ne 'Hoàn tất'`
4. Đổi tên: `Get_Pending`

### Bước G4: Lấy items Hoàn tất tuần này

1. **+ New step** → **Get items** (SharePoint)
2. Site & List: như trên
3. Filter Query: `Trạng Thái eq 'Hoàn tất'`
4. Đổi tên: `Get_Completed_Week`

> Lưu ý: Filter theo ngày trong OData filter phức tạp. Có thể lấy tất cả "Hoàn tất" rồi filter trong flow bằng Condition, hoặc chấp nhận hiển thị tất cả items hoàn tất.

### Bước G5: Tạo bảng HTML cho Pending

1. **Create HTML table** (Data Operations)
2. From: Dynamic → **value** từ `Get_Pending`
3. Custom columns: Loại, Tên NPP, Ngày Yêu Cầu, Trạng Thái, Email Người YC
4. Đổi tên: `Table_Pending`

### Bước G6: Tạo bảng HTML cho Completed

1. **Create HTML table** (Data Operations)
2. From: Dynamic → **value** từ `Get_Completed_Week`
3. Custom columns: Loại, Tên NPP, Mã NPP, Loại Account, Ngày Hoàn Tất
4. Đổi tên: `Table_Completed`

### Bước G7: Gửi email digest

1. **Send an email (V2)**
2. To: `email-cua-ban@company.com`
3. Subject: `📊 NPP Weekly Digest`
4. Body (Code View):

```html
<h2>📊 Báo cáo NPP hàng tuần</h2>

<h3>📌 Yêu cầu đang pending:</h3>
@{body('Table_Pending')}

<br/>

<h3>✅ Đã hoàn tất:</h3>
@{body('Table_Completed')}
```

### Bước G8: Save

---

## PHẦN H: TẠO FLOW 5 – BÁO CÁO NGHIỆM THU HÀNG THÁNG

### Bước H1: Tạo Flow

1. **+ Create** → **Scheduled cloud flow**
2. Tên: `NPP - Flow 5 - Báo cáo hàng tháng`
3. Repeat every: `1` Month
4. Click **Create**

### Bước H2: Chỉnh Recurrence

1. Click trigger → Show advanced options
2. **Frequency:** Month
3. **Interval:** 1
4. **Time zone:** (UTC+07:00) Bangkok, Hanoi, Jakarta
5. **At these hours:** `8`
6. **At these minutes:** `0`

> Flow sẽ chạy ngày 1 mỗi tháng lúc 8:00 sáng.

### Bước H3: Compose tính tháng báo cáo

1. **+ New step** → **Compose**
2. Expression:

```
formatDateTime(addDays(utcNow(), -2), 'yyyy-MM')
```

3. Đổi tên: `Report_Month`

> Logic: Chạy ngày 1 tháng sau → trừ 2 ngày → ra tháng trước (dùng cho filter)

### Bước H4: Lấy NPP mở mới trong tháng

1. **Get items** (SharePoint)
2. Filter Query: gõ `Loại Yêu Cầu eq 'Mở mới'`

> Lưu ý: Nếu cần filter theo tháng, thêm: `and Tháng Báo Cáo eq '` + Dynamic content (Outputs từ Report_Month) + `'`

3. Đổi tên: `Get_New_NPP`

### Bước H5: Lấy NPP ngưng hoạt động trong tháng

1. **Get items** (SharePoint)
2. Filter tương tự, thay `Mở mới` → `Ngưng hoạt động`
3. Đổi tên: `Get_Deactivated_NPP`

### Bước H6: Tạo bảng HTML cho NPP mở mới

1. **Create HTML table**
2. From: value từ `Get_New_NPP`
3. Custom columns:

| Header | Value |
|--------|-------|
| Tên NPP | Tên NPP |
| Mã NPP | Mã NPP |
| Loại Account | Loại Account Value |
| Ngày Yêu Cầu | Ngày Yêu Cầu |
| Ngày Hoàn Tất | Ngày Hoàn Tất |
| Trạng Thái | Trạng Thái Value |
| Người Yêu Cầu | Email Người Yêu Cầu |

4. Đổi tên: `Table_New_NPP`

### Bước H7: Tạo bảng HTML cho NPP ngưng

Tương tự H6, đổi tên: `Table_Deactivated_NPP`

### Bước H8: Gửi email báo cáo

1. **Send an email (V2)**
2. **To:** `email-cua-ban@company.com; email-manager@company.com` ← **THAY email thật**
3. **Subject:** Expression →

```
concat('📋 Báo cáo nghiệm thu NPP tháng ', outputs('Report_Month'))
```

4. **Body:** Code View → paste:

```html
<html><body>
<h1>📋 BÁO CÁO NGHIỆM THU ACCOUNT NPP</h1>
<h2>Tháng @{outputs('Report_Month')}</h2>
<hr/>

<h3>📊 Tổng Quan</h3>
<table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse;">
  <tr style="background-color: #4472C4; color: white;">
    <th>Chỉ số</th>
    <th>Số lượng</th>
  </tr>
  <tr>
    <td>🟢 NPP mở mới</td>
    <td><b>@{length(outputs('Get_New_NPP')?['body/value'])}</b></td>
  </tr>
  <tr>
    <td>🔴 NPP ngưng hoạt động</td>
    <td><b>@{length(outputs('Get_Deactivated_NPP')?['body/value'])}</b></td>
  </tr>
</table>

<br/>
<h3>🟢 I. DANH SÁCH NPP MỞ MỚI</h3>
@{body('Table_New_NPP')}

<br/>
<h3>🔴 II. DANH SÁCH NPP NGƯNG HOẠT ĐỘNG</h3>
@{body('Table_Deactivated_NPP')}

<hr/>
<p><i>Báo cáo được tạo tự động bởi NPP Automation System</i></p>
</body></html>
```

5. **Importance:** Normal

### Bước H9: Save

---

## PHẦN I: TEST HỆ THỐNG

### Test 1: Kiểm tra Flow 1 (Mở mới)

1. Gửi email đến inbox của bạn với tiêu đề: `Mở mới NPP - Công ty Test ABC`
2. Đợi 1-2 phút
3. Kiểm tra SharePoint List → phải có record mới:
   - Loại Yêu Cầu: Mở mới
   - Tên NPP: Công ty Test ABC
   - Trạng Thái: Đang chờ xử lý

### Test 2: Kiểm tra Flow 2 (Ngưng hoạt động)

1. Gửi email: `Ngưng hoạt động NPP - Công ty Test XYZ`
2. Kiểm tra SharePoint List → record mới với Loại Yêu Cầu: Ngưng hoạt động

### Test 3: Kiểm tra Flow 3 (Reply xác nhận)

1. **Reply** email test từ Test 1 (bấm Reply, KHÔNG tạo email mới)
2. Nội dung reply:

```
Đã tạo xong account.
Mã NPP: NPP2026001
Loại: Dùng riêng
Ngày hoàn tất: 16/04/2026
```

3. Kiểm tra SharePoint List → record phải được cập nhật:
   - Mã NPP: NPP2026001...
   - Loại Account: Dùng riêng
   - Trạng Thái: Hoàn tất

### Test 4: Kiểm tra Flow 4a (Manual test)

1. Vào Flow 4a → click **Run** (chạy thủ công 1 lần)
2. Nếu có record "Đang chờ xử lý" quá 3 ngày → bạn sẽ nhận email cảnh báo

### Test 5: Kiểm tra Flow 5 (Manual test)

1. Vào Flow 5 → click **Run**
2. Bạn sẽ nhận email báo cáo tổng hợp

---

## 📌 MẸO & LƯU Ý QUAN TRỌNG

### Khi Flow bị lỗi

1. Vào Power Automate → **My flows**
2. Click vào flow bị lỗi
3. Xem **Run history** → click vào run failed (❌)
4. Tìm step nào bị đỏ → click vào xem error message
5. Lỗi thường gặp:
   - **Connection expired:** Click flow → Edit → sửa connection
   - **Field not found:** Kiểm tra tên cột SharePoint có đúng không
   - **Expression error:** Copy lại expression chính xác từ hướng dẫn

### Internal Name vs Display Name

SharePoint có 2 loại tên cột:
- **Display Name:** Tên bạn thấy (VD: "Loại Yêu Cầu")
- **Internal Name:** Tên hệ thống dùng (VD: "Lo_x1ea1_i_x0020_Y_x00ea_u_x0020_C_x1ea7_u")

Khi dùng trong Power Automate **Filter Query**, có thể cần dùng Internal Name. Cách tìm:
1. Vào SharePoint List → ⚙️ **Settings** → **List Settings**
2. Click vào tên cột
3. Nhìn URL trên trình duyệt, phần `&Field=...` chính là Internal Name

### Backup thủ công

Trong giai đoạn đầu, nên:
- Vẫn giữ quy trình tìm kiếm email thủ công song song
- Mỗi tuần so sánh kết quả SharePoint List với kết quả thủ công
- Tinh chỉnh từ khóa nếu cần

---

## ✅ CHECKLIST HOÀN THÀNH

- [ ] Đã tạo SharePoint List với đầy đủ 14 cột
- [ ] Đã tạo 3 views: Đang chờ xử lý, Mở mới tháng này, Ngưng hoạt động tháng này
- [ ] Đã tạo Flow 1: Quét email mở mới NPP ✅
- [ ] Đã tạo Flow 2: Quét email ngưng hoạt động NPP ✅
- [ ] Đã tạo Flow 3: Xử lý email reply xác nhận ✅
- [ ] Đã tạo Flow 4a: Cảnh báo quá hạn hàng ngày ✅
- [ ] Đã tạo Flow 4b: Weekly digest ✅
- [ ] Đã tạo Flow 5: Báo cáo nghiệm thu hàng tháng ✅
- [ ] Đã test Flow 1 thành công
- [ ] Đã test Flow 2 thành công
- [ ] Đã test Flow 3 thành công
- [ ] Đã test Flow 4a thành công
- [ ] Đã test Flow 5 thành công
- [ ] Đã chạy song song 1 tuần và so sánh kết quả
