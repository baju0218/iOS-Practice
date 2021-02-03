#Core Data (querying)
데이터를 꺼내와보자!

NSFetchRequest
<- extension 시 자동 생성되었던 함수 기억나니?


사용법
1. 반드시 한 가지 종류의 Entity를 가져옴
(tweet과 tweeter를 동시에 가져올 순 없음)
2. NSSortDescriptor <- array로 데이터를 내뱉기 때문에 순서가 어떻게 될 지 지정해줘야함
3. NSPredicate <- 어느 조건에 부합하는 애들을 가져올 것인가?


실제
let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
request.sortDescriptors = [sortDescriptor1, sortDescriptor2, ...]
requset.predicate = ...


하나하나 살펴보자
1.  let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
타입을 꼭 명시해야함! (매우매우 얼마 안되는 swift가 타입을 추론할 수 없는 경우임)
fetchRequest()는 사실 NSManagedObject도 가지고 있고, 당연히 서브 클래스들(tweet, tweeter..) 들도 extension으로 재정의해놔서 그냥 개별 fetchRequest가 있음
따라서 Tweet.fetchRequest() 하면 NSManagedObject의 fetchRequest인지, Tweet의 fetchRequest인지 모름
타입 명시를 꼭 해주자

2.  request.sortDescriptors = NSSortDescriptor(
    key: "screenName", ascending: true,
    selector: #selector(NSString.localizedStandardCompare(_:))
)
여기선 NSString으로 넘겨줘야하는데 selector가 objective-c 함수만 받을 수 있기 때문에..
NSString이 String도 똑같이 실행해줌
nsstring compare은 종류가 많으니 봐볼 것
nsstring compare을 이용하면 데이터베이스를 전부 가져와서 비교하는게 아님
데이터베이스에 내장된 sql 분류 방법을 사용하기 때문에 매우 효율적! <- 기본 compare가 데이터베이스 사이드의 분류 방법이 구현되어있음

그래서 개인적으로 만든 custom compare를 사용하지 않는 것을 권장함
-> 모든 데이터 베이스의 데이터를 가져와서 custom compare을 실행하기에(sql 방법이 아닌) 매우 비효율적이게됨

정수나 date는 selector 부분을 스킵하고 사용하면 됨 -> 기본 compare로 해줌

3. requset.predicate = ...
c printf와 매우 비슷함

예시)
let searchString = "foo"
let predicate = NSPredicate(format: "text contains[c] %@", searchString)       <-     [c]는 case-insensitive 대소문자 구분 x
let joe: TwitterUser = ...
let predicate = NSPredicate(format: "tweeter = %@ && created > %@", joe, aDate)
let predicate = NSPredicate(format: "tweeter.screenName = %@", "CS193p")

포맷 형태는 NSPredicate 공식 문서를 참조해야함!

* NSCompoundPredicate <- and와 같은 효과
* Function Predicates 

문서 찾아보자..

////////////////////////////////////////////////////////////////////////////////////////////////

다 됐다! 이제 써볼까?
request 만들고, sortDiscriptor 넣어주고, predicate 넣어주고..

let tweeters = try? context.fetch(request)

가져온 데이터가 100만개라 해도 걱정 ㄴㄴ
array를 가져왔지만 주소값?만 가져온 상태인듯
실제로 객체 출력해보면 빈 껍데기만 나옴
객체의 프로퍼티 접근하면 그제서야 생성
