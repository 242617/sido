package interfaces {
	
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	public interface IMainModel extends IEventDispatcher {
		
		function get bouncingObjects():Vector.<IObject>;
		
	}
	
}