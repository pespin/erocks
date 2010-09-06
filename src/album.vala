public class Album {
	
		
	public uint id;
	public uint artist_id;
	public string name;
	
	public Album.filled(uint album_id, string name, uint artist_id) {
		this.id = album_id;
		this.name = name;
		this.artist_id = artist_id;
	}
	
	public string get_artist_name() {
		string sql;
		
		sql = "SELECT name FROM \"main\".\"artists\" WHERE id=\""+this.artist_id.to_string()+"\"";
		return DB.fetch_field_from_sql(sql);
	}
	
	
	public Song[]? get_songs() {
	
		string sql;
		sql = "SELECT id,path,title,album,artist,duration FROM 'main'.'songs' WHERE album='"+this.id.to_string()+"' ORDER BY title";
		return DB.get_songs_from_sql(sql);
		
	}
	
}
