public class Artist {
	
	public uint id;
	public string name;
	
	public Album[]? get_albums() {
		string sql;
		
		sql = "SELECT id,name,artist FROM 'main'.'albums' WHERE artist='"+this.id.to_string()+"' ORDER BY name";
		return DB.get_albums_from_sql(sql);
	}
	
	public Song[]? get_songs() {
	
		string sql;
		sql = "SELECT id,path,title,album,artist,duration FROM 'main'.'songs' WHERE artist='"+this.id.to_string()+"' ORDER BY title";
		return DB.get_songs_from_sql(sql);
		
	}
	
}
