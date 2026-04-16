<#
.SYNOPSIS
    Tạo SharePoint List để lưu trữ thông tin account NPP.

.DESCRIPTION
    Script này sử dụng PnP PowerShell để tạo SharePoint List "NPP Account Tracking"
    với đầy đủ các cột cần thiết cho quy trình theo dõi account NPP.

.PARAMETER SiteUrl
    URL của SharePoint site nơi sẽ tạo list.

.PARAMETER ListName
    Tên của list (mặc định: "NPP Account Tracking").

.EXAMPLE
    ./provision-sharepoint.ps1 -SiteUrl "https://contoso.sharepoint.com/sites/operations"

.EXAMPLE
    ./provision-sharepoint.ps1 -SiteUrl "https://contoso.sharepoint.com/sites/operations" -ListName "NPP Tracking 2026"

.NOTES
    Yêu cầu: PnP.PowerShell module
    Cài đặt: Install-Module -Name PnP.PowerShell -Scope CurrentUser
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$SiteUrl,

    [Parameter(Mandatory = $false)]
    [string]$ListName = "NPP Account Tracking"
)

$ErrorActionPreference = "Stop"

# ============================================================
# 1. Kiểm tra và cài đặt PnP PowerShell module
# ============================================================
Write-Host "🔍 Kiểm tra PnP.PowerShell module..." -ForegroundColor Cyan

if (-not (Get-Module -ListAvailable -Name PnP.PowerShell)) {
    Write-Host "📦 Đang cài đặt PnP.PowerShell..." -ForegroundColor Yellow
    Install-Module -Name PnP.PowerShell -Scope CurrentUser -Force -AllowClobber
}

Import-Module PnP.PowerShell

# ============================================================
# 2. Kết nối SharePoint
# ============================================================
Write-Host "🔗 Đang kết nối tới SharePoint: $SiteUrl" -ForegroundColor Cyan

try {
    Connect-PnPOnline -Url $SiteUrl -Interactive
    Write-Host "✅ Kết nối thành công!" -ForegroundColor Green
}
catch {
    Write-Error "❌ Không thể kết nối tới SharePoint. Lỗi: $_"
    exit 1
}

# ============================================================
# 3. Tạo SharePoint List
# ============================================================
Write-Host "📋 Đang tạo list: $ListName" -ForegroundColor Cyan

$existingList = Get-PnPList -Identity $ListName -ErrorAction SilentlyContinue
if ($existingList) {
    Write-Host "⚠️  List '$ListName' đã tồn tại. Bỏ qua bước tạo list." -ForegroundColor Yellow
}
else {
    New-PnPList -Title $ListName -Template GenericList -EnableVersioning
    Write-Host "✅ Đã tạo list '$ListName'" -ForegroundColor Green
}

# ============================================================
# 4. Thêm các cột (Fields)
# ============================================================
Write-Host "📊 Đang thêm các cột vào list..." -ForegroundColor Cyan

# --- Loại Yêu Cầu (Choice) ---
$fieldExists = Get-PnPField -List $ListName -Identity "LoaiYeuCau" -ErrorAction SilentlyContinue
if (-not $fieldExists) {
    Add-PnPField -List $ListName -DisplayName "Loại Yêu Cầu" -InternalName "LoaiYeuCau" -Type Choice -Choices @("Mở mới", "Ngưng hoạt động") -Required $true
    Write-Host "  ✅ Đã thêm cột: Loại Yêu Cầu" -ForegroundColor Green
}
else {
    Write-Host "  ⏭️  Cột 'Loại Yêu Cầu' đã tồn tại" -ForegroundColor Yellow
}

# --- Tên NPP (Single line text) ---
$fieldExists = Get-PnPField -List $ListName -Identity "TenNPP" -ErrorAction SilentlyContinue
if (-not $fieldExists) {
    Add-PnPField -List $ListName -DisplayName "Tên NPP" -InternalName "TenNPP" -Type Text -Required $true
    Write-Host "  ✅ Đã thêm cột: Tên NPP" -ForegroundColor Green
}
else {
    Write-Host "  ⏭️  Cột 'Tên NPP' đã tồn tại" -ForegroundColor Yellow
}

# --- Mã NPP (Single line text) ---
$fieldExists = Get-PnPField -List $ListName -Identity "MaNPP" -ErrorAction SilentlyContinue
if (-not $fieldExists) {
    Add-PnPField -List $ListName -DisplayName "Mã NPP" -InternalName "MaNPP" -Type Text
    Write-Host "  ✅ Đã thêm cột: Mã NPP" -ForegroundColor Green
}
else {
    Write-Host "  ⏭️  Cột 'Mã NPP' đã tồn tại" -ForegroundColor Yellow
}

# --- Loại Account (Choice) ---
$fieldExists = Get-PnPField -List $ListName -Identity "LoaiAccount" -ErrorAction SilentlyContinue
if (-not $fieldExists) {
    Add-PnPField -List $ListName -DisplayName "Loại Account" -InternalName "LoaiAccount" -Type Choice -Choices @("Dùng chung", "Dùng riêng")
    Write-Host "  ✅ Đã thêm cột: Loại Account" -ForegroundColor Green
}
else {
    Write-Host "  ⏭️  Cột 'Loại Account' đã tồn tại" -ForegroundColor Yellow
}

