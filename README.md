# Packages

- DB : Prisma, postgresql
- Logging : winston, ELK
- 썸네일 생성 : ffmpeg -> avif
- web server : nginx
- deploy : docker, pm2
  - application : 1core, 2GB
  - DB : 1core, 2GB
  - nginx : 1core, 512MB
  - elasticsearch : 1c, 2G
  - logstash : 1c, 2G
  - kibana : 1c, 2G

# ERD

```mermaid
erDiagram
	Member {
		id string pk
		createdAt datetime
		updatedAt datetime
		deletedAt datetime "nullable"
		provider enum "APPLE, GOOGLE"
		providerId string "unique"
		email string
		name string
		metadata json
		fcmToken string "nullable"
		isAdmin boolean
	}

	RefreshToken {
		id string pk
		createdAt datetime
		expiredAt datetime
		token string
		memberId int fk
	}

	Brand {
		id string pk
		createdAt datetime
		updatedAt datetime
		deletedAt datetime "nullable"
		name string
	}
```

```mermaid
erDiagram
	Memory {
		id string pk
		createdAt datetime
		updatedAt datetime
		deletedAt datetime "nullable"
		memberId int fk
		date datetime
		brandName string
		like boolean
	}
	Memory ||--|{ MemoryFile: files
	Memory }|--|{ AlbumsOnMemory: containes

	MemoryFile {
		id string pk
		createdAt datetime
		updatedAt datetime
		deletedAt datetime "nullable"
		memoryId int fk
		type enum "IMAGE, VIDEO"
		originalName string
		size int
		path string
		thumbnailPath string
	}

	Album {
		id string pk
		createdAt datetime
		updatedAt datetime
		deletedAt datetime "nullable"
		memberId int fk
		name string
	}
	Album }|--|{ AlbumsOnMemory: containes

	AlbumsOnMemory {
		id string pk
		albumId int fk
		memoryId int fk
	}
```

# Sequence Diagram

## Auth

### 로그인

```mermaid
sequenceDiagram

actor C as Client
participant A as Auth
participant M as Member

C ->> A: POST /auth/signin
A ->> M: 유효한 사용자야?
M -->> C: 그런 사람 없는데? 404 반환
M ->> A: 사용자 정보 반환
A -> A: JWT 발급 & 저장
A ->> M: PUSH 정보 저장 요청
A ->> C: 로그인 정보 반환
```

### 로그아웃

```mermaid
sequenceDiagram

actor C as Client
participant A as Auth
participant M as Member

C ->> A: POST /auth/signout
A ->> A: 토큰 유효성 검사
A -->> C: 실패시 401 반환
A ->> M: PUSH 정보 삭제 요청
A ->> A: 토큰 삭제
A ->> C: 200 OK
```

### 토큰 유효성 검사

```mermaid
sequenceDiagram

actor C as Client
participant A as Auth

C ->> A: GET /auth/validate
A ->> A: 토큰 유효성 검사
A -->> C: 유효기간 만료 403
A ->> C: 200 OK
```

### 토큰 갱신

```mermaid
sequenceDiagram

actor C as Client
participant A as Auth

C ->> A: POST /auth/refresh
A ->> A: RefreshToken 유효성 검사
A -->> C: 만료 또는 정보가 없으면 401
A ->> A: 새로운 AccessToken 생성
A ->> C: 토큰 반환
```

## User

### 회원가입

```mermaid
sequenceDiagram

actor C as Client
participant M as Member
participant A as Auth

C ->> M: POST /members
M ->> M: 사용자 중복 여부 확인
M -->> C: 이미 가입했는데? 400
M ->> M: 사용자 생성
M ->> A: 로그인 정보 생성 요청
A ->> M: 로그인 정보 반환
M ->> C: 로그인 정보 반환
```

### 회원조회

### 회원탈퇴

```mermaid
sequenceDiagram

actor C as Client
participant M as Member
participant A as Auth

C ->> M: DELETE /members/:id
M ->> M: 이 사용자 있어?
M -->> C: 그런 사람 없는데? 404
M ->> M: 삭제 처리해줘 (soft delete)
M ->> A: 이 사람 토큰 삭제해줘
M ->> C: 탈퇴완료
```

## Memory

### 파일 업로드

### 생성

### 리스트 조회

```mermaid
sequenceDiagram

actor C as Client
participant M as Memory

C ->> M: GET /memories
alt 일반 조회
M ->> C: 전체 추억 조회
else 앨범으로 필터링
M ->> C: 요청한 앨범에 속한 추억만 조회
end
```

### 상세 조회

### 수정

### 삭제

```mermaid
sequenceDiagram

actor C as Client
participant M as Memory
participant A as Album

C ->> M: DELETE /memories/:id
M ->> M: 이거 있는 추억이야?
M -->> C: 이거 없는데? 404
M ->> M: 삭제처리
M ->> A: 앨범에서 이거 없애줘
M ->> C: 완료!
```

## Album

### 생성

### 목록 조회

```mermaid
sequenceDiagram

actor C as Client
participant A as Album
participant M as Memory

C ->> A: GET /albums
A ->> A: 앨범 목록 조회
A ->> M: 앨범별로 속한 최신 추억 조회
M ->> A: 추억들 반환
A ->> C: 목록 반환
```

### 상세조회

### 수정

### 삭제

### 앨범에 추억 추가

```mermaid
sequenceDiagram

actor C as Client
participant A as Album
participant M as Memory

C ->> A: POST /albums/:id/memories
A ->> A: 유효한 앨범인지 확인
A -->> C: 앨범이 없는데? 404
A ->> M: 이거 있는 추억이야?
M -->> C: 이거 없는건데? 400
M ->> A: 추억 정보 반환
A ->> A: 앨범에 사진 추가
A ->> C: 성공! 201
```

### 앨범에서 추억 삭제

```mermaid
sequenceDiagram

actor C as Client
participant A as Album

C ->> A: DELETE /albums/:id/memories/:id
A ->> A: 유효한 앨범인지 확인
A -->> C: 앨범이 없는데? 404
A ->> A: 앨범에 해당 추억이 있는지 확인
A -->> C: 이거 없는건데? 400
A ->> A: 앨범에서 추억 삭제
A ->> C: 성공! 200
```

## Crawling

### 브랜드 목록 조회

### 크롤링 요청
