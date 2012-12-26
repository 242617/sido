package clock {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.TimerEvent;

/**
 * Секундный таймер, основанный на глобальных часах из ClockManager. По истечении заданного пользователем времени вызывает callback.
 *
 * @see ru.qiwi.bridge.time.ClockManager
 */
public class SecondsTimer extends EventDispatcher {

	private static const TICK:uint = 83; // 1 c

	private var _timeElapsed:uint = 0;
	private var _ticks:uint = 0;
	private var _clock:EnterFrameClock;

	/**
	 *
	 * @param seconds Время в секундах, по истечении которого нужно вызвать callback.
	 * @param onFinishCallback Функция, которую нужно вызвать по завершении.
	 * Значение по умолчанию: <code>null</code>.
	 * @param params Параметры для callback-функции.
	 * Значение по умолчанию: <code>null</code>.
	 */
	public function SecondsTimer(clock:EnterFrameClock) {
		this._clock = clock
		this._clock.addEventListener('update', onClockEvent);
	}

	private function onClockEvent(event:Event):void {
		_timeElapsed += _clock.period;
		if (_timeElapsed % TICK < _clock.period) {
			_ticks = uint(_timeElapsed / TICK)
			this.dispatchEvent(new Event(TimerEvent.TIMER));
		}
	}
}
}