# --- Ngày Yêu Cầu (Date) ---
$fieldExists = Get-PnPField -List $ListName -Identity "NgayYeuCau" -ErrorAction SilentlyContinue
if (-not $fieldExists) {
    Add-PnPField -List $ListName -DisplayName "Ngày Yêu Cầu" -InternalName "NgayYeuCau" -Type DateTime -Required $true
    Write-Host "  ✅ Đã thêm cột: Ngày Yêu Cầu" -ForegroundColor Green
}
else {
    Write-Host "  ⏭️  Cột 'Ngày Yêu Cầu' đã tồn tại" -ForegroundColor Yellow
}

# --- Ngày Hoàn Tất (Date) ---
$fieldExists = Get-PnPField -List $ListName -Identity "NgayHoanTat" -ErrorAction SilentlyContinue
if (-not $fieldExists) {
    Add-PnPField -List $ListName -DisplayName "Ngày Hoàn Tất" -InternalName "NgayHoanTat" -Type DateTime
    Write-Host "  ✅ Đã thêm cột: Ngày Hoàn Tất" -ForegroundColor Green
}
else {
    Write-Host "  ⏭️  Cột 'Ngày Hoàn Tất' đã tồn tại" -ForegroundColor Yellow
}

# --- Trạng Thái (Choice) ---
$fieldExists = Get-PnPField -List $ListName -Identity "TrangThai" -ErrorAction SilentlyContinue
if (-not $fieldExists) {
    Add-PnPField -List $ListName -DisplayName "Trạng Thái" -InternalName "TrangThai" -Type Choice -Choices @("Đang chờ xử lý", "Hoàn tất", "Thiếu thông tin") -DefaultValue "Đang chờ xử lý" -Required $true
    Write-Host "  ✅ Đã thêm cột: Trạng Thái" -ForegroundColor Green
}
else {
    Write-Host "  ⏭️  Cột 'Trạng Thái' đã tồn tại" -ForegroundColor Yellow
}

# --- Người Yêu Cầu (Person) ---
$fieldExists = Get-PnPField -List $ListName -Identity "NguoiYeuCau" -ErrorAction SilentlyContinue
if (-not $fieldExists) {
    Add-PnPField -List $ListName -DisplayName "Người Yêu Cầu" -InternalName "NguoiYeuCau" -Type User
    Write-Host "  ✅ Đã thêm cột: Người Yêu Cầu" -ForegroundColor Green
}
else {
    Write-Host "  ⏭️  Cột 'Người Yêu Cầu' đã tồn tại" -ForegroundColor Yellow
}

# --- Email Người Yêu Cầu (Text - fallback) ---
$fieldExists = Get-PnPField -List $ListName -Identity "EmailNguoiYeuCau" -ErrorAction SilentlyContinue
if (-not $fieldExists) {
    Add-PnPField -List $ListName -DisplayName "Email Người Yêu Cầu" -InternalName "EmailNguoiYeuCau" -Type Text
    Write-Host "  ✅ Đã thêm cột: Email Người Yêu Cầu" -ForegroundColor Green
}
else {
    Write-Host "  ⏭️  Cột 'Email Người Yêu Cầu' đã tồn tại" -ForegroundColor Yellow
}

# --- Conversation ID (Single line text) ---
$fieldExists = Get-PnPField -List $ListName -Identity "ConversationId" -ErrorAction SilentlyContinue
if (-not $fieldExists) {
    Add-PnPField -List $ListName -DisplayName "Conversation ID" -InternalName "ConversationId" -Type Text
    Write-Host "  ✅ Đã thêm cột: Conversation ID" -ForegroundColor Green
}
else {
    Write-Host "  ⏭️  Cột 'Conversation ID' đã tồn tại" -ForegroundColor Yellow
}

# --- Message ID (Single line text) ---
$fieldExists = Get-PnPField -List $ListName -Identity "MessageId" -ErrorAction SilentlyContinue
if (-not $fieldExists) {
    Add-PnPField -List $ListName -DisplayName "Message ID" -InternalName "MessageId" -Type Text
    Write-Host "  ✅ Đã thêm cột: Message ID" -ForegroundColor Green
}
else {
    Write-Host "  ⏭️  Cột 'Message ID' đã tồn tại" -ForegroundColor Yellow
}

# --- Link Email Gốc (Hyperlink) ---
$fieldExists = Get-PnPField -List $ListName -Identity "LinkEmailGoc" -ErrorAction SilentlyContinue
if (-not $fieldExists) {
    Add-PnPField -List $ListName -DisplayName "Link Email Gốc" -InternalName "LinkEmailGoc" -Type URL
    Write-Host "  ✅ Đã thêm cột: Link Email Gốc" -ForegroundColor Green
}
else {
    Write-Host "  ⏭️  Cột 'Link Email Gốc' đã tồn tại" -ForegroundColor Yellow
}

