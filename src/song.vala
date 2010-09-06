public class Song {
	
	public uint song_id;
	public string path;
	public string title;
	public uint album_id;
	public uint artist_id;
	public uint duration_sec;
	
	
	
	public Song.filled(uint song_id, string path, string title, uint album_id, uint artist_id, uint duration_sec) {
		this.song_id = song_id;
		this.path = path;
		this.title = title;
		this.album_id = album_id;
		this.artist_id = artist_id;
		this.duration_sec = duration_sec;
	}
	
	
	
	public string get_album_name() {
		string sql;
		
		sql = "SELECT name FROM \"main\".\"albums\" WHERE id=\""+this.album_id.to_string()+"\"";
		return DB.fetch_field_from_sql(sql);
	}
	
	public string get_artist_name() {
		string sql;
		
		sql = "SELECT name FROM \"main\".\"artists\" WHERE id=\""+this.artist_id.to_string()+"\"";
		return DB.fetch_field_from_sql(sql);
	}

	
}
