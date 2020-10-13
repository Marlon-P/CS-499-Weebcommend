class Anime{
  String title;
  String synopsis;
  double score;
  int mal_id;
  bool airing;
  int members;
  int episodes;
  String type;
  String rated;

  String getTitle(){
    return this.title;
  }
  String getSynopsis(){
    return this.synopsis;
  }
  double getScore(){
    return this.score;
  }
  int getMalId(){
    return this.mal_id;
  }
  bool getAiring(){
    return this.airing;
  }
  int getMembers(){
    return this.members;
  }
  int getEpisodesCount(){
    return this.episodes;
  }
  String getType(){
    return this.type;
  }
  String getRating(){
    return this.rated;
  }
  Anime({String title, String rated, String type, int episodes,int members,bool airing,int mal_id,double score,String synopsis}){
    this.title = title;
    this.mal_id = mal_id;
    this.rated = rated;
    this.synopsis = synopsis;
    this.type = type;
    this.episodes = episodes;
    this.members = members;
    this.airing=airing;
    this.score = score;
  }
}