package interfaces {
	
	import com.styleru.stage3d.interfaces.IModelWrapper;
	import flash.events.IEventDispatcher;
	import nape.phys.Body;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	public interface IMainModel extends IEventDispatcher {
		
		function get objects():Vector.<Body>;
		
		function start():void;
		
		function refresh():void;
		
	}

}
