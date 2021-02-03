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
but 멀티 쓰레딩으로 하는 법을 나중에 배워보자

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


근데 이 방법은 Any이기 때문에 매우 지저분한 API + 나중에 타입 오류 가능성 다분
뒤에 방법 사용

5.
Codegen을 이용하면 자동으로 entity 안에 들어있는 값을 참조할 수 있는 var을 코드로 만들어줌


6.
앱이 종료되면 저장을 해보자
do {
    try context.save()
} catch {
    // 에러 관리 부분
}
