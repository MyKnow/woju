# ♻️ Woju Front-End MVP 구현

## 📌 프로젝트 개요

**Woju**는 사용자가 중고 물품을 **교환**할 수 있는 **위치 기반 모바일 플랫폼**입니다.  
Flutter로 구현된 크로스플랫폼 앱으로, **한 번의 코드베이스로 Android와 iOS를 모두 지원**합니다.  

사용자는 자신의 위치 근처에 등록된 물품을 탐색하고, 원하는 교환 제안을 주고받을 수 있습니다.  
모든 교환 과정(제안, 수락, 완료 등)은 앱 내에서 이뤄지며, 채팅 기능과 상태 동기화를 통해 **원활한 거래 경험**을 제공합니다.  
물품의 위치 정보를 관리하여 지도 기반 탐색 및 쿼리가 가능합니다.

Back-End: [Link](https://github.com/MyKnow/woju_backend)

---

## 🚀 주요 기능

### 📍 위치 기반 탐색  
- 사용자의 현재 위치나 지정한 좌표 기준으로 근처 교환 가능한 물품 표시  
- 좌표를 포함한 요청으로 서버에서 지리적 검색 수행  

### 📦 물품 등록 및 관리  
- 제목, 설명, 사진 등을 입력하여 물품 등록  
- REST API 기반 POST / PUT / DELETE로 리소스 생성 및 수정/삭제  

### 🔄 교환 제안 흐름 동기화  
- REST 방식만 사용 (WebSocket 없음)  
- 교환 제안/수락 시 앱 UI에 즉시 반영  
- 명시적 새로고침 + 주기적 폴링 방식으로 서버 상태 동기화  

### 💬 사용자 간 채팅  
- Firebase Realtime Database 기반 채팅 기능  
- 발신자/수신자 노드에 메시지를 푸시하고 StreamBuilder로 실시간 반영  

### 🌐 다국어 및 다크모드 지원  
- `flutter_localizations`로 115개 이상의 언어 지원  
- 라이트/다크 테마 전환 가능 (ThemeData 적용)  

### 🎨 테마 커스터마이징  
- 전체 UI에 일관된 스타일 제공  
- 색상, 폰트 스타일을 테마 기반으로 통일 적용  

---

## 🧩 시스템 구조

- **📱 Flutter 기반 모바일 앱 (Android/iOS)**  
  - 싱글 코드베이스  
  - 반응형 UI 및 다양한 해상도 자동 대응  

- **🌐 Node.js RESTful 백엔드 서버**  
  - Express 등으로 구성  
  - HTTP 요청(GET/POST/PUT/DELETE)을 통해 리소스 관리  

- **🔐 Firebase Authentication**  
  - JWT 기반 인증  
  - 사용자 로그인 시 ID 토큰 발급 및 백엔드에서 검증  

- **🔑 JWT 기반 세션 관리**  
  - 발급된 토큰은 `flutter_secure_storage` 등에 저장  
  - API 요청 시 인증 헤더에 포함, 리프레시 토큰으로 토큰 갱신  

---

## 🛠 기술 스택

| 분류 | 기술 |
|------|------|
| 📱 **프론트엔드** | Flutter, Dart |
| 🌐 **통신 방식** | RESTful API (`http` 패키지) |
| 🔄 **상태 관리** | **Riverpod (Hooks + AsyncNotifier 기반)** |
| 🔐 **인증** | Firebase Authentication, JWT |
| 📦 **저장소** | flutter_secure_storage (JWT 저장) |
| 📱 **크로스 플랫폼** | Android, iOS (Material & Cupertino 지원) |
| 📏 **반응형 UI** | MediaQuery, LayoutBuilder 등 Flutter 레이아웃 시스템 활용 |

> ✅ Woju는 **상태 관리를 위해 Riverpod을 전면 도입**했습니다.  
> `AsyncNotifier`, `StateNotifierProvider`, `ProviderScope` 등을 적극 활용하여 **비동기 UI 처리, 전역 상태 공유, 인증 상태 반영** 등을 안정적으로 구현하였습니다.  
> Riverpod은 의존성 주입과 테스트 용이성이 뛰어나, 프로젝트 구조의 **확장성과 유지보수성**을 확보하는 데 중요한 역할을 했습니다.

---

## 🔧 기술적 과제 및 해결

### 🌀 WebSocket 미사용 시 실시간성 보완  
- WebSocket 없이도 사용자 경험을 위해 상태 변경 시 새로고침 & 폴링 적용  
- 예: 교환 제안 수락 시 서버 상태를 주기적으로 GET 요청하여 갱신  

### 🛡 Firebase 인증과 JWT 동기화  
- Firebase에서 발급한 JWT를 `flutter_secure_storage`에 저장  
- 만료 시 리프레시 토큰으로 ID 토큰 갱신 → 로그인 상태 유지  
- 백엔드는 Firebase Admin SDK로 토큰 유효성 검증 수행  

### 🎨 테마 & 다국어 지원  
- `ThemeData`로 앱 전체 스타일 일괄 적용  
- `flutter_localizations`로 115개 이상 언어 지원 → 다국어 사용자 대응  
- 사용자의 테마/언어 설정을 기반으로 맞춤형 UI 제공  

---

## 📚 참고 문헌

- [Flutter 공식 문서](https://docs.flutter.dev/)
- [Riverpod 공식 문서](https://riverpod.dev/)
- [Firebase Authentication](https://firebase.google.com/docs/auth)
- [flutter_localizations 패키지](https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html)

---

## 📌 라이선스

본 프로젝트는 MIT 라이선스를 따릅니다.
