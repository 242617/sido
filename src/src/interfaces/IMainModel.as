package interfaces {
	
	import com.styleru.stage3d.interfaces.IModelWrapper;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	public interface IMainModel extends IEventDispatcher {
		
		function get objects():Vector.<IObject>;
		
		function start():void;
		
		function refresh():void;
		
	}

}
