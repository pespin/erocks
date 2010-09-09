PlayerViewUI UI;

public class PlayerViewUI : Object {
	
	EcoreEvas.Window win;
	Edje.Object edje_obj;
	
	public PlayerViewUI() {
			
	/* create a window */
    win = new EcoreEvas.Window( "software_x11", 0, 0, 320, 480, null );
    win.title_set( "Edje Example Application" );
    win.show();
    var evas = win.evas_get();

    /* create an edje */
    edje_obj = new Edje.Object( evas );
    edje_obj.file_set( "/usr/local/share/erocks/erocks.edj", "playerview" );
    edje_obj.resize( 320, 480 );
    edje_obj.layer_set( 0 );
    edje_obj.show();
	
	stdout.printf("Edje object created!\n");	
		
	}
	
	
	
}
