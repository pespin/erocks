

public class eRocksDB : Object {
	
	
	public string sqlitepath { get; set;};
	
	
	public eRocksDB(string path_to_sqlite_file) {
		
		sqlitepath = path_to_sqlite_file;
		/*
		 * TODO: check if exists. if not -> create new one
		 */
		
		
	}
	
	
	public Song[] get_all_songs() {}
	public Album[] get_all_albums() {}
	public Artist[] get_all_artists() {}
	
	public Song[] get_matching_songs() {}
	public Album[] get_matching_albums() {}
	public Artist[] get_matching_artists() {}	
	
	
	public void add_song(Song song) {}
	
	
	
	public void create_tables() {
			this.create_table_songs();
			this.create_table_albums();
			this.create_table_artists();
		}
	
	
	
	private void create_table_songs() {
	
	/*
	 * CREATE  TABLE "main"."songs" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , "path" VARCHAR NOT NULL  UNIQUE , "name" VARCHAR, "album" INTEGER, "artist" INTEGER, "duration" INTEGER)
	*/	
		
	}
	
		private void create_table_albums() {
		
	/*
	 * CREATE  TABLE "main"."albums" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , "name" VARCHAR, "artist" INTEGER)
	 */	
		
	}
	
			private void create_table_artists() {
		
	/*
	 * CREATE  TABLE "main"."artists" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , "name" VARCHAR NOT NULL  UNIQUE )
	 */	
		
	}
	
	public void fill() {}
	
}
