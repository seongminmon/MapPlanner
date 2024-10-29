# 맵다이어리
맛집, 여행지 등 나만의 장소를 기록하는 서비스

![캘린더](https://github.com/user-attachments/assets/cf7cecf9-ea5d-4bd6-a174-9c5b85152de5) | ![IMG_7437](https://github.com/user-attachments/assets/8a300d2d-4ce8-4af9-b9d2-24e999828799) | ![타임라인](https://github.com/user-attachments/assets/995055e9-ee78-427e-8965-2b8ddff00fab) | ![IMG_7436](https://github.com/user-attachments/assets/41613f56-a853-413d-96f3-3a6679321925)
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
- **Input&Output** 패턴을 적용하여 **View와 Data 분리**
- **ViewModelType** 프로토콜을 사용하여 **ViewModel 추상화**
- **PassthroughSubject**로 구성된 Input과 **@Published**로 구성된 Output을 사용 

### Custom Modifier
- 재사용되는 NavigationBar와 HideKeyboardModifier를 ViewModifier로 구성
- **ViewModifier**와 **View Extension**을 통해서 코드 중복 제거 및 **재사용성** 증가

### Database
- class인 Realm 모델을 직접 View에서 사용할 때 삭제 시 오류 발생
- struct인 **PresentModel**을 분리해서 사용
- Realm의 **CRUD**를 담당하는 객체에 **ObservableObject**를 채택하여 데이터 변경 시 **View Rendering**이 일어나도록 함

### 캘린더
- **LazyVGrid**를 사용한 커스텀 캘린더 구현
- 기록이 있는 날짜와 없는 날짜를 구분하여 **화면 분기 처리**

### 지도
- cocoapod을 통해 **네이버 지도 SDK** 설치
- **UIViewRepresentable**을 채택하여 **Coordinator**를 통한 **위치 권한과 Data** 핸들링
- **URL Scheme**을 통한 길찾기 기능 구현

### 마커 관리
- 마커들을 **Dictionary**로 관리하여 **중복된 위치**에 마커가 그려지는 것을 방지
- Data 변경 시 **Dictionary와 Data를 비교**하여 변경된 부분에 대해서만 마커를 새로 그리거나 삭제하도록 구성

### 토스트 메시지
- RootView의 **onAppear** 시점에 **Notification Center**를 구독하여 전역적인 처리
- **windowScene**을 통해 뷰 계층 구조에 상관 없이 **최상단**에 띄울 수 있도록 함

### 문의하기
- **MFMailComposeViewController**를 통해 이메일로 문의하기 기능 구현
- 빠른 대응을 위해 사용자의 Device Model, Device OS, App Version을 메일 양식에 추가

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
