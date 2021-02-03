#Core Data
(데이터 베이스 공부해야할 듯..!)
코어 데이터 != 데이터 베이스 가 아님 (framework이고 물론 persistent를 지원하지만 다른 기능도 많음! 그중에 일부 일 뿐)

모든 entity는 NSManagedObject라는 클래스를 상속받고 있음
데이터베이스 자체는 NSManagedObjectContext이고 얘를 통해서 데이터베이스안의 데이터에 접근 시작


--------------------------------------------------------------------------------------------------------------

1.
let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer   <-   NSPersistentContainer
접근은 이렇게!

-> UIApplication이라는 클래스에 static이라는 변수로 shared가 있음
shared에 유일한 앱 참조값을 넣어주는 듯

2.
let context: NSManagedObjectContext = container.viewContext <- 얘는 메인 스레드에서만 실행!!!!!!!!!!!!!!!!!!!!!! 매우 중요!!!!!!!!!!!!!!!!(view와도 관련이 있기 때문에) -> 쓰레드 안전형이 아님
but 멀티 쓰레딩으로 하는 법을 나중에 배워보자 // 아하 데이터 베이스를 동시에 접근하면 문제가 발생하니깐 메인에서만 다루는게 편하긴 하겠다 다만 성능이..

3.
시작하기에 앞서 매번  (UIApplication.shared.delegate as! AppDelegate).persistentContainer 요렇게 쓰는 거 보다
class AppDelegate {
    static var persistentContainer: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    } <- 계산 프로퍼티
}
이렇게 만들면 AppDelegate.persistentContainer로 손쉽게 접근 가능
(강의에선 static 변수명과 프로퍼티 변수명이 똑같은데 이게 되나? 구분이 되나?)
-> 오 되네 근데 static 변수에 접근하려면 클래스명 붙여야됨. 아니면 프로퍼티 우선인듯

class AppDelegate {
    static var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    } <- 계산 프로퍼티
}
얘도 이렇게 써랑

-> 데이터베이스가 여러개라면 이제 persistentContainer 여러개로 만들면 된다!
-> 근데 대부분의 앱은 거대한 데이터베이스 하나만 갖고 있는 구조라고 함.. 크게 걱정은 할 필요 없을듯

4.
이제 예시를 봐보자
import CoreData <- core service 계층( 1. core os 2. core service 3. media 4. cocoa pod  )

let context = AppDelegate.viewContext
let tweet: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "Tweet", into: context)
-> tweet에 엔티티를 가리키는 주소값이 들어감
-> tweet 변수에 값을 넣어주기만 하면 됨
-> 방법은 아래..

func value(forKey: String) -> Any?
func setValue(Any?, forKey: String)

저장하기
tweet.setValue( 아이템 , forKeyPath: "tweetwer.name")

꺼내오기
-> let username = tweet.value(forKeyPath: "tweetwer.name") as? String


근데 이 방법은 매우 지저분한 API 임과 동시에 타입이 Any이기 때문에 타입 검사가 안됨, 나중에 실행시에 타입 오류 가능성 다분(실수 안하면 되긴하는데.. 불가능하겠지..)
-> 모델에서 만들어준 type과 달라도 any이기 때문에 걍 타입 검사 없이 다 받아들임
-> 나중에 실행해보면 타입 다를때 에러 낼거임
그래서 뒤에 방법 사용

5.
Codegen을 이용하면 자동으로 entity 안에 들어있는 값을 참조할 수 있는 var을 코드로 만들어줌
어렵다... 나중에 프젝하면서 같이 강의보면서 해야할듯..
일단 이해한 것만 쓰고.. 나중에 여기 채워넣자
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



codegen을 통해 none, class, extension 3가지 중 하나를 쓸 수 있는데
none은 4번 방법처럼
class는 자동으로 class를 만들어줌(<- 자동으로 class를 만들기 때문에 네비게이터에 안나오고, 변수만 손쉽게 접근하는 방법인듯?, 메서드 만들기 불가능한듯? 나중에 확인해봄세 머리 아픔)
extension은 class로 만들어놓으면 자동으로 extension으로 프로퍼티 붙여줌 + 기본 추가,삭제 메서드 넣어줌
-> 얘가 장점이 변수 접근도 되면서 클래스에 추가 기능 구현하기 좋음 얠 자주 쓴다고 함

class나 extension으로 만들면 프로퍼티 타입을 정확히 아니깐 타입 검사도 가능해져서 빌드 전에 자동으로 에러 내줌
매우 굿
if let tweet = Tweet(context: context) {
    tweet.text = "~~~~~~"
    tweet.created = Date()       <-     만약 여기에 실수로 String을 넣었다? 4번 방법이였으면 에러 안내고 넘어가버림
    let joe = TwitterUser(context: tweet.managedObjectContext)
    tweet.tweeter = joe                                                <- 자동으로 반대편도 업데이트됨!
    tweet.tweeter.name = "Joe Schmo"
} <- tweeter는 relation  임

if let joesTweets = joe.tweets as? Set<Tweet>  {
    if joesTweets.contains(tweet) { print("yes") }
} <- 확인해보면 자동으로 업데이트 된걸 볼 수 있음



<- 1대 다수 의 관계를 맺고 있다면 기본적으로 NSSet? 타입임 -> 타입 캐스팅을 통해 Set<Tweet>으로 변환해서 사용 가능욤
<- joe라는 변수가 없다면 어떻게 joe를 얻어오지?? 나중에 나오겠지..? 일단 패스 // querying을 통해 얻어온다! 다음 문서에 정리해놨따
이상한 점 : let joe = TwitterUser(context: tweet.managedObjectContext)
왜 여기서 let joe = TwitterUser(context: AppDelegate.context) 가 아니냐? 하면
tweet가 들어가있는 데이터베이스 안에 tweeter를 넣어주고 싶기때문에 가장 안전하게 하는 방법이기 때문! <- 패러다임이라고 함, 그냥 확실히 하기 위해서
context가 여러개인 상황에서 실수로 다른 context에 넣어주는 현상 방지하자



* 데이터 모델 편집기에서 값들의 속성 탭을 보면 integer16, 32 같은 타입에 Use Scalar Type 이라는 옵션이 있음
보통 데이터 베이스에 interger, double이 아닌 NSNumber 타입으로 바꾸어서 넣어주었다고 함
NSNumber로 바꾸지 말고 바로 원시 타입 그대로 넣고 싶다면 해당 옵션을 체크할 것
숫자 쓸땐 얘를 기본적으로 켜자!


6.
데이터를 삭제해볼까?
managedObjectedContext.delete(_ object: tweet)
사용법이 매우 깔끔!
삭제 규칙을 따름

func prepareForDeletion() {
    // 삭제 전에 특정 행동이 필요할 때 유용
    // 얘를 들어 tweet을 삭제하면 tweeter의 tweet count가 1 감소 해야하는데
    // tweet의 관계를 통해 해당 tweerter로 접근해서 count 깎으면 됨
}




7.
앱이 종료되면 저장을 해보자
do {
    try context.save()
} catch {
    // 에러 관리 부분
}







//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////







