package models {
	
	import events.MainModelEvent;
	import interfaces.IMainModel;
	import interfaces.IObject;
	import nape.phys.Body;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	
	public class MainModel extends Model implements IMainModel {
		
		private var _objects:Vector.<Body>;
		
		
		public function MainModel() {
			_objects = new Vector.<Body>();
		}
		
		public function get objects():Vector.<Body> {
			return _objects;
		}
		
		public function start():void {
			dispatchEvent(new MainModelEvent(MainModelEvent.INIT));
		}
		
		public function refresh():void {
			dispatchEvent(new MainModelEvent(MainModelEvent.CHANGE));
		}
		
	}

}
