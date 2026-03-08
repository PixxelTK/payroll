# Payroll (Rails)

A small payroll/attendance tracking application built with Ruby on Rails.

## ⚙️ Requirements

- Ruby (recommended: 3.2+)
- Bundler
- PostgreSQL (or other supported Rails database)

## 🚀 How to run

1. Install dependencies:

```bash
bundle install
```

2. Setup the database:

```bash
bin/rails db:create db:migrate db:seed
```

3. Start the server:

```bash
bin/dev
```

Then open: http://localhost:3000

## 🧪 How to test

Run the Rails test suite:

```bash
bin/rails test
```

## 🧠 How it works

- Employees and attendances are modeled using standard Rails `Employee` and `Attendance` resources.
- Each employee has a **4-digit PIN** (stored securely via `has_secure_password :pin`).
- Certain actions require PIN verification; `PinsController` sets a short-lived `session[:pin_verified]` flag after successful PIN entry.
- Controllers handle CRUD operations and apply validation for check-in/check-out logic.
- The UI uses Rails views + Stimulus controllers for interactive validation and modal behavior.

## Scope ที่ทำเพิ่ม
- PIN สำหรับ Employees เพื่อใช้สำหรับตรวจสอบก่อนที่ employee จะเข้าไปดูหรือแก้ไข Attendance หรือข้อมูล Employee
- Employee สามารถดูสรุป Payroll รายเดือนได้
- ใช้ turbo frame modal สำหรับ Actions ต่างๆ เช่น check in / check out ในหน้า show employee เพื่อให้สามารถทำได้ในหน้าเดียวกันโดยไม่ต้องเปลี่ยน path

## AI
- Chat GPT สำหรับทบทวน Ruby on rails และช่วย Review/Debug/Improve Code รวมถึงช่วยเขียน Tests