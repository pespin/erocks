int main(string[] args) {

	Elm.init(args);
	stdout.printf("Emtooth started!\n");
		
		/* create a glib mainloop */
    gmain = new GLib.MainLoop( null, false );

    /* integrate glib mainloop into ecore mainloop */
    if ( Ecore.MainLoop.glib_integrate() )
    {
        message( "glib mainloop integration successfully completed" );
    }
    else
    {
        warning( "could not integrate glib mainloop. did you compile glib mainloop support into ecore?" );
    }
    
    
#if _FSO_
    /* Get CPU resource if fso is running */
    try {
			fso = Bus.get_proxy_sync (BusType.SYSTEM, "org.freesmartphone.ousaged", "/org/freesmartphone/Usage");
			fso.request_resource("CPU");
		} catch (IOError e) {
			stderr.printf ("Could not get access to org.freesmartphone.ousaged: %s\n", e.message);
		}
#endif
    


	/* ENTER MAIN LOOP */
    Elm.run();
    Elm.shutdown();
    
    
#if _FSO_    
	try {
		fso.release_resource("CPU");
	} catch (IOError e) {
		stderr.printf ("Could not get access to org.freesmartphone.ousaged: %s\n", e.message);
	}
#endif   
    
    return 0;

}
