package events {

import com.styleru.events.EventAdv;

/**
 * ...
 * @author Frankie Wilde
 */
public class MainModelEvent extends EventAdv {

	static public const INIT:String = "init";
	static public const CHANGE:String = "change";


	public function MainModelEvent(type:String, data:* = null) {
		super(type, data);
	}

}

}