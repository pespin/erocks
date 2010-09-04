public class eRocksDB : Object {
	
	
	public string sqlitepath { get; set;}
	private Sqlite.Database db;
	
	public eRocksDB.file(string path_to_sqlite_file) {
		
		this.sqlitepath = path_to_sqlite_file;
		
		int rc;
		bool create=false;
		
		
		/*First check if file path exists: if not, create it */
		if(!FileUtils.test (path_to_sqlite_file, GLib.FileTest.EXISTS)) {
				stdout.printf("db file [%s] doesn't exist, creating it...\n", path_to_sqlite_file);
				create=true;
				Posix.mkdir( Path.get_dirname(path_to_sqlite_file), Posix.S_IRWXU );	
		}
		
		
		rc = Sqlite.Database.open(path_to_sqlite_file, out db); 
			if (rc != Sqlite.OK) {
				stderr.printf ("ERR: Can't open database: %d, %s\n", rc, db.errmsg ());
				return;
			}
			
		stdout.printf("Database loaded correctly!\n");
		
		if(create) this.create_tables();
		
	}
	
	public eRocksDB() {
		this.file(Environment.get_home_dir()+"/.erocks/erocks.db");
	}
	
	
	/*
	public Song[] get_all_songs() {}
	public Album[] get_all_albums() {}
	public Artist[] get_all_artists() {}
	
	public Song[] get_matching_songs() {}
	public Album[] get_matching_albums() {}
	public Artist[] get_matching_artists() {}	
	
	*/
	public void add_song(Song song) {}
	
	
	
	public void create_tables() {
			this.create_table_songs();
			this.create_table_albums();
			this.create_table_artists();
		}
	
	
	
	private void create_table_songs() {
		int rc;
		string sql;
		string errmsg;
		
		sql = "CREATE  TABLE  'main'.'songs' ('id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , 'path' VARCHAR NOT NULL  UNIQUE , 'name' VARCHAR, 'album' INTEGER, 'artist' INTEGER, 'duration' INTEGER)";
	
		if( (rc=db.exec(sql, null, out errmsg)) !=0 )
			stdout.printf("Creating table songs finished with error code %d (error: %s)\n", rc, errmsg); 
		
	}
	
	private void create_table_albums() {
		int rc;
		string sql;
		string errmsg;
		
		sql = "CREATE  TABLE 'main'.'albums' ('id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , 'name' VARCHAR, 'artist' INTEGER)";
		
		if( (rc=db.exec(sql, null, out errmsg)) !=0 )
			stdout.printf("Creating table albums finished with error code %d (error: %s)\n", rc, errmsg); 
		
	}
	
	private void create_table_artists() {
	
		int rc;
		string sql;
		string errmsg;
		
		sql = "CREATE  TABLE 'main'.'artists' ('id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , 'name' VARCHAR NOT NULL  UNIQUE )";
	 
		if( (rc=db.exec(sql, null, out errmsg)) !=0 )
			stdout.printf("Creating table artists finished with error code %d (error: %s)\n", rc, errmsg); 
		
	}
	
	public void fill() {}
	
}
