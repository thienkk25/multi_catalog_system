# Xây dựng hệ thống danh mục điện tử liên thông đa lĩnh vực

Hệ thống Danh mục Điện tử Liên thông Đa Lĩnh vực. (Focusing on Agriculture, Forestry, Fisheries, and Environment)

## Giới thiệu

**Hệ thống được xây dựng nhằm quản lý tập trung các danh mục chuyên ngành trong các lĩnh vực:**
- Trồng trọt
- Chăn nuôi
- Thủy sản
- Môi trường
- Lâm nghiệp
- Thú y
- Chất thải
- Tài nguyên
- ...

**Hệ thống được phát triển bằng Flutter đa nền tảng, chạy trên:**
- 🌐 Web (Admin)

- 💻 Desktop

- 📱 Mobile (Android/IOS)

***Web, Desktop và Mobile sử dụng chung source code, chung kiến trúc và business logic.***

## Kiến trúc tổng thể

```text
Flutter (Web / Desktop / Mobile)
        |
        | REST API
        v
Node.js (Express)
        |
        v
Supabase (PostgreSQL + Auth)
```

## Giao diện & Chức năng

### 1. Quản lý Lĩnh vực

- Thêm / sửa / xóa lĩnh vực

- Phân loại danh mục theo lĩnh vực

### 2. Quản lý Nhóm danh mục

- Thêm / sửa / xóa nhóm danh mục

- Phân nhóm theo lĩnh vực

- Phân loại danh mục theo lĩnh vực, sắp xếp, ...
### 3. Quản lý Mục danh mục

- Thêm / sửa / xóa mục danh mục

- Phân nhóm theo nhóm danh mục

- Xem lịch sử thay đổi, xem chi tiết, khôi phục phiên bản lịch sử

- Bộ lọc sắp xếp theo lĩnh vực, nhóm, ...

### 4. Quản lý Văn bản pháp lý

- Thông tư

- Quyết định

- QCVN

- Phụ lục kỹ thuật / Khác

- Bộ lọc, sắp xếp, ...

### 5. Nhập / Xuất dữ liệu

- Nhập từ tệp Excel / CSV

- Xuất danh mục chuẩn

### 6. Quản lý Người dùng

- Thêm / sửa / xóa tài khoản

- Cấp quyền tài khoản chỉ định quản lý 1 hoặc nhiều lĩnh vực được cấp phép

- Mở / khóa tài khoản

- Bộ lọc, sắp xếp, ...

### 7. Quản lý API Key

- Thêm tự động tạo api_key...

- Thu hồi, xóa api key

- Bộ lọc, sắp xếp, ...

### 8. API Liên thông

- Cung cấp REST API cho hệ thống khác

- Hỗ trợ phân trang, giới hạn, sắp xếp, lọc, ...

- Đồng bộ theo thời gian cập nhật

## Cấu trúc dự án

```text
lib/
├── core/
│   ├── config/
│   │   ├── constants/          # Constants (API URLs, keys, etc.)
│   │   ├── networks/           # Network config (Dio, HTTP clients)
│   │   └── config.dart         # Export file
│   │
│   ├── error/                  # Error handling
│   │   ├── exceptions.dart     # Custom exceptions
│   │   └── failures.dart       # Failure classes
│   │
│   ├── global_notifiers/       # Global state management
│   │   ├── theme_notifier.dart
│   │   └── auth_notifier.dart
│   │
│   ├── router/                 # Navigation/Routing
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   │
│   ├── theme/                  # App theming
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   │
│   ├── utils/                  # Utilities
│   │   ├── formatter/          # Date, number formatters
│   │   ├── validator/          # Input validators
│   │   └── utils.dart          # Export file
│   │
│   ├── widgets/                # Reusable widgets
│   │   ├── custom_button.dart
│   │   ├── loading_indicator.dart
│   │   └── custom_text_field.dart
│   │
│   └── core.dart               # Export all core
│
├── features/
│   ├── auth/                   # Authentication feature
│   │   ├── data/
│   │   │   ├── data_sources/   # Remote/Local data sources
│   │   │   │   ├── auth_remote_data_source.dart
│   │   │   │   └── auth_local_data_source.dart
│   │   │   │
│   │   │   ├── models/         # Data models (JSON)
│   │   │   │   └── user_model.dart
│   │   │   │
│   │   │   ├── repositories_impl/  # Repository implementations
│   │   │   │   └── auth_repository_impl.dart
│   │   │   │
│   │   │   └── data.dart       # Export file
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/       # Business entities
│   │   │   │   └── user.dart
│   │   │   │
│   │   │   ├── repositories/   # Repository interfaces
│   │   │   │   └── auth_repository.dart
│   │   │   │
│   │   │   ├── use_cases/      # Business logic
│   │   │   │   ├── login_use_case.dart
│   │   │   │   ├── register_use_case.dart
│   │   │   │   └── logout_use_case.dart
│   │   │   │
│   │   │   └── domain.dart     # Export file
│   │   │
│   │   ├── presentation/
│   │   │   ├── pages/          # UI screens
│   │   │   │   ├── login_page.dart
│   │   │   │   └── register_page.dart
│   │   │   │
│   │   │   ├── provider/       # State management (Bloc)
│   │   │   │   └── auth_provider.dart
│   │   │   │
│   │   │   ├── widgets/        # Feature-specific widgets
│   │   │   │   └── auth_form.dart
│   │   │   │
│   │   │   └── presentation.dart  # Export file
│   │   │
│   │   └── auth.dart           # Export all auth feature
|   |   ....
│   │
│   └── features.dart           # Export all features
│
└── main.dart                   # Entry point
```

Kiến trúc theo hướng:

- Clean Architecture

- Feature-based

- Tách rõ ràng phần data, domain, presentation

- Dễ dàng nâng cấp, maintain, scale