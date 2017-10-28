fl.outputPanel.clear();

fl.trace("------------------------------------------------");
fl.trace("flashOptimize()");
fl.trace("------------------------------------------------");

var doc = fl.getDocumentDOM();

var lib = doc.library;

var libItems = lib.items;
for( var i = 0; i < libItems.length; i++ ){
	var itm = libItems[ i ];
	lib.selectItem(itm.name);
	lib.editItem(itm.name);
	
	fl.trace(i+") "+ itm.name );
	
	// get the current timeline
	var myTimeLine = doc.getTimeline();
	//doc.selectAll();
	
	myTimeLine.selectAllFrames();
	
	var selectedItems = doc.selection;
	for( var j = 0; j < selectedItems.length; j ++ ){
		var selectedItem = selectedItems[ j ];
		if(selectedItem.elementType == "shape" ){
			
			fl.trace("---------------------------------");
			fl.trace("selected: " + selectedItem);
			fl.trace("itemType: " + selectedItem.elementType);
		
			if(selectedItem.isGroup){
				doc.unGroup();
			}
			doc.optimizeCurves(100, true);
		}
	}
}
lib.selectNone();
