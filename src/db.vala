
const string DEFAULT_PLAYLIST_DIR = "/media/part_ext4/musica";

const string DEFAULT_ARTIST_NAME = "Unknown";
const string DEFAULT_ALBUM_NAME = "Unknown";
const string DEFAULT_SONG_NAME = "Unknown";


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
	
	
	
	public void create_tables() {
			this.create_table_songs();
			this.create_table_albums();
			this.create_table_artists();
			this.fill();
		}
	
	
	
	private void create_table_songs() {
		int rc;
		string sql;
		string errmsg;
		
		sql = "CREATE  TABLE  'main'.'songs' ('id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , 'path' VARCHAR NOT NULL  UNIQUE , 'title' VARCHAR, 'album' INTEGER, 'artist' INTEGER, 'duration' INTEGER)";
	
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
	
	public void fill() {
		
		this.add_songs_in_dir.begin(DEFAULT_PLAYLIST_DIR); //TODO: change this
		
		}
	
	
    private async void add_songs_in_dir (string path) {
        stdout.printf ("Scanning dir %s for songs...\n", path);
        var dir = File.new_for_path (path);
        try {
            // asynchronous call, to get directory entries
            var e = yield dir.enumerate_children_async (FILE_ATTRIBUTE_STANDARD_NAME+","+FILE_ATTRIBUTE_STANDARD_TYPE,
                                                        0, Priority.DEFAULT, null);
            while (true) {
                // asynchronous call, to get entries so far
                var files = yield e.next_files_async (10, Priority.DEFAULT, null);
                if (files == null) {
                    break;
                }
                // append the files found so far to the list
                foreach (var elem in files) {
					
					if (elem.get_file_type() == FileType.DIRECTORY) {
						stdout.printf("DIR: "+elem.get_name ()+"\n");
						yield this.add_songs_in_dir(path+"/"+elem.get_name());
					} else {
						stdout.printf("File: "+elem.get_name ()+" -->"+elem.get_file_type().to_string()+"\n");
						this.add_file_to_db(path+"/"+elem.get_name());
						elem=null;
                   }
                   
                }
            }
        } catch (Error err) {
            stderr.printf ("Error: list_files failed: %s\n", err.message);
        }
    }
    
    public void add_file_to_db(string path) {
		
		string sql;
		int rc; 
		string err;
		
		var file = new TagLib.File(path);
		
		if(file==null) return;
		
		if(file.tag.artist=="" || file.tag.artist==null) {
			stdout.printf("Artist tag on %s is empty, setting it to default %s\n", path, DEFAULT_ARTIST_NAME);
			file.tag.artist = DEFAULT_ARTIST_NAME;
		}
		
		if(file.tag.album=="" || file.tag.album==null) {
			stdout.printf("Album tag on %s is empty, setting it to default %s\n", path, DEFAULT_ALBUM_NAME);
			file.tag.album = DEFAULT_ALBUM_NAME;
		}
		
		uint artist_id = this.get_artist_id(file.tag.artist);
		uint album_id = this.get_album_id(file.tag.album, artist_id);
		
		sql ="INSERT INTO \"main\".\"songs\" (\"path\", \"title\", \"album\", \"artist\", \"duration\") VALUES(\""+path+"\",\""+file.tag.title+"\",\""+album_id.to_string()+"\",\""+artist_id.to_string()+"\",\""+file.audioproperties.length.to_string()+"\")";
		//stdout.printf(sql+"\n");
		if( (rc=db.exec(sql, null, out err)) !=0 )
			stdout.printf("ERR: Adding song to database ended with error code %d (error: %s)\n", rc, err); 
		
	}
	
	private uint get_artist_id(string name) {
		//if artist exists, get it's id, else create it:
		
		string[] res;
		int rc, nrow, ncol;
		string err, sql;
		
		sql = "SELECT id FROM \"main\".\"artists\" WHERE name=\""+name+"\"";
		
		rc = db.get_table (sql, out res, out nrow, out ncol, out err); 
			if( rc != Sqlite.OK) {
				stderr.printf ("ERR: Can't retrieve artist name %s from database: %d, %s\n", name, rc, err);
				return 0;
			}
		//exists:	
		if(nrow>0) {
			stdout.printf("Found id for artist %s: %s\n", name, res[1]);
			return (uint) res[1].to_int();
			
		}	else { // doesn't exist, create it:
			
			sql ="INSERT INTO \"main\".\"artists\" (\"name\") VALUES (\""+name+"\")";
			//stdout.printf(sql+"\n");
	 		if( (rc=db.exec(sql, null, out err)) !=0 )
				stdout.printf("ERR: Adding artist to database ended with error code %d (error: %s)\n", rc, err); 
			
			return (uint) db.last_insert_rowid(); 
			
		}	
	
	}
	
	private uint get_album_id(string name, uint artist_id) {
		//if album from given artist exists, get it's id, else create it:
		
		string[] res;
		int rc, nrow, ncol;
		string err, sql;
		
		sql = "SELECT id FROM \"main\".\"albums\" WHERE name=\""+name+"\" AND artist=\""+artist_id.to_string()+"\"";
		
		rc = db.get_table (sql, out res, out nrow, out ncol, out err); 
			if( rc != Sqlite.OK) {
				stderr.printf ("ERR: Can't retrieve album name %s from database: %d, %s\n", name, rc, err);
				return 0;
			}
		//exists:	
		if(nrow>0) {
			stdout.printf("Found id for album %s: %s\n", name, res[1]);
			return (uint) res[1].to_int();
			
		}	else { // doesn't exist, create it:
			
			sql ="INSERT INTO \"main\".\"albums\" (\"name\", \"artist\") VALUES (\""+name+"\", \""+artist_id.to_string()+"\")";
	 		if( (rc=db.exec(sql, null, out err)) !=0 )
				stdout.printf("ERR: Adding album to database ended with error code %d (error: %s)\n", rc, err); 
			
			return (uint) db.last_insert_rowid(); 
			
		}	
	
	}
	
}
