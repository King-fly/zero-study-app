# Zero Study App

## 项目简介

Zero Study App 是一款专注于学习效率管理的iOS应用，帮助用户追踪学习时间、设置学习目标并分析学习数据。

## 功能特性

- **学习时间追踪**：记录每日学习时长
- **学习目标设置**：设定学习目标并追踪完成情况
- **学习数据统计**：可视化展示学习数据和趋势
- **多设备同步**：支持在不同设备间同步学习数据
- **用户友好界面**：简洁直观的用户界面设计

## 技术栈

- **开发语言**：Swift
- **开发框架**：SwiftUI
- **数据存储**：Core Data
- **状态管理**：ObservableObject

## 安装说明

### 前提条件

- Xcode 15.0 或更高版本
- iOS 16.0 或更高版本
- macOS 13.0 或更高版本

### 安装步骤

1. 克隆项目到本地
   ```bash
   git clone <repository-url>
   ```

2. 打开项目
   ```bash
   cd zero-study-app
   open zero-study-app.xcodeproj
   ```

3. 选择目标设备并运行项目

## 项目结构

```
zero-study-app/
├── zero-study-app/
│   ├── Assets.xcassets/          # 应用资源文件
│   │   ├── AppIcon.appiconset/   # 应用图标
│   │   └── AccentColor.colorset/ # 应用主题色
│   ├── Components/               # 自定义组件
│   ├── Models/                   # 数据模型
│   ├── Theme/                    # 主题相关
│   ├── Views/                    # 视图文件
│   ├── ContentView.swift         # 主视图
│   └── zero_study_appApp.swift   # 应用入口
└── zero-study-app.xcodeproj/     # Xcode项目文件
```

## 主要功能模块

### 首页 (HomeView)
- 显示今日学习时长
- 快速开始/暂停学习
- 展示学习目标完成情况

### 统计页面 (StatsView)
- 学习数据可视化
- 学习趋势分析
- 周/月/年学习报告

### 设置页面 (SettingsView)
- 个人信息设置
- 学习目标配置
- 应用偏好设置

## 贡献指南

1. Fork 本项目
2. 创建特性分支
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. 提交更改
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```
4. 推送到分支
   ```bash
   git push origin feature/AmazingFeature
   ```
5. 打开 Pull Request

## 许可证

本项目采用 MIT 许可证 - 详情请参阅 [LICENSE](LICENSE) 文件
