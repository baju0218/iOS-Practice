
override func draw(_ rect: CGRect) {
    여기서 인자는 최적화를 위한 인자라고 함
    원하는 rect부분만 그리는듯
    ios 시스템이 호출하므로 되도록 이 함수는 바꾸지말것
    
    * 실험해본 결과 override되면 기존의 설정된 모양 다 날라가고 안에 구현된 코드가 그려지는 듯 함 <- 아니네...
    따라서 하위 subview같은 애들도 망가질 수(?) 있으니 사용하지 말도록 하자 <- 이거 아녀..
}  <- 얘는 매번 바뀔 때마다 호출해서 최적화 문제 발생

따라서 바뀐 거 쌓아놓고 한꺼번에 아래 함수 호출해서 그리도록 하자
func setNeedsDisplay() {

}
override func setNeedsDisplay(_ rect: CGRect) {
    얜 최적화 버전
}


////////////////////////////////////////////////////////////


cg = core graphics  <- OpenGL 같은 친구?

전역 함수로써 존재하고 단순히 얘로 그릴 순 있음
그릴려면 1. context를 얻어와야함 -> window에 context(모니터, 프린터..등)를 생성하는데 맞나? (context안에 버퍼 넣고.. 등등 했었음)
2. 경로를 context 안에 저장
3. 그 다음 색상, 굵기 등 적용함
4. 버퍼에 그림           -> 이거 컴그에서 본듯 과정 다시 살펴보기



하지만 객체지향프로그래밍을 해보자!

UIBezierPath() <- 클래스로 존재하고 기저에는 cg를 쓰고 있긴함(색, 폰트, 텍스트, 이미지 4개 지원안함)
getContext 안해도 자동으로 해줌 매우 편리

예)
let path = UIbezierPath() <- 경로만 만들뿐 그리진 않음
path.fill()
path.stroke()


addClip() <- 베지에 경로로 둥근 모서리 구현 가능

베지에 경로 문서 참고


와... 텍스트도 결국 베지에 경로로 그리는 거였고
라벨의 글자들을 베지에 경로로 그리는 거였음;

view draw에서 그린 후 텍스트, 그림을 그리는 방법은
1. 간단하게 subview로 UILabel, UIImage를 써서 그리는것
2. NSAttributedString("hello").drawAtPoint(aCGPoint) or UIImage.drawAt ... 처럼 하위 뷰가 아닌 직접 그리는 법



bound가 바뀔 때 최적화를 위해서 보통 비트를 늘리거나 줄이는 방법을 택함(default : scale to fill)
그래서 content mode를 설정해서 다시 그릴지(redraw), 크기를 늘려 맞출지, 새로운 bound로 이동만 할지 등등 설정해야함
-> content mode가 요런거 였구나... 깨달음







