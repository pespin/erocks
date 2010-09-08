int main(string[] args) {

	Elm.init(args);
	stdout.printf("Erocks started!\n");
		
		/* create a glib mainloop */
    var gmain = new GLib.MainLoop( null, false );

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
    
    DB = new eRocksDB();

    /*var songs = DB.get_all_songs();
    
    foreach(var song in songs) {
			stdout.printf("SONG -> title: %s; album: %s; author: %s;\n", song.title, song.get_album_name(), song.get_artist_name()); 
	}
	
	var albums = DB.get_all_albums();
    
    foreach(var album in albums) {
			stdout.printf("ALBUM -> title: %s; author: %s;\n", album.name, album.get_artist_name()); 
	} 
	
	var artists = DB.get_all_artists(); 

	stdout.printf("\n\n-------------------------\n\n\n\n"); */
	
    var artists = DB.get_all_artists(); 
    foreach(var artist in artists) {
			stdout.printf("ARTIST="+artist.name+";\n");
			Album[]? album_list = artist.get_albums();
			foreach (var album in album_list) {
				stdout.printf("\tALBUM="+album.name+";\n");
				Song[]? song_list = album.get_songs();
				
				foreach(var song in song_list) {
						stdout.printf("\t\tSONG="+song.title+";\n");
				}
				
			} 
	}
	
	var random_song = DB.get_random_song();
	
	stdout.printf("Got random song with tittle: %s\n", random_song.title);
	
	PLAYER = new eRocksPlayer(args);
	PLAYER.play(random_song);

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
