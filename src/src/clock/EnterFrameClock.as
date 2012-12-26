/**
 * ...
 * @author V.Pavkin
 */
package clock {
import flash.display.DisplayObject;
import flash.display.Stage;
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.getTimer;

/**
 * Точные, платформо- и браузерно-независимые часы, основанные на разнице в системном времени между двумя кадрами.
 *
 * @see ru.qiwi.bridge.time.IClock
 * @see ru.qiwi.bridge.time.ClockEvent
 */
public class EnterFrameClock extends EventDispatcher {

	private var _stage:Stage;
	private var _isDisposed:Boolean;

	private var prevTime:uint = 0;
	private var nowTime:uint = 0;

	/**
	 * Создает объект <code>EnterFrameClock</code>, который начинает генерировать события изменения времени как только станет доступным
	 * @param stageProvider Объект <code>DisplayObject</code>, предоставляющий ссылку на stage.<br/>
	 * Объект не обязательно должен быть добавлен на сцену, таймер воспользуется ссылкой на <code>stage</code>, когда она будет доступна.
	 */
	public function EnterFrameClock(stageProvider:DisplayObject) {
		if (stageProvider.stage) {
			start(stageProvider.stage)
		} else {
			stageProvider.addEventListener(Event.ADDED_TO_STAGE, onStageProviderAddedToStage)
		}
	}

	private function start(stage:Stage):void {
		_stage = stage;
		_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame)
	}

	private function onEnterFrame(event:Event):void {
		prevTime = nowTime;
		nowTime = getTimer();
		dispatchEvent(new DataEvent('update'));
	}

	public function get period():Number {
		return nowTime - prevTime;
	}

	private function onStageProviderAddedToStage(event:Event):void {
		event.target.removeEventListener(Event.ADDED_TO_STAGE, onStageProviderAddedToStage)
		start(event.target.stage)
	}

	public function dispose():void {
		if (_stage)
			_stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame)
		_isDisposed = true;
	}

	public function get isDisposed():Boolean {
		return true;
	}
}
}
