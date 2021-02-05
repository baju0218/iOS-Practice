#Core Data (thread)
thread safe에 관하여

기본적으로 context는 자신한테 생성된 queue에서만 사용될 수 있음

다른 queue로 보내서 작업하면 작동하지 않음 <- thread safe하지 않으므로

---------------------------------------------------------------------------

그래서 하나의 데이터 베이스에 여러 개의 context를 만듬
-> ??
https://zeddios.tistory.com/987 여기 중간 부분 아래 부터 그림 보면 좋을듯



자.. 정리해보자(아 왜 readme는 사진이 안되니..참)

우선 NSPersistentContainer가 아래의 모든 객체를 가지고 있고 또 관리한다(아래처럼 구성하였기에 core data를 원활히 이용가능한듯)
1. NSManagedObjectModel (Model)                       <- 데이터를 모델화 한 것 + 객체화(schema같은?)
2. NSManagedObjectContext (Context)                  <- 생성, 저장, 가져오기 도구(transaction같은?)
3. NSPersistentStoreCoordinator (Store coordinator)     <- 얘 밑단에 Persistent Store(진짜 데이터 저장 공간)이 있고 얘가 이제 model과 context를 잇는 다리 역할을 함


의식의 흐름대로 써보면
일단 진짜 데이터는 sql 방식으로 저장이 되지만 model을 사용해서 마치 객체인 것처럼 만들어주는듯? 또 객체처럼 사용도 될 수 있게
context는 여러개를 만들 수 있고 데이터 접근을 관리해주는 거 같음
멀티 스레딩에선 데이터 동시에 써버리면 데이터 이상해질 수 있는데 context라는 애를 통해서 일관성을 유지하는듯..? <- 나중에 알아봐야징
그리고 query로 꺼내올때 model이 마치 있는 것처럼 보여주고, 실제 사용될때 storage에서 꺼내와서 쓰는 기법을 사용..


context.performBlock {
    이 함수를 만약 context가 만들어진 큐가 아닌 다른 큐에서 실행하면, 올바른 큐에 가서 실행이 되도록 해줌
    즉 굳이 dispatch를 안해도 알아서 처리 해줌!
    그래서 context를 가지고 하는 작업들을 이 안에서 수행하면 매우 안전하긴 함
} <- 클로저
진짜 큐도 많고 context도 많으면 헷갈리기에 안전하게 사용하도록 얘를 쓰는게 좋음
굳이 그런 상황이 아니라면 안써도 되긴 함


---------------------------------------------------------------------------

다른 쓰레드에서 사용되는 context를 만들어 보자!        <- ??.. 안알려준 것 같은데..? 데모 보면 나오겠지...

persistentContainer.performBackgroundTask { context in
    메인 큐가 아닌 다른 큐를 찾아서 새로운 context를 만들어줌
    그 다음 그 큐에서 이 클로저가 실행됨
    
    *viewContext 사용하면 안됨!!!!!!! <- 다른 큐 이기 때문에 안돌아감
    *저장 꼭해라!!!!!!! <- 메모리에서만 바꾸면 뭐하니? 쓰레드 사라지면 메모리도 사라지는데..
    * 여기서 데이터 처리 하는듯? 세이브후엔 다른 context가 변경된 데이터베이스를 알아본다고 함
    

    try? context.save()
}



---------------------------------------------------------------------------
코어 데이터와 테이블 뷰는 찰떡 궁합!
NSFetchedResultsControl = 우리가 가져온 NSFetchRequest를 테이블뷰와 연결해주는 녀석
내부적으로 잘 구현해놔서 데이터베이스에 값 변경이 있을시 자동으로 테이블 뷰를 업데이트해줌


1. 얘는 delegate를 가지고 있고 여기에 tableview 연결해주면 알아서 업데이트 해주는 착한 녀석!
2. 또는 tableview의 data source 함수들에 NSFetchedResultsControl가 변수, 함수 형태로 값을 전달


