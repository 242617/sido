package models {
	
	import events.MainModelEvent;
	import interfaces.IMainModel;
	import interfaces.IObject;
	import views.objects.Box;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	
	public class MainModel extends Model implements IMainModel {
		
		private var _objects:Vector.<IObject>;
		
		
		public function MainModel() {
			_objects = new Vector.<IObject>();
		}
		
		public function get objects():Vector.<IObject> {
			return _objects;
		}
		
		public function start():void {
			addObject(new Box());
			dispatchEvent(new MainModelEvent(MainModelEvent.INIT));
		}
		
		public function refresh():void {
			dispatchEvent(new MainModelEvent(MainModelEvent.CHANGE));
		}
		
		public function addObject(object:IObject):void {
			_objects.push(object);
		}
		
	}

}
