# 맵다이어리
맛집, 여행지 등 나만의 장소를 기록하는 서비스

![캘린더](https://github.com/user-attachments/assets/cf7cecf9-ea5d-4bd6-a174-9c5b85152de5) | ![지도](https://github.com/user-attachments/assets/c77b3b5d-7a71-4048-8857-b2933629e11c) | ![타임라인](https://github.com/user-attachments/assets/995055e9-ee78-427e-8965-2b8ddff00fab) | ![수정](https://github.com/user-attachments/assets/1a20cfb4-8c18-42dc-a022-8b27d7f63372)
---|---| ---| ---|

## 프로젝트 환경
- 개발 인원: iOS 1
- 개발 기간: 24.09.11 ~ 진행 중 (24.10.04 출시)
- 최소 버전: iOS 16.0

## 기술 스택
- 🎨 View Drawing: `SwiftUI`  
- 🏛️ Architecture: `MVVM`  
- ♻️ Asynchronous: `Combine`  
- 📡 Network: `URLSession`  
- 📦 DB: `RealmSwift`  
- 🍎 Apple Framework: `PhotosUI`  `MessageUI`
- 🎸 기타: `NMapsMap`

## 주요 기능
- 나만의 장소 기록 **조회 / 작성 / 수정 / 삭제** 기능
- **캘린더 / 지도 / 타임라인** 뷰를 통해 다양한 형태로 기록 확인
- 나만의 장소 기록 **검색**

## 주요 기술

### MVVM 아키텍처
- Input&Output 패턴과 Data Binding을 적용하여 View와 Data 분리
- ViewModelType 프로토콜을 사용하여 ViewModel 추상화

### Custom Modifier
- ViewModifier 객체와 View Extension을 통해서 코드 중복 제거


### 캘린더
- LazyVGrid를 사용하여 캘린더 그리기
- 기록이 있는 날짜는 다른 화면 보여주도록 처리

### 지도
- cocoapod을 통해 네이버 지도 SDK 설치
- UIViewRepresentable을 채택하여 Coordinator를 통한 Data

### 마커 관리
- 마커들을 dictionary로 관리하여 중복된 위치에 여러 개의 마커가 그려지는 것을 방지함
- Data가 바뀌었을 때 바뀐 부분에 대해서만 마커를 새로 그리거나 삭제함

### 토스트 메시지
- RootView의 onAppear 시점에 Notification Center를 구독하여 전역적인 처리
- windowScene을 통해 뷰 계층 구조에 상관 없이 최상단에 띄울 수 있도록 함

### DateFormatter
- 인스턴스 생성 비용이 큰 DateFormatter()를 static으로 만들어 리소스 낭비 방지

## 트러블 슈팅

### Realm 삭제 시 오류 발생하는 문제
- class인 Realm 모델을 직접 View에서 사용할 때 삭제 시 오류 발생
- struct인 PresentModel을 분리해서 사용
- Realm의 CRUD를 담당하는 객체 분리
- ObservableObject를 채택하여 데이터 변경 시 View Rendering이 일어나도록 함

## 회고

### Keep (좋았던 점)
- 출시 성공
- SwiftUI에 익숙해짐

### Problem (아쉬웠던 점)
- 지도와 커스텀 캘린더 구현이 생각보다 오래 걸림

### Try (시도할 점)
- 프로젝트 전체 MVVM으로 고치기