# --- Ghi Chú (Multiple lines text) ---
$fieldExists = Get-PnPField -List $ListName -Identity "GhiChu" -ErrorAction SilentlyContinue
if (-not $fieldExists) {
    Add-PnPField -List $ListName -DisplayName "Ghi Chú" -InternalName "GhiChu" -Type Note
    Write-Host "  ✅ Đã thêm cột: Ghi Chú" -ForegroundColor Green
}
else {
    Write-Host "  ⏭️  Cột 'Ghi Chú' đã tồn tại" -ForegroundColor Yellow
}

# --- Tháng Báo Cáo (Text - for filtering) ---
$fieldExists = Get-PnPField -List $ListName -Identity "ThangBaoCao" -ErrorAction SilentlyContinue
if (-not $fieldExists) {
    Add-PnPField -List $ListName -DisplayName "Tháng Báo Cáo" -InternalName "ThangBaoCao" -Type Text
    Write-Host "  ✅ Đã thêm cột: Tháng Báo Cáo" -ForegroundColor Green
}
else {
    Write-Host "  ⏭️  Cột 'Tháng Báo Cáo' đã tồn tại" -ForegroundColor Yellow
}

# ============================================================
# 5. Tạo Views
# ============================================================
Write-Host "👁️ Đang tạo các view..." -ForegroundColor Cyan

# View: Tất cả yêu cầu
$viewExists = Get-PnPView -List $ListName -Identity "Tất cả yêu cầu" -ErrorAction SilentlyContinue
if (-not $viewExists) {
    Add-PnPView -List $ListName -Title "Tất cả yêu cầu" -Fields @("LoaiYeuCau", "TenNPP", "MaNPP", "LoaiAccount", "NgayYeuCau", "NgayHoanTat", "TrangThai", "EmailNguoiYeuCau") -SetAsDefault
    Write-Host "  ✅ Đã tạo view: Tất cả yêu cầu" -ForegroundColor Green
}

# View: Đang chờ xử lý
$viewExists = Get-PnPView -List $ListName -Identity "Đang chờ xử lý" -ErrorAction SilentlyContinue
if (-not $viewExists) {
    Add-PnPView -List $ListName -Title "Đang chờ xử lý" -Fields @("LoaiYeuCau", "TenNPP", "NgayYeuCau", "TrangThai", "EmailNguoiYeuCau") -Query '<Where><Eq><FieldRef Name="TrangThai"/><Value Type="Choice">Đang chờ xử lý</Value></Eq></Where>'
    Write-Host "  ✅ Đã tạo view: Đang chờ xử lý" -ForegroundColor Green
}

# View: Mở mới trong tháng
$viewExists = Get-PnPView -List $ListName -Identity "Mở mới tháng này" -ErrorAction SilentlyContinue
if (-not $viewExists) {
    Add-PnPView -List $ListName -Title "Mở mới tháng này" -Fields @("TenNPP", "MaNPP", "LoaiAccount", "NgayYeuCau", "NgayHoanTat", "TrangThai") -Query '<Where><And><Eq><FieldRef Name="LoaiYeuCau"/><Value Type="Choice">Mở mới</Value></Eq><Geq><FieldRef Name="NgayYeuCau"/><Value Type="DateTime"><Today OffsetDays="-30"/></Value></Geq></And></Where>'
    Write-Host "  ✅ Đã tạo view: Mở mới tháng này" -ForegroundColor Green
}

# View: Ngưng hoạt động trong tháng
$viewExists = Get-PnPView -List $ListName -Identity "Ngưng hoạt động tháng này" -ErrorAction SilentlyContinue
if (-not $viewExists) {
    Add-PnPView -List $ListName -Title "Ngưng hoạt động tháng này" -Fields @("TenNPP", "MaNPP", "NgayYeuCau", "NgayHoanTat", "TrangThai") -Query '<Where><And><Eq><FieldRef Name="LoaiYeuCau"/><Value Type="Choice">Ngưng hoạt động</Value></Eq><Geq><FieldRef Name="NgayYeuCau"/><Value Type="DateTime"><Today OffsetDays="-30"/></Value></Geq></And></Where>'
    Write-Host "  ✅ Đã tạo view: Ngưng hoạt động tháng này" -ForegroundColor Green
}

# ============================================================
# 6. Hoàn tất
# ============================================================
Write-Host ""
Write-Host "🎉 Hoàn tất provisioning SharePoint List!" -ForegroundColor Green
Write-Host "📋 List: $ListName" -ForegroundColor Cyan
Write-Host "🔗 URL: $SiteUrl/Lists/$($ListName -replace ' ', '%20')" -ForegroundColor Cyan
Write-Host ""
Write-Host "Bước tiếp theo:" -ForegroundColor White
Write-Host "  1. Mở SharePoint site và kiểm tra list vừa tạo" -ForegroundColor White
Write-Host "  2. Import các Power Automate flows từ thư mục flows/" -ForegroundColor White
Write-Host "  3. Xem hướng dẫn: docs/deployment-guide.md" -ForegroundColor White

Disconnect-PnPOnline
