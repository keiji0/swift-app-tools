import XCTest
import AppToolsPrimitiveUI
import AppToolsData

class View: AppToolsPrimitiveUI.View {
    override init() {
        super.init()
    }
}

class ViewA: AppToolsPrimitiveUI.View {
    init(_ x: String) {
        print(x)
        super.init()
    }
}

class Window: AppToolsPrimitiveUI.Window {
}

final class Responder: XCTestCase {
    func test_Windowに所属していないとFirstResponderではない() {
        XCTAssertFalse(View().isFirstResponder)
    }
    
    func test_最初Windowは自身がFirstResponder() {
        XCTAssertTrue(Window().isFirstResponder)
    }
    
    func test_何も設定されていないと自身が最後のResponder() {
        let view = View()
        XCTAssertTrue(view.lastResponder === view)
    }
    
    func test_末尾のResponderまで辿れる() {
        let view1 = View()
        let view2 = View()
        let view3 = View()
        view2.superview = view1
        view3.superview = view2
        XCTAssertEqual(view3.lastResponder, view1)
    }
    
    func test_NextResponderを辿れる() {
        let superview = View()
        let view = View()
        view.superview = superview
        XCTAssertTrue(view.nextResponder === superview)
    }
    
    func test_responseChainを取得できる() {
        let view1 = View()
        let view2 = View()
        let view3 = View()
        let view4 = View()
        view1.addSubview(view2)
        view1.addSubview(view3)
        view3.addSubview(view4)
        XCTAssertEqual(view2.responseChain, [ view2, view1 ])
        XCTAssertEqual(view3.responseChain, [ view3, view1 ])
        XCTAssertEqual(view4.responseChain, [ view4, view3, view1 ])
    }
    
    func test_WindowがないとFirstResponderになれない() {
        let view = View()
        view.isFirstResponder = true
        XCTAssertFalse(view.isFirstResponder)
    }
    
    func test_WindowをつけるとFirstResponderに設定できる() {
        let window = Window()
        let view = View()
        view.superview = window
        view.isFirstResponder = true
        XCTAssertTrue(view.isFirstResponder)
    }
    
    func test_FirstResponderにすると以前のResponderはFirstじゃなくなる() {
        let window = Window()
        let view1 = View()
        let view2 = View()
        window.addSubview(view1)
        window.addSubview(view2)
        view1.isFirstResponder = true
        XCTAssertTrue(view1.isFirstResponder)
        
        view2.isFirstResponder = true
        XCTAssertFalse(view1.isFirstResponder)
    }
    
    func test_FirstResponderを切り替えると通知される() {
        let window = Window()
        let view1 = View()
        let view2 = View()
        window.addSubview(view1)
        window.addSubview(view2)
        view1.isFirstResponder = true
        XCTAssertEqual(view1.$isFirstResponder.receiveEvents { view2.isFirstResponder = true }, [false])
        XCTAssertEqual(view1.$isFirstResponder.receiveEvents { view1.isFirstResponder = true }, [true])
        XCTAssertEqual(window.$isFirstResponder.receiveEvents { view1.isFirstResponder = false }, [true])
    }

    func test_superViewの参照が消えると辿れなくなる() {
        let window = Window()
        var view1: View! = .init()
        let view2 = View()
        window.addSubview(view1)
        view1.addSubview(view2)
        XCTAssertNotNil(view2.superview)
        view1 = nil
        XCTAssertNil(view2.superview)
    }
}
