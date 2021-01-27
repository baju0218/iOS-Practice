UIView

-> UIControl을 상속 받으면 action 류 -> UIButton, UISwitch, UIStepper 등등(터치 기능 있는 애들)

-> 그냥 UIImageView, 등등(없는 애들, delegation 또는 recognizer)


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



코드 : control.addTarget() - target, action method, event 를 설정한다

func addTarget(_ target: Any?,  action: Selector,  for controlEvents: UIControl.Event)
ex) button.addTarget(self,  action: #selector(ViewController.func),  for controlEvents: .touchUpInside)
target에는 일을 맡아줄 객체를 선정하고(여기선 viewController) -> action에는 그 객체가 할 수 있는 함수를 호출해주고(인자가 0개일 땐 괄호 생략) -> 어떤 이벤트가 들어왔는지 기입
selector에서 인자가 0개 이거나 함수명이 단일인 경우는 생략할 수 있는데 아닌 경우는 (_: for:)처럼 표시해줘야함

@objc func()
@objc func(_ sender: UIButton, for controlEvents: UIControl.Event)


아래의 3개의 action 가능 (UIEvent와 UIControl.Event는 아예 다른거임 조심, UIEvent는 좌표같이 상세한 이벤트 정보)
@IBAction func doSomething()
@IBAction func doSomething(sender: UIButton)
@IBAction func doSomething(sender: UIButton, forEvent event: UIEvent)
-> 실험해보니 기본적으론 sender만 있는 함수로 생성됨
-> 그래서 나중에 인자 바꾸면 오류남; 1, 3번 쓸려면 미리 만들고 이어주어야할 듯


* 인터페이스 빌더가 만능은 아니구나... 없는 것들은 코드로 구현해줘야하넹


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
UIControl.State


normal
The normal, or default state of a control—that is, enabled but neither selected nor highlighted.
highlighted
Highlighted state of a control.
disabled
Disabled state of a control.
selected
Selected state of a control.
focused
Focused state of a control.
application
Additional control-state flags available for application use.
reserved
Control-state flags reserved for internal framework use.

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
UIControl.Event

touchDown
컨트롤을 터치했을 때 발생하는 이벤트
UIControl.Event.touchDown

touchDownRepeat
컨트롤을 연속 터치 할 때 발생하는 이벤트
UIControl.Event.touchDownRepeat
 
touchDragInside
컨트롤 범위 내에서 터치한 영역을 드래그 할 때 발생하는 이벤트
UIControl.Event.touchDragInside
 
touchDragOutside
터치 영역이 컨트롤의 바깥쪽에서 드래그 할 때 발생하는 이벤트
UIControl.Event.touchDragOutside
 
touchDragEnter
터치 영역이 컨트롤의 일정 영역 바깥쪽으로 나갔다가 다시 들어왔을 때 발생하는 이벤트
UIControl.Event.touchDragEnter
 
touchDragExit
터치 영역이 컨트롤의 일정 영역 바깥쪽으로 나갔을 때 발생하는 이벤트
UIControl.Event.touchDragExit
 
touchUpInside
컨트롤 영역 안쪽에서 터치 후 뗐을때 발생하는 이벤트
UIControl.Event.touchUpInside
 
touchUpOutside
컨트롤 영역 안쪽에서 터치 후 컨트롤 밖에서 뗐을때 이벤트
UIControl.Event.touchUpOutside
 
touchCancel
터치를 취소하는 이벤트 (touchUp 이벤트가 발생되지 않음)
UIControl.Event.touchCancel
 
valueChanged
터치를 드래그 및 다른 방법으로 조작하여 값이 변경되었을때 발생하는 이벤트
UIControl.Event.valueChanged
 
primaryActionTriggered
버튼이 눌릴때 발생하는 이벤트 (iOS보다는 tvOS에서 사용)
UIControl.Event.primaryActionTriggered
 
editingDidBegin
UITextField에서 편집이 시작될 때 호출되는 이벤트
UIControl.Event.editingDidBegin
 
editingChanged
UITextField에서 값이 바뀔 때마다 호출되는 이벤트
UIControl.Event.editingChanged
 
editingDidEnd
UITextField에서 외부객체와의 상호작용으로 인해 편집이 종료되었을 때 발생하는 이벤트
UIControl.Event.editingDidEnd
 
editingDidEndOnExit
UITextField의 편집상태에서 키보드의 return 키를 터치했을 때 발생하는 이벤트
UIControl.Event.editingDidEndOnExit
 
allTouchEvents
모든 터치 이벤트
UIControl.Event.allTouchEvents
 
allEditingEvents
UITextField에서 편집작업의 이벤트
UIControl.Event.allEditingEvents
 
applicationReserved
각각의 애플리케이션에서 프로그래머가 임의로 지정할 수 있는 이벤트 값의 범위
UIControl.Event.applicationReserved
 
systemReserved
프레임워크 내에서 사용하는 예약된 이벤트 값의 범위
UIControl.Event.systemReserved
 
allEvents
시스템 이벤트를 포함한 모든 이벤트
UIControl.Event.allEvents
